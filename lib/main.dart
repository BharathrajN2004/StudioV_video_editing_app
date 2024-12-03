import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_editing_app/functions/clear_directory.dart';

import 'views/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Directory cleansing
  clearApplicationDirectory();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "StudioV",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Nunito"),
      home: const HomePage()
    );
  }
}
