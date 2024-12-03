import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/constants.dart';
import '../../utilities/theme.dart';

class OptionsList extends ConsumerStatefulWidget {
  const OptionsList({super.key});

  @override
  ConsumerState<OptionsList> createState() => _OptionsListState();
}

class _OptionsListState extends ConsumerState<OptionsList> {
  Options? hoveredOption;

  setHovered(Options? option) {
    setState(() {
      hoveredOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: height * .105,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Options.values.length,
              padding: EdgeInsets.only(
                left: width * 0.05,
                right: width * 0.05,
              ),
              itemBuilder: (context, index) {
                bool isHovered = Options.values[index] == hoveredOption;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      hoveredOption = Options.values[index];
                    });
                  },
                  child: Stack(
                    children: [
                      MouseRegion(
                        onHover: (event) => setHovered(Options.values[index]),
                        onExit: (event) => setHovered(null),
                        child: Container(
                          width: width * .15,
                          height: width * .15,
                          margin: EdgeInsets.only(right: width * 0.02),
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/icons/${!isHovered ? Options.values[index].name : "${Options.values[index].name}_H"}.png",
                            height: width * .065,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: width * 0.02,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            Options.values[index].name
                                    .toString()[0]
                                    .toUpperCase() +
                                Options.values[index].name
                                    .toString()
                                    .substring(1),
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: aspectRatio * tinyTextSize),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
        // Gradient overlay for dimming edges
        IgnorePointer(
          child: Container(
            width: width,
            height: height * .105,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  bgColor.withOpacity(.7),
                  Colors.transparent,
                  Colors.transparent,
                  bgColor.withOpacity(0.7),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.0, 0.1, 0.9, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
