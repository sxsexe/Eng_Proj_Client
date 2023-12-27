import 'package:flutter/material.dart';
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/net/net.dart';
import 'package:http/http.dart' as http;
import 'package:my_eng_program/ui/word_detail_card.dart';
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
  var loading = true;
  Word? word;

  @override
  void initState() {
    super.initState();
    word = Word(name: 'ddd');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Go")),
      drawer: HomeDrawer(
        onBookItemClick: (book) {
          Logger.debug("HomePage", "onItemClick book = ${book.title}");

          var words = Service.getRandomWords(book.title);
          words.then((value) => {
                setState(() {
                  loading = false;
                  word = value[0];
                })
              });
        },
      ),
      body: WordDetailCard(word: word),
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
