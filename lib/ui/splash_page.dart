import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/user.dart';
import 'package:my_eng_program/io/net.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:my_eng_program/util/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/server_resp.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  int _alpha = 0;
  double _radis = 0;
  // 0 : login failed, 1 : login success, -1 : ing
  int _loginState = -1;
  bool _showNavLink = false;

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
    String? identifier = await sp.getString(Strings.KEY_USER_IDENTIFIER);
    String? credential = await sp.getString(Strings.KEY_USER_CREDENTIAL);

    //FIXME
    identifier = "111111";
    credential = "2222222";

    Resp resp = await Service.login(identifier, credential);
    App.loginState = resp.error.errorNo == 0;
    if (resp.data != null) App.user = User.fromJson(resp.data!['user']);
    bool login = App.isLoginSuccess();
    return login;
  }

  @override
  void initState() {
    super.initState();

    autoLogin().then((value) {
      setState(() {
        _loginState = value ? 1 : 0;
      });
      _startAnimation();
    }).catchError((e) {
      Logger.debug("Splash", "autoLogin Catch error " + e.toString());
      setState(() {
        _loginState = 0;
      });
      _startAnimation();
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000), lowerBound: 0, upperBound: 1)
          ..addListener(() {
            setState(() {
              int value = _animationController.value.toInt();
              _alpha = value * 255;
              _radis = value * 60;
            });
          });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Logger.debug("Splash", "Animation Complete");
        setState(() {
          _showNavLink = true;
        });
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

  void _goToMainPage() {
    Navigator.pop(context);
    Navigator.pushNamed(context, App.ROUTE_MAIN);
  }

  void _gotoRegisterPage() {
    // Navigator.pop(context);
    Navigator.pushNamed(context, App.ROUTE_REGISTER);
  }

  Widget _createHint() {
    int index = Random().nextInt(_lstSents.length);

    return Positioned(
        bottom: 40,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(_lstSents[index],
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: Color.fromARGB(_alpha, 23, 25, 12),
                    decoration: TextDecoration.none)),
          ),
        ));
  }

  Widget _createNavLink() {
    Widget t;
    if (_loginState == 1) {
      t = Text(
        "Let's have some fun ->",
        style: TextStyle(color: Colors.black, decoration: TextDecoration.underline, fontSize: 24),
      );
    } else if (_loginState == 0) {
      t = Text(
        "直接使用",
        style: TextStyle(color: Colors.black, decoration: TextDecoration.none, fontSize: 28),
      );
    } else {
      t = SizedBox(
        height: 0,
      );
    }

    return Positioned(
      top: 320,
      child: Material(
        color: Color.fromARGB(255, 240, 231, 190),
        child: InkWell(
          child: t,
          onTap: () {
            Logger.debug("Splash", "OnClick Let's have some fun");
            _goToMainPage();
          },
        ),
      ),
    );
  }

  Stack _createLoginSuccessUI() {
    String? _avatarUrl = App.getUser()!.avatar ?? "";
    String? _name = App.getUser()!.name;
    String C = "";
    if (_name != null && _name.isNotEmpty) {
      C = _name[0];
    }

    Widget _avatar;
    if (_avatarUrl.isEmpty) {
      _avatar = CircleAvatar(
        backgroundColor: Colors.green,
        radius: _radis,
        child: Text(
          C,
          style: TextStyle(fontSize: 64, color: Colors.black),
        ),
      );
    } else {
      _avatar = Container(
        width: _radis * 3,
        height: _radis * 3,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(_radis * 3 / 2), child: CachedNetworkImage(imageUrl: _avatarUrl)),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(child: _avatar, top: 160),
        if (_showNavLink) _createNavLink(),
        _createHint(),
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
              radius: _radis,
              child: Text(
                "游",
                style: TextStyle(fontSize: 64, color: Colors.black),
              ),
            ),
            top: 160),
        if (_showNavLink) _createNavLink(),
        Material(
          child: InkWell(
            child: Text(
              "现在去注册?",
              style: TextStyle(color: Colors.black87, decoration: TextDecoration.underline, fontSize: 16),
            ),
            onTap: () {
              _gotoRegisterPage();
            },
          ),
        ),
        _createHint()
      ],
    );
  }

  Widget _createLoginIngUI() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text("Loading...",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.normal, decoration: TextDecoration.none, fontSize: 24))
      ],
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
