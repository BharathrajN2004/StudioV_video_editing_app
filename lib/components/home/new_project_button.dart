import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../functions/pick_video.function.dart';
import '../../utilities/theme.dart';
import '../text.dart';

class NewProjectButton extends ConsumerWidget {
  const NewProjectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return GestureDetector(
      onTap: () async {
        try {
          await pickVideo(context: context, ref: ref);
        } catch (error) {
          print(error);
        }
      },
      child: Container(
        width: width * .5,
        margin: EdgeInsets.symmetric(vertical: height * 0.015),
        padding: EdgeInsets.symmetric(vertical: height * 0.015),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: linearGradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: "New Project",
              color: Colors.white,
              weight: FontWeight.w900,
              size: veryLargeTextSize * aspectRatio,
            ),
            SizedBox(width: width * 0.02),
            Icon(
              Symbols.add_rounded,
              size: aspectRatio * 60,
              color: Colors.white,
              weight: 700,
              grade: 200,
              opticalSize: 48,
            ),
          ],
        ),
      ),
    );
  }
}
