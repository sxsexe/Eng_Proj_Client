import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/data/book.dart';

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
    return Flex(
      direction: Axis.vertical,
      children: [
        SizedBox(height: 8),
        Expanded(
          flex: 3,
          child: Container(
            child: CachedNetworkImage(
                imageUrl: book.cover ?? "",
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                errorWidget: (context, url, error) => Icon(Icons.error)),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      book.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            height: 1.0,
                          ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ))
      ],
    );
  }

  Widget _createBodyUI() {
    if (widget.listBooks.isEmpty) {
      return Center(
        child: Text("Empty"),
      );
    } else {
      return GridView(
        padding: EdgeInsets.symmetric(horizontal: 36),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          // 主轴间距
          mainAxisSpacing: 24,
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
