import 'package:flutter/material.dart';
import 'package:my_eng_program/data/word.dart';

import '../net/net.dart';
import '../util/logger.dart';
import 'home_drawer.dart';
import 'word_detail_card.dart';

class WordMainPage extends StatefulWidget {
  WordMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WordMainPageState();
  }
}

class _WordMainPageState extends State<WordMainPage> {
  Word? word;
//   Book? _book;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Keep Moving",
        style: Theme.of(context).textTheme.titleMedium,
      )),
      drawer: HomeDrawer(
        onBookItemClick: (book) {
          Logger.debug("MainPage", "onItemClick book = ${book.title}");
          var words = Service.getRandomWords(book.title);
          words.then((value) => {
                setState(() {
                  word = value[0];
                })
              });
        },
      ),
      body: WordDetailCard(context: context, word: word),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //   var words = Service.getRandomWords(_book.title);
          //   words.then((value) => {
          //         setState(() {
          //           word = value[0];
          //         })
          //       });
        },
        tooltip: "Next Word",
        child: Text('Next'),
      ),
    );
  }
}
