import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_editing_app/utilities/theme.dart';

class CustomText extends ConsumerWidget {
  final String text;
  final FontWeight? weight;
  final double? size;
  final Color? color;
  final double height;
  final TextAlign align;
  final int maxLine;
  final bool loadingState;
  final double length;
  final List<Shadow>? shadowList;

  const CustomText({
    super.key,
    required this.text,
    this.weight,
    this.size,
    this.color,
    this.height = 0,
    this.align = TextAlign.start,
    this.maxLine = 1,
    this.loadingState = false,
    this.length = 0.1,
    this.shadowList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    double fontSize = textSize * aspectRatio;
    return !loadingState
        ? Text(
            text,
            textAlign: align,
            maxLines: maxLine,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: size ?? fontSize,
                fontWeight: weight ?? FontWeight.w600,
                color: color ?? textColor,
                height: height,
                shadows: shadowList),
          )
        : Shimmer.fromColors(
            baseColor: bgColor,
            highlightColor: secondaryColor,
            child: Container(
              height: size,
              width: length * width,
              decoration: BoxDecoration(
                color: textColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
  }
}
