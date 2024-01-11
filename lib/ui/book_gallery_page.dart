import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/book_group.dart';
import 'package:my_eng_program/io/net.dart';
import 'package:my_eng_program/ui/widgets/home_drawer.dart';
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
    return GridView(
      padding: EdgeInsets.symmetric(horizontal: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // 主轴间距
        mainAxisSpacing: 12,
        // 次轴间距
        crossAxisSpacing: 12,
        // 子项宽高比率
        childAspectRatio: 3 / 4,
      ),
      children: List.generate(_lstBooks.length, (index) {
        return _createBookItemUI(index);
      }),
    );
  }

  Widget _createBookItemUI(index) {
    Book _book = _lstBooks[index];
    String avatarUrl = _book.cover ?? "";

    return Card(
      color: Colors.grey,
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
            Expanded(
              //   constraints: BoxConstraints.tight(Size(_imageW, _imageH)),
              //   padding: EdgeInsets.all(18),
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //       color: Colors.black12,
              //       border: Border.all(color: Color.fromARGB(255, 82, 74, 74), width: 0.5),
              //       borderRadius: BorderRadius.circular(1)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.fill,
                    placeholderFadeInDuration: Duration(milliseconds: 200),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error)),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _book.name,
                maxLines: 2,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 5,
            ),
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
      body: _createUI(),
      drawer: Drawer(child: HomeDrawer()),
    );
  }
}
