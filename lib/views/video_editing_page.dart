import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/editor/editor_header.dart';
import '../components/editor/frame_list.dart';
import '../components/editor/layer_edit_options.dart';
import '../components/editor/music_list.dart';
import '../components/editor/option_list.dart';
import '../components/editor/overlay_list_widget.dart';
import '../components/editor/sub_option_helper.dart';
import '../components/editor/timeline_widget.dart';
import '../components/editor/video_container.dart';
import '../components/editor/video_footer.dart';
import '../providers/active_layer.provider.dart';
import '../utilities/constants.dart';
import '../utilities/theme.dart';

class VideoEditingPage extends ConsumerStatefulWidget {
  const VideoEditingPage({super.key});

  @override
  ConsumerState<VideoEditingPage> createState() => _VideoEditingPageState();
}

class _VideoEditingPageState extends ConsumerState<VideoEditingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    Layers? activeLayer = ref.watch(activeLayerProvider);
    LayerNotifier notifier = ref.read(activeLayerProvider.notifier);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const EditorHeader(),
            const VideoContainer(),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  /// video Footer
                  const VideoFooter(),

                  /// Main Editing portion
                  ///
                  Expanded(
                    child: GestureDetector(
                      /// To have highlighting gesture
                      ///
                      onTap: () => notifier.toggleActiveLayer(null),
                      child: Container(
                        color: bgColor,
                        child: Stack(
                          children: [
                            const Column(
                              children: [
                                /// timeLine
                                ///
                                TimeLineWidget(),

                                /// text and image overlay list
                                ///
                                OverlayWidget(),

                                /// Frame list
                                ///
                                FrameList(),

                                /// Music list
                                ///
                                MusicList(),
                              ],
                            ),

                            /// Yellow Line
                            ///
                            Positioned(
                              left: width * .48,
                              child: Container(
                                width: 2.5,
                                height: 147,
                                margin: EdgeInsets.only(
                                    top: height * 0.07 +
                                        (aspectRatio * smallTextSize - 5)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: separatorColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Extra options view
                  ///
                  SubOptionHelper(),

                  /// options List
                  ///
                  activeLayer == null
                      ? const OptionsList()
                      : const LayerEditOptions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
