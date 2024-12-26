import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:video_editing_app/components/editor/sub_widgets/text_editing_field.dart';
import 'package:video_editing_app/components/text.dart';
import 'package:video_editing_app/utilities/theme.dart';
import 'package:video_player/video_player.dart';

import '../../models/text_editor_class.model.dart';
import '../../providers/active_layer.provider.dart';
import '../../providers/controller.provider.dart';
import '../../providers/project_starter.provider.dart';
import '../../providers/text_editor.provider.dart';
import '../../providers/text_extension_container.provider.dart';
import '../../utilities/constants.dart';

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
  double fontSize = 20;
  double _baseScaleFactor = 1.0; // Keeps track of the base scale factor

  double flag = 0;

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

    TextEditorClass? textEditorClass = ref.watch(textExtensionProvider);

    List<TextEditorClass> textList = ref.watch(textEditorProvider);
    TextEditorNotifier textEditorNotifier =
        ref.read(textEditorProvider.notifier);
    // print(textList[0].xPosition);

    (Layers, Key?)? activeLayerData = ref.watch(activeLayerProvider);
    LayerNotifier notifier = ref.read(activeLayerProvider.notifier);

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

                  /// All text overlay components
                  ///
                  if (textEditorClass == null && textList.isNotEmpty)
                    ...textList.map((element) {
                      ///
                      double xPosition = element.xPosition != 0
                          ? element.xPosition
                          : ((width / 1.9) -
                                  ((element.controller.text.length *
                                          element.size) /
                                      3)) -
                              60;
                      double yPosition = element.yPosition != 0
                          ? element.yPosition
                          : (height / 2) - element.size - 54;

                      ///
                      if (controller.value.position.inMilliseconds >=
                              element.startDuration!.inMilliseconds &&
                          controller.value.position.inMilliseconds <=
                              element.endDuration!.inMilliseconds) {
                        bool onFocus =
                            activeLayerData?.$1 == Layers.textOverlay &&
                                activeLayerData?.$2 == element.key;

                        return Positioned(
                          top: yPosition,
                          left: xPosition,
                          child: GestureDetector(
                            onTap: () {
                              if (!onFocus) {
                                notifier.toggleActiveLayer(
                                    layer: Layers.textOverlay,
                                    key: element.key);
                              }
                            },

                            /// Repositioning on active state
                            ///
                            onScaleStart: (details) {
                              // Capture the initial scale factor when the gesture starts
                              setState(() {
                                if (onFocus) {
                                  fontSize = element.size;
                                  positionX = xPosition + 60;
                                  positionY = yPosition + 54;
                                  // Reset the base scale factor at the start of the gesture
                                  _baseScaleFactor = 1.0;
                                }
                              });
                            },
                            onScaleUpdate: (details) {
                              if (onFocus) {
                                setState(() {
                                  // Calculate the scale change
                                  double scaleChange =
                                      (details.scale - _baseScaleFactor) * 0.5;
                                  double newFontSize = (fontSize + scaleChange)
                                      .clamp(10.0, 100.0);

                                  // Calculate the difference in size
                                  double sizeDifference =
                                      newFontSize - fontSize;

                                  // Adjust position to maintain the center
                                  positionX -= (sizeDifference / 2) *
                                      (element.controller.text.length / 2);
                                  positionY -= sizeDifference / 2;

                                  // Update fontSize
                                  fontSize = newFontSize;

                                  // Update position based on dragging
                                  positionX += details.focalPointDelta.dx;
                                  positionY += details.focalPointDelta.dy;
                                });

                                

                                /// Update notifier with new position and size
                                ///
                                textEditorNotifier.updateText(element.copyWith(
                                  xPosition: positionX - 60,
                                  yPosition: positionY - 54,
                                  size: fontSize,
                                ));
                              }
                            },

                            child: Container(
                              padding: const EdgeInsets.all(50),
                              color: onFocus ? Colors.transparent : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: onFocus
                                            ? gradientColor1
                                            : Colors.transparent),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  element.controller.text,
                                  style: TextStyle(
                                    color: element.color!.withOpacity(element.opacity ?? 1),
                                    fontSize: element.size,
                                    fontFamily: element.fontFamily,
                                    fontWeight: element.fontWeight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),

                  /// Text Editor view
                  ///
                  if (textEditorClass != null)
                    const Center(
                      child: TextEditingField(),
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
