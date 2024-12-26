import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/text_editor_class.model.dart';
import '../utilities/theme.dart';
import 'controller.provider.dart';
import 'text_editor.provider.dart';

class TextExtensionNotifier extends StateNotifier<TextEditorClass?> {
  final Ref ref;
  bool newCheck = true;

  TextExtensionNotifier(this.ref) : super(null);

  /// Opens the text editor extension.
  void openExtension(TextEditorClass? oldObject) {
    if (oldObject == null) {
      final videoState = ref.watch(videoManagerProvider);

      Duration currentPosition = videoState
          .videoControllers[videoState.currentVideoIndex].value.position;

      // Create a new TextEditorClass instance.
      state = TextEditorClass(
        size: 23,
        startDuration: currentPosition,
        endDuration: currentPosition + const Duration(seconds: 2),
        xPosition: 0,
        yPosition: 0,
        overlayIndex: 0,
        color: textColor,
      );
      newCheck = true; // Indicate a new object is being created.
    } else {
      state = oldObject; // Edit the existing object.
      newCheck = false; // Indicate we are modifying an existing object.
    }
  }

  void updateTextSize(double size) {
    if (state != null) {
      state = state!.copyWith(size: size);
    }
  }

  void updatePosition({required double x, required double y}) {
    if (state != null) {
      state = state!.copyWith(xPosition: x, yPosition: y);
    }
  }

  /// Closes the text editor extension and optionally saves changes.
  void closeExtension(bool save) {
    if (save && state != null) {
      if (newCheck) {
        // Add the new object to the text editor provider.
        ref.read(textEditorProvider.notifier).addText(state!);
      } else {
        // Update the existing object in the text editor provider.
        ref.read(textEditorProvider.notifier).updateText(state!);
      }
      state = null;
    }
    state = null; // Close the extension.
  }
}

final textExtensionProvider =
    StateNotifierProvider<TextExtensionNotifier, TextEditorClass?>(
        (ref) => TextExtensionNotifier(ref));
