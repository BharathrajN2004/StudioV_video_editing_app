import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../providers/controller.provider.dart';

class VideoContainer extends ConsumerStatefulWidget {
  const VideoContainer({
    super.key,
  });

  @override
  ConsumerState<VideoContainer> createState() => VideoContainerState();
}

class VideoContainerState extends ConsumerState<VideoContainer> {
  double positionX = 0;
  double positionY = 0;
  double scale = 1.0;
  double initialScale = 1.0;
  bool isHorizontalCenter = false;
  bool isVerticalCenter = false;

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    // double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    final videoState = ref.watch(videoManagerProvider);
    // final videoManager = ref.watch(videoManagerProvider.notifier);

    VideoPlayerController controller =
        videoState.videoControllers[videoState.currentVideoIndex];

    return Expanded(
      flex: 5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double aspectRatio = controller.value.aspectRatio;
          double maxWidth = constraints.maxWidth;
          double maxHeight = constraints.maxHeight;
          double height = maxHeight;
          double width = height * aspectRatio;

          if (width > maxWidth) {
            width = maxWidth;
            height = width / aspectRatio;
          }

          return Center(
            child: SizedBox(
              height: height,
              width: width,
              child: Stack(
                children: [
                  VideoPlayer(controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
