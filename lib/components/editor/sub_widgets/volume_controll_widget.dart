import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../utilities/theme.dart';
import '../../horizontal_ruler.dart';

class VolumeControllerWidget extends StatefulWidget {
  const VolumeControllerWidget({super.key});

  @override
  State<VolumeControllerWidget> createState() => _VolumeControllerWidgetState();
}

class _VolumeControllerWidgetState extends State<VolumeControllerWidget> {
  bool isMuted = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Container(
      height: height * .08,
      width: width,
      color: secondaryBgColor,
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          isMuted
              ? const Expanded(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: .3,
                      child: HorizontalRuler(maxValue: 101),
                    ),
                  ),
                )
              : const Expanded(
                  child: HorizontalRuler(maxValue: 101),
                ),

          SizedBox(
            width: width * 0.04,
          ),

          /// Mute button
          GestureDetector(
            onTap: () {
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
