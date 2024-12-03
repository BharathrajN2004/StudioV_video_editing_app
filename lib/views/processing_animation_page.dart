import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:video_editing_app/utilities/theme.dart';

import '../providers/project_starter.provider.dart';
import 'video_editing_page.dart';

class ProcessingAnimationPage extends ConsumerWidget {
  const ProcessingAnimationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ProjectState projectState = ref.watch(projectProvider);

    if (projectState.completed) {
      // Schedule the navigation after the build phase completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VideoEditingPage()),
        );
      });
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Center(
            child: LottieBuilder.asset("assets/jsons/loading.json"),
          ),
        ),
      ),
    );
  }
}
