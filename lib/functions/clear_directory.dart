import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<void> clearApplicationDirectory() async {
  try {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    if (appDocDir.existsSync()) {
      final List<FileSystemEntity> files = appDocDir.listSync();
      for (FileSystemEntity file in files) {
        if (file is Directory) {
          await file.delete(recursive: true);
        } else if (file is File) {
          await file.delete();
        }
      }
      debugPrint("Application directory cleared successfully.");
    } else {
      debugPrint("Application directory does not exist.");
    }
  } catch (e) {
    debugPrint("Error clearing application directory: $e");
  }
}
