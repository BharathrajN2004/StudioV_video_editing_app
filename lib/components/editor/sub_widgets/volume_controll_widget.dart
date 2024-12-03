import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../providers/controller.provider.dart';
import '../../../utilities/theme.dart';
import '../../horizontal_ruler.dart';

class VolumeControllerWidget extends ConsumerStatefulWidget {
  const VolumeControllerWidget({super.key});

  @override
  ConsumerState<VolumeControllerWidget> createState() =>
      _VolumeControllerWidgetState();
}

class _VolumeControllerWidgetState
    extends ConsumerState<VolumeControllerWidget> {
  bool isMuted = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    VideoState videoState = ref.watch(videoManagerProvider);

    return Container(
      height: height * .08,
      width: width,
      color: secondaryBgColor,
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          isMuted
              ? Expanded(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: .3,
                      child: HorizontalRuler(
                          maxValue: 101,
                          setter: (value) {
                            videoState
                                .videoControllers[videoState.currentVideoIndex]
                                .setVolume(value / 100);
                          }),
                    ),
                  ),
                )
              : Expanded(
                  child: HorizontalRuler(
                      maxValue: 101,
                      setter: (value) {
                        videoState
                            .videoControllers[videoState.currentVideoIndex]
                            .setVolume(value / 100);
                      }),
                ),

          SizedBox(
            width: width * 0.04,
          ),

          /// Mute button
          GestureDetector(
            onTap: () {
              if (videoState.videoControllers[videoState.currentVideoIndex]
                      .value.volume >
                  0) {
                videoState.videoControllers[videoState.currentVideoIndex]
                    .setVolume(0);
              }
              setState(() {
                isMuted = !isMuted;
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: secondaryColor,
                      gradient: isMuted ? linearGradient : null,
                    ),
                    child: Icon(
                      Symbols.volume_off_rounded,
                      grade: 200,
                      weight: 700,
                      color: lightShade1,
                      size: aspectRatio * 45,
                    ),
                  ),
                  Text(
                    "Mute",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor.withOpacity(.6),
                        fontWeight: FontWeight.bold,
                        fontSize: aspectRatio * (tinyTextSize - 1)),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: width * 0.04,
          )
        ],
      ),
    );
  }
}
