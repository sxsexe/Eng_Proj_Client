import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/chapter_content.dart';
import 'package:my_eng_program/io/Api.dart';
import 'package:my_eng_program/util/cache_manager.dart';
import 'package:my_eng_program/util/event_bus.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:my_eng_program/util/strings.dart';

import '../data/book.dart';

class BookContentPage extends StatefulWidget {
  const BookContentPage({super.key});

  @override
  State<StatefulWidget> createState() => _BookContentState();
}

class _BookContentState extends State<BookContentPage> {
  late Book _book;
  static const String TAG = "BookContent";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _book = ModalRoute.of(context)!.settings.arguments as Book;
    Logger.debug(TAG, "argument book=$_book");
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
    return SelectableText(
      "    " + content,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            height: 1.5,
          ),
    );
  }

  Widget _createTextUI(String content, int index) {
    Widget _paragraphUI;
    if (_book.bookType == BookType.T_DIALOG) {
      _paragraphUI = _createDialogParagraph(content, index);
    } else if (_book.bookType == BookType.T_STORY) {
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
    Logger.error(TAG, "_createImage url=" + imageUrl);
    if (StringUtil.isStringEmpty(imageUrl)) {
      return SizedBox();
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(18),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            errorListener: (error) {
              Logger.error(TAG, "_createImage error=$error");
            },
          ),
        ),
      );
    }
  }

//FIXME
  Future<void> play(String audioUrl) async {
    final player = AudioPlayer();
    // player.setSourceUrl(audioUrl);
    await player.setUrl(audioUrl);
    await player.play();
  }

  Widget _createAudioUI(String audioUrl) {
    return InkWell(
      onTap: () {
        Logger.debug(TAG, "Audio Play " + audioUrl);
        play(audioUrl).then((value) => Logger.debug("BookContent", "play callback"));
      },
      child: Container(
        width: double.infinity,
        height: 50,
        padding: EdgeInsets.all(18),
        color: Colors.red,
        child: Center(
          child: Icon(Icons.speaker),
        ),
      ),
    );
  }

  List<Widget> _createContentsUI() {
    List<Widget> _widgets = [];

    _widgets.add(_createTitleUI(_book.name));
    var _contentList = _book.contentList;
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

    if (_book.learnState == BooKLearnState.T_ING) {
      _widgets.add(Container(
          width: 180,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _updateBookState(BooKLearnState.T_ING, BooKLearnState.T_DONE),
            child: Text(
              "完成学习",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          )));
      _widgets.add(SizedBox(height: 24));
    }

    return _widgets;
  }

  List<Widget> _createActions() {
    List<Widget> _widgets = [];

    if (_book.learnState == BooKLearnState.T_DONE) {
      _widgets.add(new TextButton(
        child: Text(
          "重新学习",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        onPressed: () => this._updateBookState(BooKLearnState.T_DONE, BooKLearnState.T_ING),
      ));
    } else if (_book.learnState == BooKLearnState.T_NOT_START) {
      _widgets.add(new TextButton(
        child: Text(
          "加入学习",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        onPressed: () => this._updateBookState(BooKLearnState.T_NOT_START, BooKLearnState.T_ING),
      ));
    }
    return _widgets;
  }

  _updateBookState(BooKLearnState oldState, BooKLearnState newState) {
    var now = DateUtil.formatDate(DateTime.now(), format: DateFormats.full);
    Api.updateUserBookStatus(App.getUserId()!, _book.id, newState.index, _book.bookType.index, now, now).then((rs) {
      Logger.debug(TAG, "_updateBookState rs=$rs, oldState=$oldState");
      if (rs) {
        _book.learnState = newState;
        if (oldState == BooKLearnState.T_NOT_START) {
          Logger.debug(TAG, "addNewUserBook rs=$rs");
          RamCacheManager.getInstance().addNewUserBook(_book);
        } else {
          Logger.debug(TAG, "updateBookLearnState rs=$rs");
          RamCacheManager.getInstance().updateBookLearnState(_book.id, newState);
        }
        eventBus.fire(BookStateEvent(_book.id));

        //TODO refresh actions and buttons
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: _createActions(),
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
