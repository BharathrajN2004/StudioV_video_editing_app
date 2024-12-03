import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui' as ui;

class ColorReplaceVideoPlayer extends StatefulWidget {
  final Color targetColor;

  ColorReplaceVideoPlayer({required this.targetColor});

  @override
  _ColorReplaceVideoPlayerState createState() =>
      _ColorReplaceVideoPlayerState();
}

class _ColorReplaceVideoPlayerState extends State<ColorReplaceVideoPlayer> {
  late VideoPlayerController _controller;
  ui.FragmentProgram? _fragmentProgram;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/sample_video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _loadShader();
  }

  Future<void> _loadShader() async {
    final program =
        await ui.FragmentProgram.fromAsset('assets/shaders/color_replace.frag');
    setState(() {
      _fragmentProgram = program;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized || _fragmentProgram == null) {
      return Center(child: CircularProgressIndicator());
    }

    final normalizedColor = [
      widget.targetColor.red / 255.0,
      widget.targetColor.green / 255.0,
      widget.targetColor.blue / 255.0,
      widget.targetColor.opacity
    ];

    return Scaffold(
      body: Center(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: ShaderMask(
              shaderCallback: (rect) {
                final fragmentShader = _fragmentProgram!.fragmentShader();
                fragmentShader.setFloat(0, normalizedColor[0]);
                fragmentShader.setFloat(1, normalizedColor[1]);
                fragmentShader.setFloat(2, normalizedColor[2]);
                fragmentShader.setFloat(3, normalizedColor[3]);
                fragmentShader.setFloat(4, 0.02); // threshold
                fragmentShader.setFloat(5, 0.1); // blend for edge smoothness
                return fragmentShader;
              },
              blendMode: BlendMode.srcIn,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ),
    );
  }
}
