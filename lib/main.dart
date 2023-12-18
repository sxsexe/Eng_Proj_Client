import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          DrawerItem.init();
          return DrawerNotifier();
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
    var drawerState = context.watch<DrawerNotifier>();
    return Scaffold(
      appBar: AppBar(title: Text("Go")),
      drawer: HomeDrawer(),
      body: Center(
        child: Text("${drawerState.getCurrentItem().name}"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class DrawerNotifier extends ChangeNotifier {
  var currentIndex = 0;

  void onItemTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }

  DrawerItem getCurrentItem() {
    DrawerItem? item = DrawerItem.getItem(currentIndex);
    if (item == null) {
      return DrawerItem(-2, 'NULL');
    } else {
      return item;
    }
  }

  int getCurrentIndex() {
    return currentIndex;
  }
}

class DrawerItem {
  int? _index;
  String? _name;

  DrawerItem(this._index, this._name);

  String? get name => _name;
  int? get index => _index;

  static final List<DrawerItem> _items = [];

  static void init() {
    _items.add(DrawerItem(0, 'Header'));
    for (var i = 1; i < 10; i++) {
      _items.add(DrawerItem(i, 'Item $i'));
    }
  }

  static int getCount() {
    return _items.length;
  }

  static DrawerItem? getItem(int index) {
    return _items[index];
  }
}

class _HomneDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    var drawerState = context.watch<DrawerNotifier>();
    return Drawer(
        backgroundColor: Colors.orange,
        child: ListView.builder(
          itemCount: DrawerItem.getCount(),
          itemBuilder: (context, index) {
            debugPrint("build ListView index = $index");
            DrawerItem? item = DrawerItem.getItem(index);
            var name = item == null ? '' : item.name;
            if (index == 0) {
              return const DrawerHeader(
                child: Text("Header"),
                decoration: BoxDecoration(color: Colors.blue),
              );
            } else {
              return ListTile(
                title: Text('$name'),
                selected: drawerState.getCurrentIndex() == index,
                onTap: () {
                  drawerState.onItemTapped(index);
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
