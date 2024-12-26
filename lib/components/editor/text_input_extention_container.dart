import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
// import 'package:video_editing_app/models/text_editor_class.model.dart';
import 'package:video_editing_app/providers/text_extension_container.provider.dart';

import '../../models/text_editor_class.model.dart';
import '../../utilities/theme.dart';
import '../horizontal_ruler.dart';

class TextInputExtentionContainer extends ConsumerStatefulWidget {
  const TextInputExtentionContainer({super.key});

  @override
  ConsumerState<TextInputExtentionContainer> createState() =>
      _TextInputExtentionContainerState();
}

class _TextInputExtentionContainerState
    extends ConsumerState<TextInputExtentionContainer> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    TextEditorClass textEditorClass = ref.watch(textExtensionProvider)!;

    return Container(
      color: secondaryBgColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    ref
                        .read(textExtensionProvider.notifier)
                        .closeExtension(false);
                  },
                  child: Container(
                    height: aspectRatio * 110,
                    decoration: BoxDecoration(
                      color: secondaryBgColor,
                      border: Border.all(
                        color: bgColor,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Symbols.close_rounded,
                      fill: 1,
                      weight: 700,
                      grade: 200,
                      color: textColor.withOpacity(.8),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (textEditorClass.controller.text.isNotEmpty) {
                      ref
                          .read(textExtensionProvider.notifier)
                          .closeExtension(true);
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    }
                  },
                  child: Container(
                    height: aspectRatio * 110,
                    decoration: BoxDecoration(
                      color: secondaryBgColor,
                      border: Border.all(
                        color: bgColor,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Symbols.check_rounded,
                      fill: 1,
                      weight: 700,
                      grade: 200,
                      color: textEditorClass.controller.text.isNotEmpty
                          ? inactiveTextColor
                          : textColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: height * 0.08,
            decoration: const BoxDecoration(
              color: secondaryBgColor,
              border: Border(
                top: BorderSide(
                  color: bgColor,
                  width: 1.5,
                ),
              ),
            ),
            child: HorizontalRuler(
              maxValue: 101,
              startIndex: 20,
              backgroundColor: secondaryBgColor,
              setter: (value) {
                // print(value);
                ref.read(textExtensionProvider.notifier).updateTextSize(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
