import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/book_group.dart';
import 'package:my_eng_program/io/net.dart';
import 'package:my_eng_program/ui/book_group_drawer.dart';
import 'package:my_eng_program/util/logger.dart';

import '../data/book.dart';

class BookGalleryPage extends StatefulWidget {
  const BookGalleryPage({super.key});

  @override
  State<BookGalleryPage> createState() => _BookGalleryState();
}

class _BookGalleryState extends State<BookGalleryPage> {
  BookGroup? _curGroup;
  bool loading = false;
  List<Book> _lstBooks = [];

  static const String TAG = "_BookGalleryState";

  void _onBookGroupItemClick(BookGroup bookGroup) {
    Logger.debug(TAG, bookGroup.toJson().toString());
    setState(() {
      loading = true;
      _curGroup = bookGroup;
    });
    Service.getBooksByGroup(bookGroup.id, App.getUser()!.id).then((lstBooks) => {
          setState(() {
            loading = false;
            _lstBooks = lstBooks;
          })
        });
  }

  Widget _createUIWhenNoGroup() {
    return Center(
      child: Text('No Group Selected'),
    );
  }

  Widget _createLoaingUI() {
    return Center(
      child: Text('Loading'),
    );
  }

  Widget _createBookGallery() {
    return Center(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        children: List.generate(_lstBooks.length, (index) {
          return _createBookItemUI(index);
        }),
      ),
    );
  }

  Widget _createBookItemUI(index) {
    Book _book = _lstBooks[index];
    String avatarUrl = _book.avatarUrl ?? "";
    final double _imageW = 150;
    final double _imageH = 200;

    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.all(18),
      child: InkWell(
        onTap: () {
          Book book = _lstBooks[index];
          Logger.debug(TAG, 'on book click index = $index');
          if (book.DBName != null && book.type == 0) {
            Navigator.pushNamed(context, App.ROUTE_WORDS_DETAIL, arguments: book);
          } else {
          //TODO

          }
        },
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints.tight(Size(_imageW, _imageH)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(color: Color.fromARGB(255, 82, 74, 74), width: 0.5),
                  borderRadius: BorderRadius.circular(1)),
              child: CachedNetworkImage(
                  imageUrl: avatarUrl,
                  fit: BoxFit.fill,
                  // width: _imageW,
                  height: _imageH,
                  placeholderFadeInDuration: Duration(milliseconds: 500),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error)),
            ),
            Expanded(
              child: Text(
                _book.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createUI() {
    if (loading) {
      return _createLoaingUI();
    } else {
      if (_curGroup == null) {
        return _createUIWhenNoGroup();
      } else {
        return _createBookGallery();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Group'),
      ),
      body: Center(child: _createUI()),
      drawer: Drawer(child: BookGroupDrawer(onBookItemClick: this._onBookGroupItemClick)),
    );
  }
}
