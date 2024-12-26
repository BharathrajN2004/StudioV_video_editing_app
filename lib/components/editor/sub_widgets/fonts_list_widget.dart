import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_editing_app/models/text_editor_class.model.dart';
import 'package:video_editing_app/providers/text_editor.provider.dart';

import '../../../providers/active_layer.provider.dart';
import '../../../utilities/constants.dart';
import '../../../utilities/theme.dart';

class FontsListWidget extends ConsumerStatefulWidget {
  const FontsListWidget({super.key});

  @override
  ConsumerState<FontsListWidget> createState() => _FontsListWidgetState();
}

class _FontsListWidgetState extends ConsumerState<FontsListWidget> {
  bool isMuted = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    (Layers, Key?)? activeLayerData = ref.watch(activeLayerProvider);

    List<TextEditorClass> textList = ref.watch(textEditorProvider);
    TextEditorNotifier notifier = ref.read(textEditorProvider.notifier);

    TextEditorClass activeTextData =
        textList.firstWhere((element) => element.key == activeLayerData?.$2);

    String activeTextFamily = activeTextData.fontFamily;

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
          bool isSelected = fontList[index] == activeTextFamily;

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                notifier.updateText(
                    activeTextData.copyWith(fontFamily: fontList[index]));
              }
            },
            child: AnimatedContainer(
              duration: Durations.medium1,
              margin: EdgeInsets.symmetric(
                vertical: height * 0.015,
                horizontal: width * 0.01,
              ),
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: secondaryColor,
                gradient: isSelected ? linearGradient : null,
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
            ),
          );
        },
      ),
    );
  }
}
