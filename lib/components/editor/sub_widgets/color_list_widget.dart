import 'package:flutter/material.dart';

import '../../../utilities/constants.dart';
import '../../../utilities/theme.dart';

class ColorListWidget extends StatefulWidget {
  const ColorListWidget({super.key});

  @override
  State<ColorListWidget> createState() => _ColorListWidgetState();
}

class _ColorListWidgetState extends State<ColorListWidget> {
  bool isMuted = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Container(
      height: height * .08,
      width: width,
      color: secondaryBgColor,
      margin: const EdgeInsets.only(bottom: 2),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        itemCount: colorList.length,
        itemBuilder: (context, index) {
          return Container(
            width: width * .07,
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: width * 0.0125,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignCenter),
            ),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              borderOnForeground: true,
              color: colorList[index],
              type: MaterialType.card,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  print(index);
                },
                splashColor: bgColor.withOpacity(.2),
                child: index == 0
                    ? Transform.rotate(
                        angle: 2,
                        child: Divider(
                          thickness: 3,
                          color: lightShade2,
                          height: height * .08,
                        ),
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
