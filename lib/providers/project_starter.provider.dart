import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectState {
  final File? videoFile;
  final String? videoName;
  final List<String> imagePaths;
  final Color? chromakey;
  final bool isRemoveGS;
  final bool completed;

  ProjectState({
    this.videoFile,
    this.videoName,
    required this.imagePaths,
    this.chromakey,
    this.isRemoveGS = false,
    this.completed = false,
  });

  ProjectState copyWith({
    File? videoFile,
    String? videoName,
    List<String>? imagePaths,
    Color? chromakey,
    bool? isRemoveGS,
    bool? completed,
  }) {
    return ProjectState(
      videoFile: videoFile ?? this.videoFile,
      videoName: videoName ?? this.videoName,
      imagePaths: imagePaths ?? this.imagePaths,
      chromakey: chromakey ?? this.chromakey,
      isRemoveGS: isRemoveGS ?? this.isRemoveGS,
      completed: completed ?? this.completed,
    );
  }
}

class ProjectStateNotifier extends StateNotifier<ProjectState> {
  ProjectStateNotifier() : super(ProjectState(imagePaths: []));

  void setVideoFile({required File video, required String name}) {
    state = state.copyWith(videoFile: video, videoName: name);
  }

  // Set the chromakey color
  void setChromakey(Color chromakey) {
    state = state.copyWith(chromakey: chromakey);
  }

  // Update image paths
  void addImagePath(String imagePath) {
    List<String> imagePaths = state.imagePaths;
    imagePaths.add(imagePath);
    state = state.copyWith(imagePaths: imagePaths);
  }

  // Toggle green screen removal
  void toggleRemoveGreenScreen(bool value) {
    state = state.copyWith(isRemoveGS: value);
  }

  // Mark as completed
  void markAsCompleted() {
    state = state.copyWith(completed: true);
  }
}

// Create the StateNotifierProvider
final projectProvider =
    StateNotifierProvider.autoDispose<ProjectStateNotifier, ProjectState>(
        (ref) {
  return ProjectStateNotifier();
});
