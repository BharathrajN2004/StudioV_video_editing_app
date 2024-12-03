import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/constants.dart';

class SubOptionNotifier extends StateNotifier<SubOptions?> {
  SubOptionNotifier() : super(null);

  void toggleSubOption(SubOptions? option) {
    state = option;
  }
}

final subOptionProvider = StateNotifierProvider<SubOptionNotifier, SubOptions?>(
    (ref) => SubOptionNotifier());
