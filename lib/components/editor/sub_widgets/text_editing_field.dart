import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/text_editor_class.model.dart';
import '../../../providers/text_editor.provider.dart';
import '../../../providers/text_extension_container.provider.dart';
import '../../../utilities/theme.dart';

class TextEditingField extends ConsumerStatefulWidget {
  const TextEditingField({super.key});

  @override
  ConsumerState<TextEditingField> createState() => _TextEditingFieldState();
}

class _TextEditingFieldState extends ConsumerState<TextEditingField>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Register for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove observer to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      SystemChannels.textInput.invokeMethod('TextInput.show');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditorClass textEditorClass = ref.watch(textExtensionProvider)!;

    // Ensure the focus is set and the keyboard is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!textEditorClass.focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(textEditorClass.focusNode);
      }

      // Explicitly show the keyboard
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });

    return TextField(
      autofocus: true,
      controller: textEditorClass.controller,
      focusNode: textEditorClass.focusNode,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      textAlign: TextAlign.center,
      maxLines: null,
      style: TextStyle(
        fontSize: textEditorClass.size,
        color: textEditorClass.color,
        fontWeight: FontWeight.w700,
      ),
      cursorRadius: const Radius.circular(50),
      cursorColor: textColor,
      onChanged: (value) =>
          ref.read(textEditorProvider.notifier).updateText(textEditorClass),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: "TYPE HERE",
        hintStyle: TextStyle(
          color: textColor.withOpacity(.6),
          fontSize: 23,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
