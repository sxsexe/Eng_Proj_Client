import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier();

  void changeTheme() {
    notifyListeners();
  }
}
