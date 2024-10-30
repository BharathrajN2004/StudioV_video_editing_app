import 'dart:async';

import 'package:flutter/material.dart';

class AutoScrollingList extends StatefulWidget {
  const AutoScrollingList({super.key});

  @override
  _AutoScrollingListState createState() => _AutoScrollingListState();
}

class _AutoScrollingListState extends State<AutoScrollingList> {
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  final double _scrollSpeed = 2.0; // Control speed of the scroll
  bool _isScrolling = true;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_scrollController.hasClients && _isScrolling) {
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double currentScrollPosition = _scrollController.position.pixels;

        if (currentScrollPosition >= maxScrollExtent) {
          _scrollController.jumpTo(0); // Loop back to start
        } else {
          // Scroll by a small increment
          _scrollController.jumpTo(currentScrollPosition + _scrollSpeed);
        }
      }
    });
  }

  void _toggleScrolling() {
    setState(() {
      _isScrolling = !_isScrolling;
      if (_isScrolling) {
        _startAutoScroll();
      } else {
        _scrollTimer?.cancel(); // Stop the timer to pause scrolling
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Scrolling List with Pause/Resume'),
        actions: [
          IconButton(
            icon: Icon(_isScrolling ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleScrolling,
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://images.pexels.com/photos/1172064/pexels-photo-1172064.jpeg?auto=compress&cs=tinysrgb&w=600', // Replace with your image URL
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
