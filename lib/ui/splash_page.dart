import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/user.dart';
import 'package:my_eng_program/io/Api.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:my_eng_program/util/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginState {
  UNREGISTER,
  LOGINING,
  LOGIN_OK,
  LOGIN_FAILED,
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  double _radis = 0;
  // 0 : login failed, 1 : login success, -1 :
  bool _AnimStopped = false;
  LoginState _curState = LoginState.LOGINING;
  String? _errorInfo;

  static const String TAG = "SplashPage";

  String _sentenceToday = "";

  late AnimationController _animationController;

  Future<void> autoLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? identifier = await sp.getString(Strings.KEY_USER_IDENTIFIER);
    String? credential = await sp.getString(Strings.KEY_USER_CREDENTIAL);

    //FIXME
    identifier = "111111";
    credential = "2222222";

    if (identifier == null || identifier.trim().isEmpty) {
      setState(() {
        _curState = LoginState.UNREGISTER;
      });
    } else {
      _animationController =
          AnimationController(vsync: this, duration: Duration(milliseconds: 500), lowerBound: 0, upperBound: 1)
            ..addListener(() {
              setState(() {
                _radis = _animationController.value.toInt() * 60;
              });
            });
      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Logger.debug(TAG, "AnimationStatus.completed");
          setState(() {
            _AnimStopped = true;
          });
        }
      });

      setState(() {
        _curState = LoginState.LOGINING;
      });

      Api.getSentenceToday().then((value) {
        setState(() {
          _sentenceToday = value ?? "";
        });
      });

      Api.login(identifier, credential).then((resp) {
        if (resp.isSuccess()) {
          App.user = User.fromJson(resp.data["user"]);
          App.loginState = true;
          setState(() {
            _curState = LoginState.LOGIN_OK;
          });
          _startAnimation();
        } else {
          throw resp.error;
        }
      }).catchError((err) {
        App.loginState = false;
        setState(() {
          _errorInfo = Strings.ERROR_MSG_LOGIN_FAILED;
          _curState = LoginState.LOGIN_FAILED;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    autoLogin();
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

  void _gotoRegisterPage() async {
    // Navigator.pop(context);
    Navigator.pushNamed(context, App.ROUTE_REGISTER);

    // final player = AudioPlayer();
    // final duration =
    //     await player.setUrl("https://helenadailyenglish.com/English Story for Beginner/10. Today's Mail.mp3");
    // // player.play(); // 播放（不等待结束）
    // await player.play(); // 播放（等待结束）
    // await player.pause();                           // 暂停（保持准备播放）
    // await player.seek(Duration(seconds: 10));        // 跳到第 10 秒的位置
    // await player.setSpeed(2.0);                     // 2倍加速播放
    // await player.setVolume(0.5);                    // 音量降半
    // await player.stop();
  }

  Widget _createHint() {
    return Positioned(
        bottom: 32,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              _sentenceToday,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w200,
                  ),
            ),
          ),
        ));
  }

  Widget _createNavLink() {
    var _textStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w300,
      decoration: TextDecoration.underline,
      fontStyle: FontStyle.italic,
      fontSize: 24,
    );

    Widget t = Text(
      Strings.BTN_TEXT_GO_LOGIN,
      style: _textStyle,
    );

    return Positioned(
      top: 320,
      child: Material(
        // color: Color.fromARGB(255, 240, 231, 190),
        child: InkWell(
          child: t,
          onTap: () {
            Logger.debug(TAG, "OnClick Let's have some fun");
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        radius: _radis,
        child: Text(
          C,
          style: TextStyle(fontSize: 64, color: Theme.of(context).colorScheme.primary),
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
        if (_AnimStopped) _createNavLink(),
        if (_AnimStopped) _createHint(),
      ],
    );
  }

  Widget _createLoginFailedUI() {
    Logger.debug(TAG, "_createLoginFailedUI");

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorInfo!,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              onPressed: () {
                setState(() {
                  _curState = LoginState.LOGINING;
                });
                Future.delayed(Duration(seconds: 2), () {
                  autoLogin();
                });
              },
              child: Text(
                "点击重试",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createLoginIngUI() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          Strings.STR_LOGINING,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
            fontSize: 18,
          ),
        )
      ],
    );
  }

  Widget _createRegisterLinkUI() {
    // return Center();
    return Center(
      child: Material(
        child: InkWell(
          child: Text(
            Strings.STR_ASK_TO_REGISTER,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              decoration: TextDecoration.underline,
              fontSize: 20,
            ),
          ),
          onTap: () {
            _gotoRegisterPage();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = SizedBox();
    // Logger.debug("Splash", "build _loginState = $_loginState");
    if (LoginState.LOGINING == _curState) {
      widget = _createLoginIngUI();
    } else if (LoginState.LOGIN_OK == _curState) {
      widget = _createLoginSuccessUI();
    } else if (LoginState.LOGIN_FAILED == _curState) {
      widget = _createLoginFailedUI();
    } else if (LoginState.UNREGISTER == _curState) {
      widget = _createRegisterLinkUI();
    }

    return Material(
      child: Container(
        child: widget,
        color: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
