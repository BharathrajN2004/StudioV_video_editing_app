import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';

import '../components/text.dart';
import '../functions/extract_frames.function.dart';
import '../providers/controller.provider.dart';
import '../providers/project_starter.provider.dart';
import '../utilities/theme.dart';
import 'processing_animation_page.dart';

///
/// This Project settings page requires *PROJECT PROVIDER* to be initialized with video data
///
class ProjectSettingsPage extends ConsumerStatefulWidget {
  const ProjectSettingsPage({super.key});

  @override
  ConsumerState<ProjectSettingsPage> createState() =>
      _ProjectSettingsPageState();
}

class _ProjectSettingsPageState extends ConsumerState<ProjectSettingsPage> {
  late TextEditingController controller;
  String createProjectTitle() {
    final now = DateTime.now();
    final formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    return 'project $formattedDate';
  }

  @override
  void initState() {
    super.initState();

    String projectName = createProjectTitle();
    controller = TextEditingController(text: projectName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;

    ProjectState projectState = ref.watch(projectProvider);
    ProjectStateNotifier notifier = ref.read(projectProvider.notifier);

    List<List<dynamic>> aspectRatios = [
      [80, 150, "9:16"],
      [120, 150, "3:4"],
      [90, 110, "4:5"],
      [160, 100, "16:9"],
      [85, 85, "1:1"],
      [130, 90, "4:3"],
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: height * 0.02,
            left: width * 0.05,
            right: width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Symbols.arrow_back_rounded,
                      weight: 700,
                      grade: 200,
                      fill: 1,
                      color: iconColor,
                      size: midIconSize * aspectRatio,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    "New Project",
                    style: TextStyle(
                      color: textColor,
                      fontSize: (veryLargeTextSize + 3) * aspectRatio,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),

              SizedBox(height: height * 0.02),

              ///Project title
              Text(
                "Project Title",
                style: TextStyle(
                  color: textColor,
                  fontSize: (superLargeTextSize - 3) * aspectRatio,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                height: height * 0.0525,
                margin:
                    EdgeInsets.only(top: height * 0.015, bottom: height * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: secondaryColor,
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    color: textColor,
                    fontSize: veryLargeTextSize * aspectRatio,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: width * 0.03, bottom: 4),
                    hintText: "Project Name...",
                    hintStyle: TextStyle(
                      color: lightShade2,
                      fontSize: veryLargeTextSize * aspectRatio,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              /// Aspect Ratio
              ///
              Text(
                "Aspect Ratio",
                style: TextStyle(
                  color: textColor,
                  fontSize: (superLargeTextSize - 3) * aspectRatio,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: height * 0.135,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  children: aspectRatios.map(
                    (e) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: e[1] * aspectRatio,
                              width: e[0] * aspectRatio,
                              margin: EdgeInsets.only(
                                left: width * 0.05,
                                right: width * 0.05,
                                bottom: height * 0.0175,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: e[2] == "16:9"
                                      ? gradientColor1
                                      : greyShade,
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                gradient: LinearGradient(
                                  begin: aspectRatios.indexOf(e) & 1 == 0
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  end: aspectRatios.indexOf(e) & 1 == 0
                                      ? Alignment.bottomRight
                                      : Alignment.bottomLeft,
                                  colors: e[2] == "16:9"
                                      ? [
                                          gradientColor1.withOpacity(.6),
                                          gradientColor2.withOpacity(.6)
                                        ]
                                      : [greyShade.withOpacity(.8), bgColor],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -height * 0.02,
                            left: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                e[2],
                                style: TextStyle(
                                  color: lightShade1,
                                  fontSize: largeTextSize * aspectRatio,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),

              SizedBox(height: height * 0.03),

              /// Green Screen check
              ///
              Text(
                "Green Screen",
                style: TextStyle(
                  color: textColor,
                  fontSize: (superLargeTextSize - 3) * aspectRatio,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: height * 0.015),
              if (projectState.imagePaths.isEmpty)
                Center(
                  child: Shimmer.fromColors(
                    baseColor: lightShade2,
                    highlightColor: lightShade1,
                    direction: ShimmerDirection.ltr,
                    child: Text(
                      "Extracting frames...\nScanning for green screen content!",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: lightShade1,
                        fontSize: midTextSize * aspectRatio,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

              if (projectState.imagePaths.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.015),
                  height: height * 0.08,
                  child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.005,
                        horizontal: width * 0.01,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: projectState.imagePaths.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.03),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: gradientColor1,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.file(
                              File(projectState.imagePaths[index]),
                              height: height * 0.07,
                              width: height * 0.07,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                ),

              if (projectState.chromakey != null &&
                  projectState.chromakey != Colors.black)
                Row(
                  children: [
                    Container(
                      height: aspectRatio * 100,
                      width: aspectRatio * 100,
                      margin: EdgeInsets.only(
                        right: width * 0.05,
                        left: width * 0.04,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: projectState.chromakey,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Presence of GREEN SCREEN is confirmed",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: textColor,
                          fontSize: midTextSize * aspectRatio,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: height * 0.02),

              if (projectState.chromakey != null &&
                  projectState.chromakey != Colors.black)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Toggle to remove the green screen",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: textColor,
                          fontSize: largeTextSize * aspectRatio,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                        activeColor: bgColor,
                        activeTrackColor: gradientColor2,
                        applyCupertinoTheme: true,
                        value: projectState.isRemoveGS,
                        onChanged: (value) {
                          notifier.toggleRemoveGreenScreen(value);
                        })
                  ],
                ),

              if (projectState.chromakey == null ||
                  projectState.chromakey == Colors.black)
                Text(
                  "No green screen detected in the video.",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: lightShade1,
                    fontSize: largeTextSize * aspectRatio,
                    fontWeight: FontWeight.w800,
                  ),
                ),

              const Spacer(),

              /// Start button
              ///
              GestureDetector(
                onTap: () async {
                  // if (projectState.isRemoveGS == true) {
                  //   // greenScreenRemover(ref: ref);
                  // } else {
                  ref
                      .read(videoManagerProvider.notifier)
                      .addVideoFromFile(projectState.videoFile!);
                  extractFrames(
                    videoFile: projectState.videoFile!,
                    notifier: ref.read(videoManagerProvider.notifier),
                    projectNotifier: notifier,
                    videoName: projectState.videoName!,
                  );
                  // }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProcessingAnimationPage()),
                  );
                },
                child: Container(
                  width: width * .9,
                  margin: EdgeInsets.symmetric(vertical: height * 0.015),
                  padding: EdgeInsets.symmetric(vertical: height * 0.0125),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: linearGradient,
                  ),
                  alignment: Alignment.center,
                  child: CustomText(
                    text: "Start",
                    color: Colors.white,
                    weight: FontWeight.w800,
                    size: veryLargeTextSize * aspectRatio,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
