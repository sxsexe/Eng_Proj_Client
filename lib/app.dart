import 'package:my_eng_program/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App {
  // 是否登录成功
  static bool _loginSuccess = false;

  static User? _user;

  static set user(User user) => _user = user;
  static User? getUser() {
    return _user;
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
}
