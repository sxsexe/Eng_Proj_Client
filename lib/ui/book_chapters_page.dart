import 'package:flutter/material.dart';
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/chapter.dart';
import 'package:my_eng_program/util/logger.dart';

import '../app.dart';

class BookChaptersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookChaptersPageState();
}

class _BookChaptersPageState extends State<BookChaptersPage> {
  List<Chapter> _lstChapters = [];
  late String _title;
  late Book _book;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // Map<String, dynamic> args = jsonDecode() as Map<String, dynamic>;
    _book = Book(id: args['_id'], name: args['name'], groupID: args['group_id'], type: args['type']);
    _book.chapterList = args['chapters'];

    setState(() {
      _lstChapters = _book.chapterList;
      _title = _book.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary)),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Chapter chapter = _lstChapters[index];
          return _createChatperItem(chapter, index);
        },
        itemCount: _lstChapters.length,
      ),
    );
  }

  Widget _createChatperItem(Chapter chapter, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 18, horizontal: 30),
      padding: EdgeInsets.all(16),
      color: Color.fromARGB(255, 208, 189, 132),
      child: InkWell(
        onTap: () {
          Logger.debug("ChaptersPage", "index=$index");
          var args = {
            "book_id" : _book.id,
            "book_type" : _book.type,
            "title" : chapter.name,
            "contents" : chapter.contentList
          };
          Navigator.pushNamed(context, App.ROUTE_BOOK_CONTENT, arguments: args);
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${index + 1}    ",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
              ),
              Expanded(
                  child: Text(
                chapter.name,
                maxLines: 3,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.secondary,
                    ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
