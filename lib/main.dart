import 'package:flutter/material.dart';
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/net/net.dart';
import 'package:http/http.dart' as http;
import 'package:my_eng_program/ui/splash.dart';
import 'package:my_eng_program/ui/main_page.dart';
import 'package:my_eng_program/ui/word_detail_card.dart';
import 'package:my_eng_program/util/logger.dart';

import 'ui/drawer_item.dart';
import 'ui/home_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final theme = ThemeData(
      useMaterial3: true,
      dividerColor: Color.fromARGB(128, 247, 187, 13),
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Color.fromARGB(255, 176, 187, 23),
          primary: Color.fromARGB(246, 246, 234, 221),
          onPrimary: Colors.black,
          primaryContainer: Colors.blue,
          secondary: Color.fromARGB(255, 225, 241, 240),
          onSecondary: Colors.black87,
          secondaryContainer: Colors.blueGrey),
      textTheme: TextTheme(
          titleSmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          titleMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          titleLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
          displayLarge: const TextStyle(fontSize: 48, fontWeight: FontWeight.normal),
          displayMedium: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
          displaySmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal)));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'EnglishER', theme: theme, home: Splash());
  }
}

class DrawerDataNotifier extends ChangeNotifier {
  var currentIndex = 0;
  late Future<List<Book>> futureCategories;

  final List<DrawerItem> _items = [];
  DrawerDataNotifier() {
    futureCategories = Service.fetchBooks(http.Client());
    futureCategories.then((categories) {
      if (_items.isNotEmpty) {
        _items.clear();
      }
      var index = 0;
      _items.add(DrawerItem(index, 'header', 'Header'));
      for (var cat in categories) {
        _items.add(DrawerItem(++index, cat.id, cat.title));
      }
      notifyListeners();
    });
  }

  int getCount() {
    return _items.length;
  }

  DrawerItem? getItem(int index) {
    if (index < 0 || index >= _items.length) {
      return null;
    }
    return _items[index];
  }

  void onItemTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }

  int getCurrentIndex() {
    return currentIndex;
  }
}
