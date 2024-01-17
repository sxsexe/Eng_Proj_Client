import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/chapter_content.dart';
import 'package:my_eng_program/util/logger.dart';

import '../data/book.dart';

class BookContentPage extends StatefulWidget {
  const BookContentPage({super.key});

  @override
  State<StatefulWidget> createState() => _BookContentState();
}

class _BookContentState extends State<BookContentPage> {
  String _title = "";
  String _bookID = "";
  BookType _bookType = BookType.T_DIALOG;
  List<ChapterContent> _contentList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    setState(() {
      _contentList = args['contents'];
      _title = args['title'];
      _bookID = args['book_id'];
      _bookType = BookType.values[args['book_type']];
    });
  }

  Widget _createTitleUI(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Center(
        child: AutoSizeText(
          title,
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  _createDialogParagraph(String content, int index) {
    FontWeight _weigth;
    FontStyle _fontStyle;
    if (index % 2 == 0) {
      _weigth = FontWeight.bold;
      _fontStyle = FontStyle.normal;
    } else {
      _weigth = FontWeight.w100;
      _fontStyle = FontStyle.italic;
    }
    // Logger.debug("BookContent", "index=$index, _weight=$_weigth");

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          child: Center(
            child: Icon(
              Icons.lens,
              size: 16,
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            content,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: _weigth,
                  fontStyle: _fontStyle,
                ),
          ),
        )
      ],
    );
  }

  Widget _createStoryParagraph(String content, int index) {
    return Expanded(
      child: SelectableText(
        "    " + content,
        style: Theme.of(context)
            .textTheme
            .displaySmall!
            .copyWith(color: Theme.of(context).colorScheme.primary, height: 1.5),
      ),
    );
  }

  Widget _createTextUI(String content, int index) {
    Widget _paragraphUI;
    if (_bookType == BookType.T_DIALOG) {
      _paragraphUI = _createDialogParagraph(content, index);
    } else if (_bookType == BookType.T_STORY) {
      _paragraphUI = _createStoryParagraph(content, index);
    } else {
      _paragraphUI = SizedBox();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Align(
        alignment: Alignment.topLeft,
        child: _paragraphUI,
      ),
    );
  }

  Widget _createImageUI(String imageUrl) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      child: Center(
        child: CachedNetworkImage(imageUrl: imageUrl),
      ),
    );
  }

  Widget _createAudioUI(String imageUrl) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.all(18),
      color: Colors.red,
      child: Center(
        child: Icon(Icons.speaker),
      ),
    );
  }

  List<Widget> _createContentsUI() {
    List<Widget> _widgets = [];

    _widgets.add(_createTitleUI(_title));

    for (var contentObj in _contentList) {
      if (contentObj.type == ContentType.C_TEXT) {
        _widgets.add(_createTextUI(contentObj.content, contentObj.idx));
      }
      if (contentObj.type == ContentType.C_IMAGE) {
        _widgets.add(_createImageUI(contentObj.content));
      }
      if (contentObj.type == ContentType.C_AUDIO) {
        _widgets.insert(1, _createAudioUI(contentObj.content));
      }
    }

    _widgets.add(SizedBox(height: 24));

    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: _createContentsUI(),
          ),
        ),
      ),
    );
  }
}
