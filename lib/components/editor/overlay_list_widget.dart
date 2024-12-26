import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_editing_app/components/text.dart';
import 'package:video_editing_app/models/text_editor_class.model.dart';
import 'package:video_editing_app/providers/text_editor.provider.dart';

import '../../providers/controller.provider.dart';
import '../../providers/active_layer.provider.dart';
import '../../utilities/constants.dart';
import '../../utilities/theme.dart';

class OverlayWidget extends ConsumerWidget {
  const OverlayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    final videoState = ref.watch(videoManagerProvider);
    final videoManager = ref.watch(videoManagerProvider.notifier);

    (Layers, Key?)? activeLayer = ref.watch(activeLayerProvider);
    LayerNotifier notifier = ref.read(activeLayerProvider.notifier);

    int totalDuration = videoState.totalDuration.inSeconds + 1;

    List<TextEditorClass> textList = ref.watch(textEditorProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: videoManager.overlayScrollController,
      padding: EdgeInsets.symmetric(horizontal: width * .48),
      child: Stack(
        children: [
          Opacity(
            opacity: activeLayer == null ? 1 : .5,
            child: Container(
              height: 45,
              width: (45 * totalDuration).toDouble(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: secondaryColor,
              ),
            ),
          ),
          ...textList.map((data) {
            double opacity = (activeLayer?.$1 == Layers.textOverlay &&
                        activeLayer?.$2 == data.key) ||
                    activeLayer == null
                ? 1
                : .5;
            return Positioned(
              left: (data.startDuration!.inMicroseconds * .0000455),
              child: GestureDetector(
                onTap: () {
                  notifier.toggleActiveLayer(
                    layer: Layers.textOverlay,
                    key: data.key,
                  );
                },
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: Durations.medium1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      width: ((data.endDuration!.inMicroseconds -
                              data.startDuration!.inMicroseconds) *
                          .0000455),
                      height: 45,
                      padding:
                          EdgeInsets.symmetric(horizontal: aspectRatio * 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            gradientColor1.withOpacity(.8),
                            gradientColor2.withOpacity(.8)
                          ],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        text: data.controller.text,
                        size: largeTextSize * aspectRatio,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}



// 
// if (Layers.imageOverlay != activeLayer) {
//                     notifier.toggleActiveLayer(Layers.imageOverlay);
//                   }