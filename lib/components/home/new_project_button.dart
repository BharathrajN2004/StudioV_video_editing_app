import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_editing_app/utilities/theme.dart';

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
        // try {
        //   String? videoName = await pickVideo(ref: ref, context: context);
        //   if (videoName != null) {
        //     getDominantColor(ref: ref, videoName: videoName);

        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) =>
        //             VideoPreprocessingPage(videoName: videoName),
        //       ),
        //     );
        //   }
        // } catch (error) {
        //   ConsoleLogger.error(error);
        // }
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
              weight: FontWeight.w800,
              size: largeTextSize * aspectRatio,
            ),
            SizedBox(width: width * 0.02),
            Icon(
              Icons.add_rounded,
              size: aspectRatio * 60,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
