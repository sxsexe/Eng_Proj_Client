import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/util/strings.dart';

class BookGalleryView extends StatefulWidget {
  final List<Book> listBooks;
  final String? title;
  const BookGalleryView({super.key, required this.listBooks, this.title = null});

  String? get appBarTitle => title;

  @override
  State<StatefulWidget> createState() => _BookListState();
}

class _BookListState extends State<BookGalleryView> {
  Widget _createBookItemUI(Book book) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: () {
          if (book.bookType == BookType.T_WORD) {
            Navigator.pushNamed(context, App.ROUTE_WORDS_DETAIL, arguments: book);
          }
          if (book.bookType == BookType.T_STORY) {
            Navigator.pushNamed(context, App.ROUTE_BOOK_CONTENT, arguments: book);
          }
          if (book.bookType == BookType.T_DIALOG) {
            Navigator.pushNamed(context, App.ROUTE_CHAPTERS_LIST_PAGE, arguments: book);
          }
        },
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(height: 8),
            Expanded(
              flex: 3,
              child: Container(
                child: _createBookCover(book.cover),
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          book.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Theme.of(context).colorScheme.primary, height: 1.0, fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _createBookCover(String? imageUrl) {
    if (StringUtil.isStringEmpty(imageUrl)) {
      return Center(
        child: Icon(Icons.coronavirus_rounded),
      );
    } else {
      return CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: BoxFit.fill,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
          errorWidget: (context, url, error) => Icon(Icons.error));
    }
  }

  Widget _createBodyUI() {
    if (widget.listBooks.isEmpty) {
      return Center(
        child: Text("Empty"),
      );
    } else {
      return GridView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // 主轴间距
          mainAxisSpacing: 12,
          // 次轴间距
          crossAxisSpacing: 24,
          // 子项宽高比率
          childAspectRatio: 3 / 4,
        ),
        children: List.generate(widget.listBooks.length, (index) {
          return _createBookItemUI(widget.listBooks[index]);
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appBarTitle != null) {
      return Scaffold(appBar: AppBar(title: Text(widget.appBarTitle!)), body: _createBodyUI());
    } else {
      return Scaffold(body: _createBodyUI());
    }
  }
}
