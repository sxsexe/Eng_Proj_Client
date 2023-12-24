import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_eng_program/data/model_book.dart';
import 'package:my_eng_program/data/net.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 1, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true // Should each log print contain a timestamp
      ),
);

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
      drawer: HomeDrawer(),
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
    futureCategories = Service.fetchCategories(http.Client());
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

class DrawerItem {
  int _index;
  String _id;
  String _name;

  DrawerItem(this._index, this._id, this._name);

  String get name => _name;
  String get id => _id;
  int get index => _index;
}

class _HomneDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.orange,
        child: FutureProvider<List<Book>>(
          initialData: [],
          create: (context) => Service.fetchCategories(http.Client()),
          child: DrawerListView(),
        ));
  }
}

// ignore: must_be_immutable
class DrawerListView extends StatelessWidget {
  late var drawerItems;

  @override
  Widget build(BuildContext context) {
    drawerItems = context.watch<List<Book>>();
    return ListView.builder(
      itemCount: drawerItems.length,
      itemBuilder: (context, index) {
        debugPrint("build ListView index = $index");
        var title = drawerItems[index].title;

        if (index == 0) {
          return const DrawerHeader(
            child: Text("Header"),
            decoration: BoxDecoration(color: Colors.blue),
          );
        } else {
          return ListTile(
            title: Text(
              '$title',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              final snackBar = SnackBar(content: Text(title));
              // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }
}

class HomeDrawer extends StatefulWidget {
  HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomneDrawerState();
}
