import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/constants.dart';

class LayerNotifier extends StateNotifier<Layers?> {
  LayerNotifier() : super(null);

  void toggleActiveLayer(Layers? layer) {
    state = layer;
  }
}

final activeLayerProvider =
    StateNotifierProvider<LayerNotifier, Layers?>((ref) => LayerNotifier());
