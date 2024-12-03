import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../providers/controller.provider.dart';

class VideoEditorPage extends ConsumerStatefulWidget {
  const VideoEditorPage({super.key});

  @override
  ConsumerState<VideoEditorPage> createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends ConsumerState<VideoEditorPage> {
  @override
  void initState() {
    super.initState();
    // Initialize the video assets after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref
      //     .read(videoManagerProvider.notifier)
      //     .addVideoFromAsset("assets/example/video.mp4");
      // ref
      //     .read(videoManagerProvider.notifier)
      //     .addVideoFromAsset("assets/example/video2.mp4");
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoManagerProvider);
    final videoManager = ref.read(videoManagerProvider.notifier);

    print(videoState.videoControllers[videoState.currentVideoIndex].value
        .position.inSeconds);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Video player display in the top half
          Expanded(
            flex: 1,
            child: videoState.videoControllers.isNotEmpty
                ? Stack(
                    children: [
                      VideoPlayer(videoState
                          .videoControllers[videoState.currentVideoIndex]),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Text(videoState
                            .videoControllers[videoState.currentVideoIndex]
                            .value
                            .position
                            .inSeconds
                            .toString()),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      'No video loaded',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
          // Timeline, overlay, frame, and music sections in bottom half
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildTimelineView(videoManager, videoState, size),
                _buildOverlayView(videoManager, videoState, size),
                _buildFrameView(videoManager, videoState, size),
                _buildMusicView(videoState, size),
              ],
            ),
          ),
        ],
      ),
      // Playback control button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (videoState.isVideoPlaying) {
            videoManager.pauseCurrent();
          } else {
            videoManager.playCurrent();
          }
        },
        child: Icon(
          videoState.isVideoPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  Widget _buildTimelineView(
      VideoManager videoManager, VideoState videoState, Size size) {
    return Expanded(
      child: ListView.builder(
        padding:
            EdgeInsets.only(left: size.width * 0.3, right: size.width * .7),
        controller: videoManager.timelineScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: videoState.videoControllers.isNotEmpty
            ? videoState.totalDuration.inSeconds
            : 0,
        itemBuilder: (context, index) => Container(
          width: 60,
          color: index.isEven ? Colors.grey[800] : Colors.grey[700],
          child: Center(
            child: Text(
              '${index}s',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayView(
      VideoManager videoManager, VideoState videoState, Size size) {
    return Expanded(
      child: ListView.builder(
        padding:
            EdgeInsets.only(left: size.width * 0.3, right: size.width * .7),
        controller: videoManager.overlayScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: videoState.videoControllers.isNotEmpty
            ? videoState.totalDuration.inSeconds
            : 0,
        itemBuilder: (context, index) => Container(
          width: 60,
          color: index.isEven ? Colors.grey[900] : Colors.grey[800],
          child: Center(
            child: Text(
              'Overlay $index',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrameView(
      VideoManager videoManager, VideoState videoState, Size size) {
    return Expanded(
      child: ListView.builder(
        padding:
            EdgeInsets.only(left: size.width * 0.3, right: size.width * .7),
        controller: videoManager.frameScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: videoState.videoControllers.isNotEmpty
            ? videoState.totalDuration.inSeconds
            : 0,
        itemBuilder: (context, index) => Container(
          width: 60,
          color: index.isEven ? Colors.grey[600] : Colors.grey[500],
          child: Center(
            child: Text(
              'Frame $index',
              style: const TextStyle(color: Colors.white60),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMusicView(VideoState videoState, Size size) {
    return Expanded(
      child: ListView.builder(
        padding:
            EdgeInsets.only(left: size.width * 0.3, right: size.width * .7),
        scrollDirection: Axis.horizontal,
        itemCount: videoState.videoControllers.isNotEmpty
            ? videoState.totalDuration.inSeconds
            : 0,
        itemBuilder: (context, index) => Container(
          width: 60,
          color: index.isEven ? Colors.grey[850] : Colors.grey[750],
          child: Center(
            child: Text(
              'Beat $index',
              style: const TextStyle(color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }
}
