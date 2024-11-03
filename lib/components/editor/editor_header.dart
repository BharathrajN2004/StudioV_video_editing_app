import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../utilities/theme.dart';

class EditorHeader extends StatelessWidget {
  const EditorHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Symbols.close_rounded,
            color: iconColor,
            weight: 700,
            grade: 200,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Symbols.settings_rounded,
            color: iconColor,
            size: aspectRatio * midIconSize,
            fill: 1,
            weight: 500,
            grade: 0,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Symbols.file_upload_rounded,
            color: iconColor,
            weight: 700,
            grade: 200,
          ),
        ),
      ],
    );
  }
}
