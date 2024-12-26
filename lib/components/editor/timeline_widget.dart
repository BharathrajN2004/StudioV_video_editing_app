import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/controller.provider.dart';
import '../../utilities/theme.dart';

class TimeLineWidget extends ConsumerWidget {
  const TimeLineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    final videoState = ref.watch(videoManagerProvider);
    final videoManager = ref.watch(videoManagerProvider.notifier);

    int totalDuration = videoState.totalDuration.inSeconds + 1;

    return Container(
      height: height * .02,
      margin: EdgeInsets.only(top: 5, bottom: height * 0.05),
      child: ListView.builder(
          controller: videoManager.timelineScrollController,
          padding: EdgeInsets.symmetric(
            horizontal: (width * .48),
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalDuration ,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              alignment: Alignment.center,
              width: 45,
              color: Colors.transparent,
              child: index % 3 == 0
                  ? Text(
                      '${index}s',
                      style: TextStyle(
                          color: textColor,
                          fontSize: aspectRatio * smallTextSize,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(
                      width: 2,
                      height: 2,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: textColor),
                    ),
            );
          }),
    );
  }
}
