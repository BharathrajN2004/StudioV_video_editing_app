import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:video_player/video_player.dart';

import '../../providers/controller.provider.dart';
import '../../providers/project_starter.provider.dart';

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

    ProjectState projectState = ref.watch(projectProvider);

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
                  ShaderBuilder(
                    assetKey: 'assets/shaders/color_replace.frag',
                    (BuildContext context, FragmentShader shader, _) =>
                        AnimatedSampler(
                      (ui.Image image, Size size, Canvas canvas) {
                        shader
                          ..setFloat(0, size.width)
                          ..setFloat(1, size.height)
                          ..setImageSampler(0, image);
                        Color color = projectState.chromakey!;
                        // Convert color to premultiplied opacity.
                        shader.setFloat(
                            2, color.red / 255 * color.opacity); // uColor r
                        shader.setFloat(
                            3, color.green / 255 * color.opacity); // uColor g
                        shader.setFloat(
                            4, color.blue / 255 * color.opacity); // uColor b
                        shader.setFloat(5, color.opacity);
                        canvas.drawRect(
                            Offset.zero & size, Paint()..shader = shader);
                      },
                      child: Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .35,
                          width: MediaQuery.of(context).size.width,
                          child: VideoPlayer(controller),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
