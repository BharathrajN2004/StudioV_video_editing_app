import 'package:flutter/material.dart';

import '../utilities/theme.dart';

class HorizontalRuler extends StatefulWidget {
  const HorizontalRuler({
    super.key,
    required this.maxValue,
    this.additionalText,
    this.isDouble = false,
    this.startAnimationIndex = 20,
    this.enableStartAnimation = true,
    this.opacityRanges = const [5, 1, 10, .8, 15, .5, 30, .3],
  });
  final int maxValue;
  final String? additionalText;
  final bool isDouble;
  final double startAnimationIndex;
  final bool enableStartAnimation;
  final List<num> opacityRanges;

  @override
  State<HorizontalRuler> createState() => HorizontalRulerState();
}

class HorizontalRulerState extends State<HorizontalRuler> {
  final ScrollController _scrollController = ScrollController();
  double selectedValue = 0;

  // Center the initial scroll position on load
  @override
  void initState() {
    super.initState();
    if (widget.enableStartAnimation == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          widget.startAnimationIndex * 9.5,
          duration: const Duration(seconds: 1),
          curve: Curves.ease,
        ); // Centering the initial position
      });
    }
  }

  void _onScroll() {
    // Calculate the selected value based on scroll position
    setState(() {
      if (_scrollController.offset < 0) {
        selectedValue = 0;
      } else if (_scrollController.offset >
          _scrollController.position.maxScrollExtent) {
        selectedValue = widget.maxValue.toDouble();
      } else {
        selectedValue = (_scrollController.offset / 9.5).round().toDouble();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;
      double maxHeight = constraints.maxHeight;

      return Stack(
        alignment: Alignment.center,
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollUpdateNotification) {
                _onScroll();
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: maxHeight * .65,
                left: maxWidth * .49,
                right: maxWidth * .48,
              ),
              itemCount: widget.maxValue, // Represents total markings
              itemBuilder: (context, index) {
                bool isCmMark = index % 10 == 0;
                bool isHalfCmMark = index % 5 == 0;

                return Opacity(
                  opacity: index > selectedValue - widget.opacityRanges[0] &&
                          index < selectedValue + widget.opacityRanges[0]
                      ? widget.opacityRanges[1].toDouble()
                      : index > selectedValue - widget.opacityRanges[2] &&
                              index < selectedValue + widget.opacityRanges[2]
                          ? widget.opacityRanges[3].toDouble()
                          : index > selectedValue - widget.opacityRanges[4] &&
                                  index <
                                      selectedValue + widget.opacityRanges[4]
                              ? widget.opacityRanges[5].toDouble()
                              : index >
                                          selectedValue -
                                              widget.opacityRanges[6] &&
                                      index <
                                          selectedValue +
                                              widget.opacityRanges[6]
                                  ? widget.opacityRanges[7].toDouble()
                                  : 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 1.5,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isHalfCmMark ? lightShade1 : lightShade2,
                        ),
                      ),
                      if (isCmMark)
                        Positioned(
                          top: -25,
                          left: -10,
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              (widget.isDouble
                                      ? (widget.isDouble ? (index / 10) : index)
                                          .toStringAsFixed(1)
                                      : (widget.isDouble ? (index / 10) : index)
                                          .toString()) +
                                  (widget.additionalText ?? ""),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: midTextSize * aspectRatio,
                                color: lightShade2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// Center overlay displaying selected value
          ///
          Positioned(
            top: maxHeight * .225,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: textColor,
              ),
              child: Text(
                (widget.isDouble
                        ? (widget.isDouble
                                ? (selectedValue / 10)
                                : selectedValue)
                            .toStringAsFixed(1)
                        : (widget.isDouble
                                ? (selectedValue / 10)
                                : selectedValue)
                            .toInt()
                            .toString()) +
                    (widget.additionalText ?? ""),
                style: TextStyle(
                  fontSize: midTextSize * aspectRatio,
                  fontWeight: FontWeight.w900,
                  color: bgColor,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: maxWidth / 2,
            child: Container(
              width: 2.5,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: textColor,
              ),
            ),
          ),
        ],
      );
    });
  }
}
