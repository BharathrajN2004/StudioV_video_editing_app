import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/controller.provider.dart';
import '../../providers/active_layer.provider.dart';
import '../../utilities/constants.dart';
import '../../utilities/theme.dart';

class FrameList extends ConsumerStatefulWidget {
  const FrameList({super.key});

  @override
  ConsumerState<FrameList> createState() => _FrameListState();
}

class _FrameListState extends ConsumerState<FrameList> {
  List<String> _imagePathList = [];

  @override
  void initState() {
    super.initState();
    _initializeFrames();
  }

  void _initializeFrames() async {
    final Directory framesDir = ref.read(videoManagerProvider).frameDirectory;
    List<FileSystemEntity> files = framesDir.listSync();

    _imagePathList = files
        .where((file) => file.path.endsWith('.png'))
        .map((file) => file.path)
        .toList();
    _watchDirectory(framesDir);
  }

  void _watchDirectory(Directory framesDir) {
    framesDir.watch().listen((event) {
      if (event is FileSystemCreateEvent && event.path.endsWith('.png')) {
        if (mounted) {
          setState(() {
            _imagePathList.add(event.path);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    final videoState = ref.watch(videoManagerProvider);
    final videoManager = ref.watch(videoManagerProvider.notifier);

    Layers? activeLayer = ref.watch(activeLayerProvider);
    LayerNotifier notifier = ref.read(activeLayerProvider.notifier);

    int totalDuration = videoState.totalDuration.inSeconds + 1;

    return Opacity(
      opacity: activeLayer == Layers.frame ? 1 : .5,
      child: Container(
        height: 52,
        margin: const EdgeInsets.symmetric(vertical: 2.5),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: videoManager.frameScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: (totalDuration * .75).toInt() + 1,
            padding: EdgeInsets.symmetric(horizontal: width * .48),
            itemBuilder: (context, index) {
              bool isLast = ((totalDuration * .75).toInt() + 1) == index + 1;
              bool isSelected = activeLayer == Layers.frame;

              bool available = index <= _imagePathList.length;

              return GestureDetector(
                onTap: () {
                  if (Layers.frame != activeLayer) {
                    notifier.toggleActiveLayer(Layers.frame);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          // First Index
                          index == 0
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12))
                              // Last Index
                              : isLast
                                  ? const BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12))
                                  // Others
                                  : BorderRadius.circular(0),
                      border: isSelected
                          ? Border(
                              left: index == 0
                                  ? const BorderSide(
                                      color: gradientColor1,
                                      width: 2,
                                    )
                                  : BorderSide.none,
                              top: const BorderSide(
                                  color: gradientColor1, width: 2),
                              bottom: const BorderSide(
                                  color: gradientColor1, width: 2),
                              right: isLast
                                  ? const BorderSide(
                                      color: gradientColor1,
                                      width: 2,
                                    )
                                  : BorderSide.none,
                            )
                          : null,
                      color: secondaryColor),
                  child: ClipRRect(
                    borderRadius:
                        // First Index
                        index == 0
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))
                            // Last Index
                            : isLast
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))
                                // Others
                                : BorderRadius.circular(0),
                    child: available
                        ? SizedBox(
                            width: 60,
                            child: Image.file(
                              File(_imagePathList[index]),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox(width: 60),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
