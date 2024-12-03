import 'package:flutter/material.dart';

import '../../../utilities/constants.dart';
import '../../../utilities/theme.dart';

class FontsListWidget extends StatefulWidget {
  const FontsListWidget({super.key});

  @override
  State<FontsListWidget> createState() => _FontsListWidgetState();
}

class _FontsListWidgetState extends State<FontsListWidget> {
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        itemCount: fontList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(
              vertical: height * 0.015,
              horizontal: width * 0.01,
            ),
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: secondaryColor,
            ),
            alignment: Alignment.center,
            child: Text(
              fontList[index],
              style: TextStyle(
                fontFamily: fontList[index],
                color: textColor,
                fontSize: (largeTextSize + 10) * aspectRatio,
              ),
            ),
          );
        },
      ),
    );
  }
}
