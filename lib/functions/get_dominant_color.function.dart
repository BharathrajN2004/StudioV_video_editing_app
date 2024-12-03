import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:video_editing_app/providers/project_starter.provider.dart';

Future findDominantGreenColor(WidgetRef ref, String imagePath) async {
  try {
    debugPrint("Processing file: $imagePath");

    final imageFile = File(imagePath);
    final image = await decodeImageFromList(imageFile.readAsBytesSync());

    ProjectStateNotifier notifier = ref.read(projectProvider.notifier);
    ProjectState projectState = ref.watch(projectProvider);

    PaletteGenerator paletteGenerator = await PaletteGenerator.fromImage(
      image,
      maximumColorCount: 20,
    );

    // Ensure the palette contains colors
    if (paletteGenerator.colors.isEmpty) {
      debugPrint("No colors found in the palette.");
      return;
    }

    Color? dominantGreenColor;

    for (Color color in paletteGenerator.colors) {
      HSVColor hsvColor = HSVColor.fromColor(color);
      // Check if the hue is within the green range (approx. 60-180 degrees in HSV)
      // and ensure that the color is sufficiently saturated and bright
      if (hsvColor.hue >= 60 &&
          hsvColor.hue <= 180 &&
          hsvColor.saturation > 0.5 &&
          hsvColor.value > 0.5) {
        dominantGreenColor = color;
        break;
      }
    }

    if (dominantGreenColor != null) {
      debugPrint('Dominant Green Color: ${dominantGreenColor.toString()}');
      notifier.setChromakey(dominantGreenColor);
    } else {
      if (projectState.chromakey == null) {
        notifier.setChromakey(Colors.black);
        debugPrint('No dominant green color found');
      }
    }
  } catch (e) {
    debugPrint("Error finding dominant green color: $e");
  }
}

Future getDominantColor({required WidgetRef ref}) async {
  ProjectState projectState = ref.watch(projectProvider);
  String videoName = projectState.videoName!;
  File video = projectState.videoFile!;

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String tumbNailDirPath = path.join(
      appDocDir.path, "tb", videoName.substring(0, videoName.length - 4));

  // Create the frames directory if it doesn't exist
  final Directory tbDirectory = Directory(tumbNailDirPath);
  if (!tbDirectory.existsSync()) {
    tbDirectory.createSync(recursive: true);
  }

  List<int> indexList = [];

  // Set up the watcher to listen for new files in the directory
  StreamSubscription<FileSystemEvent>? subscription;
  subscription = tbDirectory.watch().listen((event) async {
    if (event.path.endsWith('.png')) {
      int index = int.parse(
          event.path.substring(event.path.length - 6, event.path.length - 4));

      if (!indexList.contains(index)) {
        ref.read(projectProvider.notifier).addImagePath(event.path);
        findDominantGreenColor(ref, event.path);
        indexList.add(index);
      }

      if (index >= 6) {
        subscription!.cancel();
      }
    }
  });

  final String tumbNailPath = path.join(tumbNailDirPath, "output%03d.png");

  String command =
      '''-i ${video.path} -vf "select=\'not(mod(n\\,100))\'" -vsync vfr -frames:v 6 $tumbNailPath''';

  FFmpegSession session = await FFmpegKit.execute(command);
  final returnCode = await session.getReturnCode();

  if (ReturnCode.isSuccess(returnCode)) {
    debugPrint('TumbNail extracted successfully');
  } else {
    debugPrint('Failed to extract tumbnail');
  }
}
