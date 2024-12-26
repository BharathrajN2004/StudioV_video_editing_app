import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/text_editor_class.model.dart';

class TextEditorNotifier extends StateNotifier<List<TextEditorClass>> {
  TextEditorNotifier() : super([]);

  /// Add a new text overlay.
  void addText(TextEditorClass textEditor) {
    state = [...state, textEditor];
  }

  /// Remove a specific text overlay by matching its unique key.
  void removeText(Key key) {
    state = state.where((editor) => editor.key != key).toList();
  }

  /// Update an existing text overlay.
  void updateText(TextEditorClass updatedText) {
    state = state.map((editor) {
      if (editor.key == updatedText.key) {
        return updatedText;
      }
      return editor;
    }).toList();
  }
}

final textEditorProvider =
    StateNotifierProvider<TextEditorNotifier, List<TextEditorClass>>(
        (ref) => TextEditorNotifier());
