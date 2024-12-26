import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_editing_app/providers/suboption.provider.dart';

import '../utilities/constants.dart';

class LayerNotifier extends StateNotifier<(Layers, Key?)?> {
  final Ref ref;
  LayerNotifier(this.ref) : super(null);

  void toggleActiveLayer({Layers? layer, Key? key}) {
    if (layer == null) {
      ref.read(subOptionProvider.notifier).toggleSubOption(null);
    }
    state = (layer == null ? null : (layer, key));
  }
}

final activeLayerProvider =
    StateNotifierProvider<LayerNotifier, (Layers, Key?)?>(
        (ref) => LayerNotifier(ref));
