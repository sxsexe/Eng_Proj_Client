// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/io/net.dart';
import 'package:my_eng_program/util/logger.dart';

import '../data/book.dart';
import 'widgets/book_gallery_view.dart';

class BookGalleryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookGalleryState();
}

class _BookGalleryState extends State<BookGalleryPage> with TickerProviderStateMixin {
  late String title;
  late String bookGroupId;

  late AnimationController _controller;
  bool _animRunning = true;

  List<Book> listBooks = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      lowerBound: 0.0,
      upperBound: 1,
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Logger.debug("BookGalleryPage", "arguments " + args.toString());
    title = args['title'];
    bookGroupId = args['book_group_id'];

    Service.getBooksByGroup(bookGroupId, App.getUserId()).then((_books) {
      setState(() {
        _controller.stop(canceled: true);
        listBooks = _books;
        _animRunning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return BookGalleryView(listBooks: listBooks, title: title);
    Widget _body;
    if (_animRunning) {
      _body = Center(
        child: CircularProgressIndicator(
          value: _controller.value,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      _body = BookGalleryView(listBooks: listBooks);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium,),
      ),
      body: _body,
    );
  }
}
