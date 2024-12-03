import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../providers/controller.provider.dart';
import '../providers/project_starter.provider.dart';

Future extractFrames({
  required File videoFile,
  required VideoManager notifier,
  required ProjectStateNotifier projectNotifier,
  required String videoName,
}) async {
  // Get the application documents directory
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String framesDirPath =
      path.join(appDocDir.path, videoName.substring(0, videoName.length - 4));

  // Create the frames directory if it doesn't exist
  final Directory framesDir = Directory(framesDirPath);
  if (!framesDir.existsSync()) {
    framesDir.createSync(recursive: true);
  }

  notifier.setFrameDir(framesDir);

  // Monitor the frames directory for new files
  StreamSubscription<FileSystemEvent>? subscription;
  bool firstFrameExtracted = false;

  subscription = framesDir.watch().listen((event) {
    if (event.path.endsWith('.png')) {
      if (!firstFrameExtracted) {
        Future.delayed(const Duration(milliseconds: 1200), () {
          projectNotifier.markAsCompleted();
          // Cancel the subscription once the first fame extraction is complete
          subscription!.cancel();
        });
        firstFrameExtracted = true;
      }
    }
  });

  FFmpegSession session = await FFmpegKit.execute(
      '-i ${videoFile.path} -vf fps=1 $framesDirPath/frame_%04d.png');
  final returnCode = await session.getReturnCode();

  if (ReturnCode.isSuccess(returnCode)) {
    debugPrint('Frame extracted successfully');
  } else {
    debugPrint('Failed to extract frames');
  }
}
