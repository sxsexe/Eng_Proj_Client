import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_eng_program/data/model_category.dart';
import 'package:my_eng_program/data/net.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          if (Platform.isWindows) {
            debugPrint("Windows");
          }

          return DrawerDataNotifier();
        },
        child: MaterialApp(
            title: 'EnglishER',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            ),
            home: MyHomePage()));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Go")),
      drawer: HomeDrawer(),
      body: Center(
        child: Text(""),
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
  late Future<List<Category>> futureCategories;

  final List<DrawerItem> _items = [];
  DrawerDataNotifier() {
    futureCategories = fetchCategories(http.Client());
    futureCategories.then((categories) {
      if (_items.isNotEmpty) {
        _items.clear();
      }
      _items.add(DrawerItem(0, 'Header'));
      for (var cat in categories) {
        _items.add(DrawerItem(cat.id, '${cat.title}'));
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
  String _name;

  DrawerItem(this._index, this._name);

  String get name => _name;
  int get index => _index;
}

class _HomneDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var drawerData = context.watch<DrawerDataNotifier>();
    return Drawer(
        backgroundColor: Colors.orange,
        child: ListView.builder(
          itemCount: drawerData.getCount(),
          itemBuilder: (context, index) {
            // debugPrint("build ListView index = $index");
            DrawerItem? item = drawerData.getItem(index);
            var name = item == null ? '' : item.name;
            if (index == 0) {
              return const DrawerHeader(
                child: Text("Header"),
                decoration: BoxDecoration(color: Colors.blue),
              );
            } else {
              return ListTile(
                title: Text('$name'),
                selected: drawerData.getCurrentIndex() == index,
                onTap: () {
                  var item = drawerData.getItem(index);
                  String title = item == null ? 'nothing' : item.name;
                  final snackBar = SnackBar(content: Text(title));
                  // 从组件树种找到ScaffoldMessager，并用它去show一个snackBar
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  drawerData.onItemTapped(index);
                  Navigator.pop(context);
                },
              );
            }
          },
        ));
  }
}

class HomeDrawer extends StatefulWidget {
  HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomneDrawerState();
}
