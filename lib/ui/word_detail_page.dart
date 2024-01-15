import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/util/strings.dart';

import '../data/book.dart';
import '../io/net.dart';
import '../util/logger.dart';
import 'widgets/word_detail_card.dart';

class WordDetailPage extends StatefulWidget {
  const WordDetailPage({super.key});

  @override
  State<StatefulWidget> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  Word? _word;
  late Book _book;
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
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    } else {
      return WordDetailCard(word: _word!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${_book.name}", style: Theme.of(context).textTheme.titleMedium)),
      body: _createUI(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          //   setState(() {
          //     _word = null;
          //   });
          //   var words = Service.getRandomWords(_book.DBName);
          //   words.then((value) => {
          //         setState(() {
          //           _word = value[0];
          //         })
          //       });
          String UA =
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36";
          Map<String, String> headers = {
            "GET": "//media/english-chinese-simplified/uk_pron/u/ukw/ukwee/ukweedk004.mp3 HTTP/1.1",
            "Accept":
                "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,ja;q=0.7",
            "Cache-Control": "max-age=0",
            "Connection": "keep-alive",
            "Host": "dictionary.cambridge.org",
            "If-Modified-Since": "Mon, 15 Jan 2024 08:57:17 GMT",
            "If-None-Match": "0eb8b737eddbeae5fbb8f854958aaf8c1",
            "Sec-Fetch-Dest": "document",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "none",
            "Sec-Fetch-User": "?1",
            "Upgrade-Insecure-Requests": "1",
            "User-Agent": UA,
            "sec-ch-ua": '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "Windows",
          };

          //   String url = "https://helenadailyenglish.com/English Story for Beginner/17. Tell the Truth.mp3";
          String url =
              "https://dictionary.cambridge.org//media/english-chinese-simplified/uk_pron/u/ukw/ukwee/ukweedk004.mp3";

          final player = AudioPlayer();
          final duration = await player.setUrl(url);
          await player.play(); // 播放（不等待结束）
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        tooltip: Strings.BTN_NEXT,
        label: Text(
          Strings.BTN_NEXT,
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 14),
        ),
      ),
    );
  }
}
