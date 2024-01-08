import 'package:flutter/material.dart';
import 'package:my_eng_program/data/word.dart';

import '../data/book.dart';
import '../io/net.dart';
import '../util/logger.dart';
import 'widgets/book_group_drawer.dart';
import 'widgets/word_detail_card.dart';

class WordDetailPage extends StatefulWidget {
  const WordDetailPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WordDetailPageState();
  }
}

class _WordDetailPageState extends State<WordDetailPage> {
  Word? _word;
  late Book _book;
//   Book? _book;
  static const String TAG = "WordDetailPage";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _book = ModalRoute.of(context)!.settings.arguments as Book;
    Logger.debug(TAG, "argument book = $_book");
    Service.getRandomWords(_book.DBName).then((words) {
      if (words.isNotEmpty) {
        setState(() {
          _word = words[0];
        });
      }
    });
  }

  Widget _createUI() {
    if (_word == null) {
      return Center(
        child: CircularProgressIndicator(color: Colors.red),
      );
    } else {
      return WordDetailCard(context: context, word: _word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "${_book.name}",
        style: Theme.of(context).textTheme.titleMedium,
      )),
      body: _createUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _word = null;
          });
          var words = Service.getRandomWords(_book.DBName);
          words.then((value) => {
                setState(() {
                  _word = value[0];
                })
              });
        },
        tooltip: "Next Word",
        child: Text('Next'),
      ),
    );
  }
}
