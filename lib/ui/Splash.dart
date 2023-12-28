import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_eng_program/util/logger.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  int _alpha = 0;
  int _sentIndex = 0;
  bool _animStarted = false;

  late AnimationController _animationController;

  List<String> _lstSents = [
    "Knowlegde can change your fate and English can accomplish your future",
    "Keep on going, never give up",
    "Learn And Live",
    "Take learning as a habit",
    "Only hard work, can taste the fruits of victory",
    "Doubt is the key to knowledge",
    "Sharp tools make good work",
    "The best hearts are always the bravest",
    "Suffering is the most powerful teacher of life",
    "All rivers run into the sea",
    "Do one thing at a time, and do well",
    "The only thing we have to fear is fear itself"
  ];

  @override
  void initState() {
    super.initState();
    _sentIndex = Random().nextInt(_lstSents.length);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3000), lowerBound: 0, upperBound: 255)
          ..addListener(() {
            setState(() {
              _alpha = _animationController.value.toInt();
            });
          });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Logger.debug("Splash", "Animation Complete");
      }
    });
  }

  void _startAnimation() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_animStarted) {
      _startAnimation();
      _animStarted = true;
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color.fromARGB(255, 240, 231, 190),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(_lstSents[_sentIndex],
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 26,
                    color: Color.fromARGB(_alpha, 23, 25, 12),
                    decoration: TextDecoration.none)),
          ),
          Positioned(
            bottom: 80,
            child: Column(
              children: [
                Divider(
                  height: 10,
                  thickness: 10,
                  color: Color.fromARGB(255, 78, 99, 233),
                ),
                Material(
                  color: Color.fromARGB(255, 240, 231, 190),
                  child: InkWell(
                    child: Text(
                      "Let's have some fun",
                      style: TextStyle(
                          color: Color.fromARGB(255, 78, 99, 233), decoration: TextDecoration.underline, fontSize: 24),
                    ),
                    onTap: () => Logger.debug("Splash", "OnClick Let's have some fun"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
