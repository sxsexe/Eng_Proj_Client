import 'package:flutter/material.dart';
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/net/net.dart';
import 'package:http/http.dart' as http;
import 'package:my_eng_program/util/logger.dart';

import 'ui/drawer_item.dart';
import 'ui/home_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EnglishER',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage());
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Go")),
      drawer: HomeDrawer(
        onItemClick: (book) {
          Logger.debug("HomePage", "onItemClick book = ${book.title}");
        },
      ),
      body: Center(
        child: Text("xxxx"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
