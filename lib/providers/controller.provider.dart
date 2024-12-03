import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class VideoState {
  final int currentVideoIndex;
  final bool isVideoPlaying;
  final List<VideoPlayerController> videoControllers;
  final Duration totalDuration; // New field for total duration
  final Directory frameDirectory;

  VideoState({
    required this.currentVideoIndex,
    required this.isVideoPlaying,
    required this.videoControllers,
    required this.totalDuration,
    required this.frameDirectory,
  });

  VideoState copyWith({
    int? currentVideoIndex,
    bool? isVideoPlaying,
    List<VideoPlayerController>? videoControllers,
    Duration? totalDuration,
    Directory? frameDirectory,
  }) {
    return VideoState(
      currentVideoIndex: currentVideoIndex ?? this.currentVideoIndex,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
      videoControllers: videoControllers ?? this.videoControllers,
      totalDuration: totalDuration ?? this.totalDuration,
      frameDirectory: frameDirectory ?? this.frameDirectory,
    );
  }
}

// Provider Code

class VideoManager extends StateNotifier<VideoState> {
  VideoManager()
      : super(VideoState(
          currentVideoIndex: 0,
          isVideoPlaying: false,
          videoControllers: [],
          totalDuration: Duration.zero,
          frameDirectory: Directory(""),
        )) {
    _initializeScrollControllers();
    _addScrollListener();
  }

  // Method to calculate the total duration of all videos
  void _calculateTotalDuration() {
    final totalDuration = state.videoControllers.fold(
      Duration.zero,
      (sum, controller) => sum + controller.value.duration,
    );
    state = state.copyWith(totalDuration: totalDuration);
  }

  Future<void> addVideoFromFile(File video) async {
    final controller = VideoPlayerController.file(video);
    await controller.initialize();
    controller.addListener(_handleVideoEnd);
    controller.addListener(() {
      state = state.copyWith();
    });
    state = state.copyWith(
      videoControllers: [...state.videoControllers, controller],
    );
    _calculateCumulativeStartTimes();
    _calculateTotalDuration(); // Update total duration whenever a video is added
  }

  void reorderControllers(List<int> newOrder) {
    if (newOrder.length != state.videoControllers.length) return;
    final reorderedControllers =
        newOrder.map((index) => state.videoControllers[index]).toList();
    state = state.copyWith(videoControllers: reorderedControllers);
    _calculateCumulativeStartTimes();
    _calculateTotalDuration(); // Update total duration when controllers are reordered
    state = state.copyWith(
        currentVideoIndex: newOrder.indexOf(state.currentVideoIndex));
  }

  // Variables for managing scroll controllers and timers
  final LinkedScrollControllerGroup _linkedControllerGroup =
      LinkedScrollControllerGroup();
  late final ScrollController timelineScrollController;
  late final ScrollController frameScrollController;
  late final ScrollController overlayScrollController;
  late final ScrollController musicScrollController;

  Timer? _scrollTimer;
  final double _scrollSpeed = 1.05; // Controls the speed of scroll
  late List<int> _cumulativeVideoStartTimes = [];

  void _initializeScrollControllers() {
    timelineScrollController = _linkedControllerGroup.addAndGet();
    frameScrollController = _linkedControllerGroup.addAndGet();
    overlayScrollController = _linkedControllerGroup.addAndGet();
    musicScrollController = _linkedControllerGroup.addAndGet();
  }

  void _addScrollListener() {
    timelineScrollController.addListener(() {
      if (!state.isVideoPlaying) {
        syncVideoWithScrollPosition(offset: timelineScrollController.offset);
      }
    });
  }

  void setFrameDir(Directory path) {
    state = state.copyWith(frameDirectory: path);
  }

  void _calculateCumulativeStartTimes() {
    int cumulativeTime = 0;
    _cumulativeVideoStartTimes = state.videoControllers.map((controller) {
      cumulativeTime += controller.value.duration.inMilliseconds;
      return cumulativeTime;
    }).toList();
  }

  void syncVideoWithScrollPosition({required double offset}) {
    final maxScrollExtent = timelineScrollController.position.maxScrollExtent;
    final totalDuration = _cumulativeVideoStartTimes.last;

    // Calculate the time in the video based on the scroll offset
    final scrollPositionTime = (offset / maxScrollExtent) * totalDuration;

    // Determine which video index we are currently at based on the scroll position
    int videoIndex = state.currentVideoIndex;
    if (scrollPositionTime >
        _cumulativeVideoStartTimes[state.currentVideoIndex]) {
      videoIndex += 1;
    } else if (state.currentVideoIndex == 0) {
      // empty
    } else if (scrollPositionTime <=
        _cumulativeVideoStartTimes[state.currentVideoIndex - 1]) {
      videoIndex -= 1;
    }

    // Only change the index if the user is not scrolling fast
    if (state.currentVideoIndex != videoIndex) {
      state = state.copyWith(currentVideoIndex: videoIndex);
      state.videoControllers[state.currentVideoIndex].pause();
    }

    // Calculate the start time of the current video
    final currentVideoStartTime = state.currentVideoIndex == 0
        ? 0
        : _cumulativeVideoStartTimes[state.currentVideoIndex - 1];

    // Calculate the position in the current video based on the scroll position time
    final positionInCurrentVideo = Duration(
      milliseconds: (scrollPositionTime - currentVideoStartTime).toInt(),
    );

    // Ensure the position is not negative and within the video's duration
    if (positionInCurrentVideo.inMilliseconds < 0) {
      state.videoControllers[state.currentVideoIndex].seekTo(Duration.zero);
    } else if (positionInCurrentVideo.inMilliseconds >
        state.videoControllers[state.currentVideoIndex].value.duration
            .inMilliseconds) {
      // If seeking beyond the duration, seek to the end of the video
      state.videoControllers[state.currentVideoIndex].seekTo(
        state.videoControllers[state.currentVideoIndex].value.duration,
      );
    } else {
      // Seek to the calculated position
      state.videoControllers[state.currentVideoIndex]
          .seekTo(positionInCurrentVideo);
    }

    // Stop the video from playing if manually scrolled
    state = state.copyWith(isVideoPlaying: false);
  }

  void startScrollingOnPlay() {
    if (state.videoControllers.isEmpty) return;

    final cumulativeDuration = state.currentVideoIndex == 0
        ? 0
        : _cumulativeVideoStartTimes[state.currentVideoIndex - 1];
    final currentPosition = state.videoControllers[state.currentVideoIndex]
        .value.position.inMilliseconds;
    final totalPosition = cumulativeDuration + currentPosition;

    final maxScrollExtent = timelineScrollController.position.maxScrollExtent;
    final totalVideoDuration = _cumulativeVideoStartTimes.last;
    final initialScrollOffset =
        (totalPosition / totalVideoDuration) * maxScrollExtent;

    timelineScrollController.jumpTo(initialScrollOffset);

    _scrollTimer = Timer.periodic(const Duration(microseconds: 21500), (timer) {
      if (timelineScrollController.hasClients && state.isVideoPlaying) {
        final currentScrollPosition = timelineScrollController.position.pixels;

        if (currentScrollPosition >= maxScrollExtent) {
          timelineScrollController.jumpTo(0);
        } else {
          timelineScrollController.jumpTo(currentScrollPosition + _scrollSpeed);
        }
      }
    });
  }

  void stopScrollingOnPause() {
    _scrollTimer?.cancel();
  }

  void playCurrent() {
    if (state.videoControllers.isEmpty) return;
    final currentController = state.videoControllers[state.currentVideoIndex];
    if (!currentController.value.isPlaying) {
      currentController.play();
      state = state.copyWith(isVideoPlaying: true);
      startScrollingOnPlay();
    }
  }

  void pauseCurrent() {
    if (state.videoControllers.isEmpty) return;
    final currentController = state.videoControllers[state.currentVideoIndex];
    if (currentController.value.isPlaying) {
      currentController.pause();
      state = state.copyWith(isVideoPlaying: false);
      stopScrollingOnPause();
    }
  }

  void restartAll() {
    if (state.videoControllers.isEmpty) return;
    state.videoControllers[state.currentVideoIndex].pause();
    state = state.copyWith(currentVideoIndex: 0);
    final firstController = state.videoControllers[state.currentVideoIndex];
    firstController.seekTo(Duration.zero);
    stopScrollingOnPause();
    state = state.copyWith(isVideoPlaying: false);
    timelineScrollController.jumpTo(0);
  }

  void _handleVideoEnd() {
    final currentController = state.videoControllers[state.currentVideoIndex];
    if (currentController.value.position == currentController.value.duration) {
      // Check if it was the last video
      if (state.currentVideoIndex == state.videoControllers.length - 1) {
        // Restart all controllers if it was the last video
        // restartAll();
        stopScrollingOnPause();
        state = state.copyWith(isVideoPlaying: false);
      } else {
        // Proceed to the next video
        state = state.copyWith(
            currentVideoIndex:
                (state.currentVideoIndex + 1) % state.videoControllers.length);
        if (state.isVideoPlaying) {
          state.videoControllers[state.currentVideoIndex].play();
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in state.videoControllers) {
      controller.dispose();
    }
    timelineScrollController.dispose();
    frameScrollController.dispose();
    overlayScrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }
}

final videoManagerProvider = StateNotifierProvider<VideoManager, VideoState>(
  (ref) => VideoManager(),
);
