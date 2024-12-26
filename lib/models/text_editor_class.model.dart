import 'package:flutter/material.dart';

class TextEditorClass {
  final Key key;
  final TextEditingController controller;
  final FocusNode focusNode;
  final double size;
  final double xPosition;
  final double yPosition;
  final FontWeight fontWeight;
  final String fontFamily;
  final Color? color;
  final double? opacity;
  final Duration? startDuration;
  final Duration? endDuration;
  final double overlayIndex;

  TextEditorClass({
    Key? key, // Allow custom key if needed, otherwise generate one.
    TextEditingController? controller, // Allow custom controller if needed.
    FocusNode? focusNode, // Allow custom focus
    required this.size,
    required this.xPosition,
    required this.yPosition,
    this.fontWeight = FontWeight.w800,
    this.fontFamily = "Nunito",
    this.color,
    this.opacity,
    this.startDuration,
    this.endDuration,
    required this.overlayIndex,
  })  : key = key ?? UniqueKey(),
        controller = controller ?? TextEditingController(),
        focusNode = focusNode ?? FocusNode();

  /// Creates a copy of this class with the given fields replaced by new values.
  TextEditorClass copyWith({
    Key? key,
    TextEditingController? controller,
    double? size,
    double? xPosition,
    double? yPosition,
    FontWeight? fontWeight,
    String? fontFamily,
    Color? color,
    double? opacity,
    Duration? startDuration,
    Duration? endDuration,
    double? overlayIndex,
  }) {
    return TextEditorClass(
      key: key ?? this.key, // Retain the existing key by default.
      controller: controller ??
          this.controller, // Retain the existing controller by default.
      size: size ?? this.size,
      xPosition: xPosition ?? this.xPosition,
      yPosition: yPosition ?? this.yPosition,
      fontWeight: fontWeight ?? this.fontWeight,
      fontFamily: fontFamily ?? this.fontFamily,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      startDuration: startDuration ?? this.startDuration,
      endDuration: endDuration ?? this.endDuration,
      overlayIndex: overlayIndex ?? this.overlayIndex,
    );
  }
}
