import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../providers/active_layer.provider.dart';
import '../../providers/suboption.provider.dart';
import '../../utilities/constants.dart';
import '../../utilities/theme.dart';

class LayerEditOptions extends ConsumerStatefulWidget {
  const LayerEditOptions({super.key});

  @override
  ConsumerState<LayerEditOptions> createState() => _LayerEditOptionsState();
}

class _LayerEditOptionsState extends ConsumerState<LayerEditOptions> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    Layers? activeLayer = ref.watch(activeLayerProvider)?.$1;

    SubOptions? selectedOption = ref.watch(subOptionProvider);
    SubOptionNotifier optionNotifier = ref.read(subOptionProvider.notifier);

    List<SubOptions> options = [];
    if (activeLayer == Layers.music) {
      options = [
        SubOptions.volume,
        SubOptions.speed,
        SubOptions.reverse,
        SubOptions.split,
        SubOptions.replace,
        SubOptions.duplicate,
        SubOptions.delete,
      ];
    } else if (activeLayer == Layers.frame) {
      options = [
        SubOptions.volume,
        SubOptions.speed,
        SubOptions.crop,
        SubOptions.transform,
        SubOptions.background,
        SubOptions.reverse,
        SubOptions.split,
        SubOptions.replace,
        SubOptions.duplicate,
        SubOptions.reorder,
        SubOptions.delete,
      ];
    } else if (activeLayer == Layers.textOverlay) {
      options = [
        SubOptions.edit,
        SubOptions.color,
        SubOptions.fonts,
        SubOptions.background,
        SubOptions.align,
        SubOptions.opacity,
        SubOptions.down,
        SubOptions.up,
        SubOptions.split,
        SubOptions.duplicate,
        SubOptions.delete,
      ];
    } else if (activeLayer == Layers.imageOverlay) {
      options = [
        SubOptions.duration,
        SubOptions.transform,
        SubOptions.opacity,
        SubOptions.split,
        SubOptions.replace,
        SubOptions.down,
        SubOptions.up,
        SubOptions.duplicate,
        SubOptions.delete,
      ];
    } else if (activeLayer == Layers.videoOverlay) {
      options = [
        SubOptions.volume,
        SubOptions.speed,
        SubOptions.transform,
        SubOptions.opacity,
        SubOptions.reverse,
        SubOptions.split,
        SubOptions.replace,
        SubOptions.down,
        SubOptions.up,
        SubOptions.duplicate,
        SubOptions.delete,
      ];
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: height * .07,
          color: secondaryBgColor,
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: options.length,
              padding: EdgeInsets.only(
                left: width * 0.115,
                right: width * 0.05,
              ),
              itemBuilder: (context, index) {
                bool isSelected = options[index] == selectedOption;
                return GestureDetector(
                  onTap: () {
                    selectedOption != options[index]
                        ? optionNotifier.toggleSubOption(options[index])
                        : optionNotifier.toggleSubOption(null);
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: width * .175,
                          child: Image.asset(
                            "assets/icons/${!isSelected ? options[index].name : "${options[index].name}_H"}.png",
                            height: aspectRatio * 50,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: width * 0.01,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              options[index].name.toString()[0].toUpperCase() +
                                  options[index].name.toString().substring(1),
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: isSelected
                                      ? gradientColor1
                                      : textColor.withOpacity(.6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: aspectRatio * (tinyTextSize - 1)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        // Gradient overlay for dimming edges
        IgnorePointer(
          child: Container(
            width: width,
            height: height * .07,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  bgColor,
                  bgColor.withOpacity(.7),
                  Colors.transparent,
                  Colors.transparent,
                  bgColor.withOpacity(.7),
                  bgColor
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.0, .05, 0.1, 0.8, .95, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          left: 10,
          child: GestureDetector(
            onTap: () {
              ref.read(activeLayerProvider.notifier).toggleActiveLayer();
              ref.read(subOptionProvider.notifier).toggleSubOption(null);
            },
            child: Container(
              height: height * .055,
              width: width * .08,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: secondaryColor,
              ),
              child: Icon(
                Symbols.keyboard_arrow_down_rounded,
                color: iconColor,
                size: aspectRatio * 60,
                fill: 1,
                grade: 200,
                weight: 700,
              ),
            ),
          ),
        )
      ],
    );
  }
}
