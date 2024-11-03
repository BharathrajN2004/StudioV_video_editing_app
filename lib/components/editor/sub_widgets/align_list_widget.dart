import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../utilities/theme.dart';

class AlignListWidget extends StatefulWidget {
  const AlignListWidget({super.key});

  @override
  State<AlignListWidget> createState() => _AlignListWidgetState();
}

class _AlignListWidgetState extends State<AlignListWidget> {
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
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.015),
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Symbols.format_align_left_rounded,
                  weight: 700,
                  grade: 200,
                  size: aspectRatio * 55,
                  color: lightShade1,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.015),
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Symbols.format_align_center_rounded,
                  weight: 700,
                  grade: 200,
                  size: aspectRatio * 55,
                  color: lightShade1,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.015),
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Symbols.format_align_right_rounded,
                  weight: 700,
                  grade: 200,
                  size: aspectRatio * 55,
                  color: lightShade1,
                ),
              ),
            ),
          ],
        ));
  }
}
