import 'package:flutter/material.dart';
import 'package:my_eng_program/data/word.dart';

import '../data/book.dart';
import '../io/net.dart';
import '../util/logger.dart';
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

    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // Logger.debug(TAG, "argument args = $args");
    _book = Book.fromJson(args);
    Logger.debug(TAG, "argument book = $_book");
    // String dbName = args['word_db_name'];
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
