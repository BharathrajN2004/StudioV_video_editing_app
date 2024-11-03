import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:video_editing_app/utilities/theme.dart';

import '../components/home/new_project_button.dart';
import '../components/text.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  Map<String, String> quickActions = {
    "Join Media": "media",
    "Add Music": "music",
    "Speed": "speed",
    "Transitions": "transform",
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, data) async {
        if (didPop) {}
      },
      child: Scaffold(
        floatingActionButton: const NewProjectButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
              left: width * 0.04,
              right: width * 0.04,
              top: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/studioV.png",
                      height: aspectRatio * 90,
                      width: aspectRatio * 90,
                      fit: BoxFit.cover,
                    ),
                    const Spacer(),
                    Image.asset(
                      "assets/icons/listL.png",
                      height: aspectRatio * 60,
                      width: aspectRatio * 60,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: width * 0.04),
                    GestureDetector(
                      child: Icon(
                        Symbols.more_vert_rounded,
                        size: aspectRatio * 60,
                        weight: 10000,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                SizedBox(height: height * 0.03),
                Expanded(
                  child: ListView(
                    children: [
                      CustomText(
                        text: "Quick Actions",
                        size: superLargeTextSize * aspectRatio,
                        color: textColor,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: height * 0.02),
                      SizedBox(
                        height: height * 0.08,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: quickActions.entries.map((data) {
                            return Container(
                              width: width * .25,
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                horizontal: width * .02,
                                vertical: height * .01,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: textColor.withOpacity(.6)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image.asset(
                                    "assets/icons/${data.value}.png",
                                    height: aspectRatio * 60,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  CustomText(
                                    text: data.key,
                                    color: textColor.withOpacity(.8),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      CustomText(
                        text: "My Projects",
                        size: superLargeTextSize * aspectRatio,
                        color: textColor,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: height * 0.03),
                      // ...List.generate(6, (index) {
                      //   return HomePreviewTile(
                      //     script: VideoScript.empty(),
                      //     videoPath: "",
                      //   );
                      // }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
