import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../providers/controller.provider.dart';
import '../providers/project_starter.provider.dart';
import 'extract_frames.function.dart';

String colorToHex(Color color) {
  return color.value
      .toRadixString(16)
      .padLeft(6, '0')
      .toUpperCase()
      .substring(2);
}

Future<bool> greenScreenRemover({
  required WidgetRef ref,
}) async {
  ProjectState projectState = ref.watch(projectProvider);
  String videoName = projectState.videoName!;
  File video = projectState.videoFile!;

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String gsVideopath = path.join(
      appDocDir.path, "gs", videoName.substring(0, videoName.length - 4));

  // Create the frames directory if it doesn't exist
  final Directory videoDir = Directory(gsVideopath);
  if (!videoDir.existsSync()) {
    videoDir.createSync(recursive: true);
  }

  // Adjust the FFmpeg command to use bitrate control instead of crf
  String command = '-i ${video.path} '
      '-filter_complex "[0:v]chromakey=${colorToHex(projectState.chromakey!)}:0.03:0.2[ckout];'
      'color=black[bg];[bg][ckout]scale2ref[bgout][ckout];[bgout][ckout]overlay=shortest=1[out]" '
      '-map "[out]" -map 0:a? -c:v mpeg4 -b:v 2M -c:a copy $gsVideopath/output.mp4';

  // Enable log and statistics callbacks for debugging
  FFmpegKitConfig.enableLogCallback((log) {
    debugPrint(log.getMessage());
  });

  FFmpegSession ffmpegSession = await FFmpegKit.execute(command);

  final returnCode = await ffmpegSession.getReturnCode();
  if (ReturnCode.isCancel(returnCode)) {
    debugPrint("FFmpeg command was cancelled.");
    return false;
  } else if (ReturnCode.isSuccess(returnCode)) {
    debugPrint("FFmpeg command executed successfully.");

    final File videoFile = File("$gsVideopath/output.mp4");
    ref.read(videoManagerProvider.notifier).addVideoFromFile(videoFile);

    extractFrames(
      videoFile: videoFile,
      notifier: ref.read(videoManagerProvider.notifier),
      projectNotifier: ref.read(projectProvider.notifier),
      videoName: videoName,
    );

    return true;
  } else {
    debugPrint("FFmpeg command failed with return code $returnCode.");
    return false;
  }
}
