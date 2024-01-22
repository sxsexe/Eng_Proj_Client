import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/io/Api.dart';
import 'package:my_eng_program/util/logger.dart';

import '../data/book.dart';
import 'widgets/word_detail_card.dart';

class WordDetailPage extends StatefulWidget {
  const WordDetailPage({super.key});

  @override
  State<StatefulWidget> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  late Word _word;
  late Book _book;
  bool _loading = true;
  late WordDetailCard _wordDetailCard;
  static const String TAG = "WordDetailPage";

  final int SCORE_1 = 10;
  final int SCORE_2 = 50;
  final int SCORE_3 = 80;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _book = Book.fromJson(args);
    // Logger.debug(TAG, "argument book = $_book");
    Api.getRandomWord(_book.DBName).then((word) {
      setState(() {
        _word = word!;
        _wordDetailCard = WordDetailCard(word: _word);
        _loading = false;
      });
    });
  }

  void _upsertUserWord(score) {
    setState(() {
      _loading = true;
    });

    Api.upsertUserWord(App.getUserId()!, _word.ID, _word.name, score, _word.dbName).then((rs) {
      Api.getRandomWord(_book.DBName).then((word) {
        setState(() {
          _word = word!;
          _loading = false;
          _wordDetailCard = WordDetailCard(word: _word);
        });
      });
    });
  }

  Widget _createOpButtons() {
    var btnTxtStyle = Theme.of(context).textTheme.displaySmall!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary,
        );
    return Container(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      height: 80,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ElevatedButton(
          onPressed: () => _upsertUserWord(SCORE_1),
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Container(
            child: Text("不记得了", style: btnTxtStyle),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        ElevatedButton(
          onPressed: () => _upsertUserWord(SCORE_2),
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Container(
            child: Text("有点模糊", style: btnTxtStyle),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        ElevatedButton(
          onPressed: () => _upsertUserWord(SCORE_3),
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Container(
            child: Text("So Easy", style: btnTxtStyle),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ]),
    );
  }

  Widget _createUI() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    } else {
      return Column(
        children: [
          Expanded(child: _wordDetailCard),
          _createOpButtons(),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${_book.name}", style: Theme.of(context).textTheme.titleMedium)),
      body: _createUI(),
    );
  }
}
