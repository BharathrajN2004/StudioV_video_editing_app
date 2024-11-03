import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/controller.provider.dart';
import '../../providers/active_layer.provider.dart';
import '../../utilities/constants.dart';
import '../../utilities/theme.dart';

class MusicList extends ConsumerWidget {
  const MusicList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    final videoState = ref.watch(videoManagerProvider);
    final videoManager = ref.watch(videoManagerProvider.notifier);

    Layers? activeLayer = ref.watch(activeLayerProvider);
    LayerNotifier notifier = ref.read(activeLayerProvider.notifier);

    int totalDuration = videoState.totalDuration.inSeconds + 1;

    return Opacity(
      opacity: activeLayer == null || activeLayer == Layers.music ? 1 : .5,
      child: Container(
        height: 45,
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: videoManager.musicScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: totalDuration,
            padding: EdgeInsets.symmetric(horizontal: width * .48),
            itemBuilder: (context, index) {
              bool isSelected = Layers.music == activeLayer;
              return GestureDetector(
                onTap: () {
                  if (Layers.music != activeLayer) {
                    notifier.toggleActiveLayer(Layers.music);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        // First Index
                        index == 0
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12))
                            // Last Index
                            : index == totalDuration - 1
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12))
                                // Others
                                : BorderRadius.circular(0),
                    border: isSelected
                        ? Border(
                            left: index == 0
                                ? const BorderSide(
                                    color: gradientColor1,
                                    width: 2,
                                  )
                                : BorderSide.none,
                            top: const BorderSide(
                                color: gradientColor1, width: 2),
                            bottom: const BorderSide(
                                color: gradientColor1, width: 2),
                            right: index == totalDuration - 1
                                ? const BorderSide(
                                    color: gradientColor1,
                                    width: 2,
                                  )
                                : BorderSide.none,
                          )
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius:
                        // First Index
                        index == 0
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))
                            // Last Index
                            : index == totalDuration - 1
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))
                                // Others
                                : BorderRadius.circular(0),
                    child: Container(
                      width: 60,
                      color: secondaryColor,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
