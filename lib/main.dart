// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_editing_app/functions/clear_directory.dart';

// import 'examples/shader_test.dart';
// import 'views/home_page.dart';
// // import 'views/video_editing_page.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   /// Directory cleansing
//   clearApplicationDirectory();

//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ),
//   );

//   runApp(const ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "StudioV",
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(fontFamily: "Nunito"),
//       home: ColorReplaceVideoPlayer(
//         targetColor: Color(0xFF30BE76),
//       ),
//     );
//   }
// }

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shader Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Shader Demo'),
      ),
      body: ShaderBuilder(
        assetKey: 'assets/shaders/color_replace.frag',
        (context, shader, child) => CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ShaderPainter(
            shader: shader,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader});
  ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
