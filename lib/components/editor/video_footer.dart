import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:video_player/video_player.dart';

import '../../providers/controller.provider.dart';
import '../../utilities/theme.dart';

class VideoFooter extends ConsumerWidget {
  const VideoFooter({super.key});

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    // Extract hours and minutes
    String hours = twoDigits(duration.inMinutes);
    String minutes = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    final videoState = ref.watch(videoManagerProvider);
    final videoManager = ref.watch(videoManagerProvider.notifier);

    VideoPlayerController controller =
        videoState.videoControllers[videoState.currentVideoIndex];

    return Row(
      children: [
        SizedBox(
          width: width * .35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: width * 0.05),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Symbols.undo_rounded,
                  color: iconColor,
                  size: aspectRatio * midIconSize,
                  weight: 500,
                  grade: 200,
                ),
              ),
              SizedBox(width: width * 0.04),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Symbols.redo_rounded,
                  color: inactiveTextColor,
                  size: aspectRatio * midIconSize,
                  weight: 500,
                  grade: 200,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => videoState.isVideoPlaying
              ? videoManager.pauseCurrent()
              : videoManager.playCurrent(),
          icon: Icon(
            !videoState.isVideoPlaying
                ? Symbols.play_arrow_rounded
                : Symbols.pause_rounded,
            color: iconColor,
            size: aspectRatio * largeIconSize,
            fill: 1.0,
            weight: 700,
            grade: 200,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: width * .35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formatDuration(controller.value.position),
                style: TextStyle(
                    fontSize: aspectRatio * largeTextSize,
                    color: textColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: width * .02),
              Text(
                formatDuration(videoState.totalDuration),
                style: TextStyle(
                    fontSize: aspectRatio * (midTextSize + 1),
                    color: inactiveTextColor,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }
}
