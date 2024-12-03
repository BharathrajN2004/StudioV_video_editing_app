import 'package:flutter/material.dart';

import '../../../utilities/theme.dart';

class TransformListWidget extends StatefulWidget {
  const TransformListWidget({super.key});

  @override
  State<TransformListWidget> createState() => _TransformListWidgetState();
}

class _TransformListWidgetState extends State<TransformListWidget> {
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
                child: Image.asset(
                  "assets/icons/horizontal.png",
                  height: aspectRatio * 55,
                  fit: BoxFit.fitHeight,
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
                child: Image.asset(
                  "assets/icons/vertical.png",
                  height: aspectRatio * 55,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.015),
                padding: EdgeInsets.symmetric(vertical: height * 0.0125),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.asset(
                  "assets/icons/left.png",
                  height: aspectRatio * 45,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.015),
                padding: EdgeInsets.symmetric(vertical: height * 0.0125),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Image.asset(
                  "assets/icons/right.png",
                  height: aspectRatio * 45,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ));
  }
}
