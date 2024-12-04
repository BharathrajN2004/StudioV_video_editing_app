import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

import '../utilities/theme.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Ticker _ticker;

  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker((elapsed) {
      setState(() {
        _elapsed = elapsed;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double height = MediaQuery.of(context).size.height;

    return AnimatedSplashScreen(
        backgroundColor: bgColor,
        splashIconSize: height,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/studioV.png",
              height: aspectRatio * 240,
              width: aspectRatio * 240,
            ),
            SizedBox(height: height * 0.04),
            ShaderBuilder(assetKey: 'assets/shaders/wrap.frag',
                (BuildContext context, FragmentShader shader, _) {
              return ShaderMask(
                shaderCallback: (Rect bounds) {
                  shader.setFloat(0, bounds.width * 5);
                  shader.setFloat(1, bounds.height * 5);
                  shader.setFloat(2, _elapsed.inMilliseconds.toDouble() / 1000);
                  return shader;
                },
                blendMode: BlendMode.srcIn,
                child: Center(
                  child: Text(
                    'StudioV',
                    style: TextStyle(
                      fontFamily: "MarkoOne",
                      fontWeight: FontWeight.w900,
                      fontSize: aspectRatio * 90,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: height * 0.06),
          ],
        ),
        duration: 3000,
        nextScreen: const HomePage());
  }
}
