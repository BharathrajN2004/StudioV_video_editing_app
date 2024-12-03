import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';

import '../components/text.dart';
import '../providers/project_starter.provider.dart';
import '../views/project_settings_page.dart';
import 'get_dominant_color.function.dart';

Future<void> pickVideo(
    {required BuildContext context, required WidgetRef ref}) async {
  final ImagePicker picker = ImagePicker();
  final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

  if (video != null) {
    final File videoFile = File(video.path);
    ref
        .read(projectProvider.notifier)
        .setVideoFile(video: videoFile, name: video.name);
    getDominantColor(ref: ref);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProjectSettingsPage()));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.black87,
        duration: Durations.long4,
        content: Center(
          child: CustomText(
            text: "U have not selected any video!",
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
