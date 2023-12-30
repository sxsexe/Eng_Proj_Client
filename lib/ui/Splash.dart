import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/user.dart';
import 'package:my_eng_program/io/net.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/Resp.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  int _alpha = 0;
  int _sentIndex = 0;
  int _loginState = -1;

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

  Future<bool> autoLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? userIdentifier = await sp.getString("user_identifier");
    if (userIdentifier != null && userIdentifier.isNotEmpty) {
      Resp resp = await Service.login(userIdentifier, "");
      App.loginState = resp.error.errorNo == 0;
      App.user = User.fromJson(resp.data['user']);
      return App.isLoginSuccess();
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    // App.putUserIdentifierInSP("13717542218").then((value) => Logger.debug("Splash", "put 13717542218 success"));
    autoLogin().then((value) {
      setState(() {
        _loginState = value ? 1 : 0;
      });

      _startAnimation();
    }).catchError((e) {
      Logger.debug("Splash", "autoLogin Catch error " + e.toString());
    });

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

  Stack _createLoginSuccessUI() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            child: CircleAvatar(backgroundImage: NetworkImage(App.getUser()!.avatar ?? ""), radius: 40), top: 160),
        Positioned(
          top: 260,
          child: Material(
            color: Color.fromARGB(255, 240, 231, 190),
            child: InkWell(
              child: Text(
                "Let's have some fun ->",
                style: TextStyle(
                    color: Color.fromARGB(255, 78, 99, 233), decoration: TextDecoration.underline, fontSize: 24),
              ),
              onTap: () {
                Logger.debug("Splash", "OnClick Let's have some fun");
              },
            ),
          ),
        ),
        Positioned(
            bottom: 40,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Text(_lstSents[_sentIndex],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 26,
                      color: Color.fromARGB(_alpha, 23, 25, 12),
                      decoration: TextDecoration.none)),
            ))
      ],
    );
  }

  Stack _createLoginFailedUI() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 40,
              child: Text(
                "游",
                style: TextStyle(fontSize: 36, color: Colors.white),
              ),
            ),
            top: 160),
        Positioned(
          top: 260,
          child: Material(
            color: Color.fromARGB(255, 240, 231, 190),
            child: InkWell(
              child: Text(
                "Let's have some fun ->",
                style: TextStyle(
                    color: Color.fromARGB(255, 78, 99, 233), decoration: TextDecoration.underline, fontSize: 24),
              ),
              onTap: () {
                Logger.debug("Splash", "OnClick Let's have some fun");
              },
            ),
          ),
        ),
        Positioned(
            bottom: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_lstSents[_sentIndex],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 26,
                      color: Color.fromARGB(_alpha, 23, 25, 12),
                      decoration: TextDecoration.none)),
            ))
      ],
    );
  }

  Widget _createLoginIngUI() {
    return Stack(
      alignment: Alignment.center,
      children: [Text("Loading")],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Container();
    if (_loginState == -1) {
      widget = _createLoginIngUI();
    } else if (_loginState == 1) {
      widget = _createLoginSuccessUI();
    } else {
      widget = _createLoginFailedUI();
    }

    return Container(
        width: double.infinity, height: double.infinity, color: Color.fromARGB(255, 240, 231, 190), child: widget);
  }
}
