import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_eng_program/data/user.dart';
import 'package:my_eng_program/ui/widgets/theme_notifier.dart';

class App {
  static const String ROUTE_SPLASH = "/splash";
  static const String ROUTE_BOOK_GALLERY_PAGE = "/book_gallery_page";
  static const String ROUTE_WORDS_DETAIL = "/word_detail_page";
  static const String ROUTE_BOOK_CONTENT = "/book_content_page";
  static const String ROUTE_REGISTER = "/register";
  static const String ROUTE_MAIN = "/main";

  static const int LOGIN_TYPE_PWD = 1;
  static const int LOGIN_TYPE_APP = 2;

  static bool ThemeIsDark = false;
  static ThemeNotifier _sThemeNotifier = new ThemeNotifier();
  static ThemeNotifier get themeNotifier => _sThemeNotifier;

  // 是否登录成功
  static bool _loginSuccess = false;

  static User? _user;
  static set user(User user) => _user = user;
  static User? getUser() {
    if (!_loginSuccess) {
      User user = User.fromJson({'_id': "", 'type': 0, "create_time": "", "auths": []});
      return user;
    }
    return _user;
  }

  static String? getUserId() {
    if (_user != null) return _user!.id;
    return null;
  }

  static set loginState(bool success) => _loginSuccess = success;
  static bool isLoginSuccess() {
    return _loginSuccess;
  }

  static isInProductMode() {
    const bool inProduction = const bool.fromEnvironment("dart.vm.product");
    return inProduction;
  }

  static isInDebugMode() {
    const bool inProduction = const bool.fromEnvironment("dart.vm.product");
    return !inProduction;
  }

  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
