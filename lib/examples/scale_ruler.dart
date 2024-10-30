import 'package:flutter/material.dart';

class HorizontalRuler extends StatefulWidget {
  @override
  _HorizontalRulerState createState() => _HorizontalRulerState();
}

class _HorizontalRulerState extends State<HorizontalRuler> {
  final ScrollController _scrollController = ScrollController();
  double selectedValue = 0;

  // Center the initial scroll position on load
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(250); // Centering the initial position
    });
  }

  void _onScroll() {
    // Calculate the selected value based on scroll position
    setState(() {
      selectedValue = (_scrollController.offset / 20).round().toDouble() / 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Horizontal Ruler")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollUpdateNotification) {
                _onScroll();
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: 100, // Represents total markings
              itemBuilder: (context, index) {
                bool isCmMark = index % 10 == 0;
                bool isHalfCmMark = index % 5 == 0 && !isCmMark;

                return Container(
                  width: 20, // Width of each marking
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: isCmMark ? 2 : 1,
                        height: isCmMark
                            ? 50
                            : isHalfCmMark
                                ? 35
                                : 20, // Adjust height for cm, half-cm, mm
                        color: isCmMark
                            ? Colors.white
                            : Colors.white.withOpacity(0.5), // Dim mm markings
                      ),
                      if (isCmMark)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "${index ~/ 10}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(
                                  index == selectedValue * 10 ? 1 : 0.5),
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Center overlay displaying selected value
          Positioned(
            top: 20,
            child: Text(
              "${selectedValue.toStringAsFixed(1)} cm",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ),
          // Gradient overlay for dimming edges
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Center indicator line for the selected position
          Positioned(
            left: screenWidth / 2 - 1,
            top: 20,
            bottom: 20,
            child: Container(
              width: 2,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}

// pageview widget implimentation

// import 'package:flutter/material.dart';

// class SnapToCenterRuler extends StatefulWidget {
//   @override
//   _SnapToCenterRulerState createState() => _SnapToCenterRulerState();
// }

// class _SnapToCenterRulerState extends State<SnapToCenterRuler> {
//   final PageController _pageController = PageController(viewportFraction: .08);
//   double selectedValue = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       setState(() {
//         selectedValue = (_pageController.page ?? 0).toDouble();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(title: Text("Snapping Ruler")),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           // PageView with snapping effect
//           PageView.builder(
//             controller: _pageController,
//             scrollDirection: Axis.horizontal,
//             physics: BouncingScrollPhysics(),
//             itemCount: 100, // Represents total markings
//             itemBuilder: (context, index) {
//               bool isCmMark = index % 10 == 0;
//               bool isHalfCmMark = index % 5 == 0 && !isCmMark;

//               return Container(
//                 width: 2, // Width of each marking
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       width: isCmMark ? 2 : 1,
//                       height: isCmMark
//                           ? 50
//                           : isHalfCmMark
//                               ? 35
//                               : 20, // Adjust height for cm, half-cm, mm
//                       color: isCmMark
//                           ? Colors.white
//                           : Colors.white.withOpacity(0.5), // Dim mm markings
//                     ),
//                     if (isCmMark)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           "${index ~/ 10}",
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(
//                                 index == selectedValue.round() ? 1 : 0.5),
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           // Center overlay displaying selected value
//           Positioned(
//             top: 20,
//             child: Text(
//               "${(selectedValue / 10).toStringAsFixed(1)} cm",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.orangeAccent,
//               ),
//             ),
//           ),
//           // Gradient overlay for dimming edges
//           IgnorePointer(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.7),
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.7),
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                   stops: [0.0, 0.5, 1.0],
//                 ),
//               ),
//             ),
//           ),
//           // Center indicator line for the selected position
//           Positioned(
//             left: screenWidth / 2 - 1,
//             top: 20,
//             bottom: 20,
//             child: Container(
//               width: 2,
//               color: Colors.orangeAccent,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }