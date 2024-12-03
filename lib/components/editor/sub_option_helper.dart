import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/controller.provider.dart';
import '../../providers/suboption.provider.dart';
import '../../utilities/constants.dart';
import '../../utilities/theme.dart';
import '../horizontal_ruler.dart';
import 'sub_widgets/align_list_widget.dart';
import 'sub_widgets/color_list_widget.dart';
import 'sub_widgets/fonts_list_widget.dart';
import 'sub_widgets/transform_list_widget.dart';
import 'sub_widgets/volume_controll_widget.dart';

class SubOptionHelper extends ConsumerWidget {
  const SubOptionHelper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    SubOptions? option = ref.watch(subOptionProvider);
    VideoState videoState = ref.watch(videoManagerProvider);

    if (option == SubOptions.volume) {
      return const VolumeControllerWidget();
    } else if (option == SubOptions.speed) {
      return Container(
        height: height * .08,
        width: width,
        color: secondaryBgColor,
        margin: const EdgeInsets.only(bottom: 2),
        child: const HorizontalRuler(
          maxValue: 101,
          additionalText: "x",
          isDouble: true,
          startAnimationIndex: 10,
          opacityRanges: [10, 1, 15, .8, 20, .4, 30, .2],
        ),
      );
    } else if (option == SubOptions.color || option == SubOptions.background) {
      return const ColorListWidget();
    } else if (option == SubOptions.fonts) {
      return const FontsListWidget();
    } else if (option == SubOptions.align) {
      return const AlignListWidget();
    } else if (option == SubOptions.opacity) {
      return Container(
        height: height * .08,
        width: width,
        color: secondaryBgColor,
        margin: const EdgeInsets.only(bottom: 2),
        child: const HorizontalRuler(
          maxValue: 101,
          startAnimationIndex: 90,
          opacityRanges: [10, 1, 15, .8, 20, .4, 30, .2],
        ),
      );
    } else if (option == SubOptions.duration) {
      return Container(
        height: height * .08,
        width: width,
        color: secondaryBgColor,
        margin: const EdgeInsets.only(bottom: 2),
        child: HorizontalRuler(
          maxValue: videoState.totalDuration.inSeconds + 1,
          additionalText: "s",
          isDouble: true,
          startAnimationIndex: 10,
          opacityRanges: const [10, 1, 15, .8, 20, .4, 30, .2],
        ),
      );
    } else if (option == SubOptions.transform) {
      return const TransformListWidget();
    } else {
      return const SizedBox();
    }
  }
}
