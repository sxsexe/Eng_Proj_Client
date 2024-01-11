import 'package:flutter/material.dart';
import 'package:my_eng_program/data/user.dart';

class App {
  static const String ROUTE_SPLASH = "/splash";
  static const String ROUTE_BOOK_GROUP = "/book_group";
  static const String ROUTE_WORDS_DETAIL = "/word_detail_page";
  static const String ROUTE_REGISTER = "/register";
  static const String ROUTE_MAIN = "/main";

  static const int LOGIN_TYPE_PWD = 1;
  static const int LOGIN_TYPE_APP = 2;

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
    return "";
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
