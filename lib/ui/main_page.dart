import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/io/net.dart';
import 'package:my_eng_program/ui/widgets/book_list.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:my_eng_program/util/strings.dart';

import '../data/book_group.dart';
import 'widgets/home_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const String TAG = "MainPageState";

  int _curIndex = 0;
  List<_PageSub> _pageList = [
    const _PageSub(type: PAGE_TYPE_ING),
    const _PageSub(type: PAGE_TYPE_ALL),
    const _PageSub(type: PAGE_TYPE_DONE),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _pageList[_curIndex].getTitle(),
            style: TextStyle(fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
          ),
        ),
        drawer: Drawer(child: HomeDrawer()),
        body: PageView(
          children: [..._pageList],
          onPageChanged: (index) {
            Logger.debug(TAG, "onPageChanged $index");
            setState(() {
              _curIndex = index;
            });
          },
        ),
      ),
    );
  }
}

const int PAGE_TYPE_ING = 1;
const int PAGE_TYPE_ALL = 3;
const int PAGE_TYPE_DONE = 2;

class _PageSub extends StatefulWidget {
  final int type;

  const _PageSub({Key? key, required this.type}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PageSubState();

  String getTitle() {
    if (type == PAGE_TYPE_ING) return Strings.LABEL_PAGE_TITLE_LEARNING;
    if (type == PAGE_TYPE_ALL) return Strings.LABEL_PAGE_TITLE_ALL;
    if (type == PAGE_TYPE_DONE) return Strings.LABEL_PAGE_TITLE_DONE;
    return "";
  }
}

class _PageSubState extends State<_PageSub> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _controller;
  bool _animRunning = true;

  List<Book> _lstBooks = [];
  List<BookGroup> _lstBookGroups = [];

  _PageSubState();

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

    String? userId = App.getUserId();
    if (widget.type == PAGE_TYPE_ING || widget.type == PAGE_TYPE_DONE) {
      if (userId != null) {
        bool isDone = widget.type == PAGE_TYPE_DONE;
        Service.getUserBooks(userId, isDone).then((books) {
          Logger.debug("_PageSubState", books.toString());
          setState(() {
            _controller.stop(canceled: true);
            _animRunning = false;
            _lstBooks = books;
          });
        });
      } else {
        //TODO load from DB
        Future.delayed(Duration(seconds: 2)).then((value) {
          setState(() {
            _controller.stop(canceled: true);
            _animRunning = false;
            _lstBooks = [];
          });
        });
      }
    }

    if (widget.type == PAGE_TYPE_ALL) {
      if (userId == null) userId = "";
      Service.getBookGroups(userId).then((bookGroups) {
        Logger.debug("_PageSubState", bookGroups.toString());
        setState(() {
          _controller.stop(canceled: true);
          _animRunning = false;
          _lstBookGroups = bookGroups;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _createBodyUI() {
    if (_animRunning) {
      return Center(
        child: CircularProgressIndicator(
          value: _controller.value,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      if (widget.type == PAGE_TYPE_ALL) {
        if (_lstBookGroups.isEmpty) {
          return Center(
            child: Text("Empty"),
          );
        } else {
          return GridView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // 主轴间距
              mainAxisSpacing: 24,
              // 次轴间距
              crossAxisSpacing: 24,
              // 子项宽高比率
              childAspectRatio: 3 / 4,
            ),
            children: List.generate(_lstBookGroups.length, (index) {
              return _createBookGroupItemUI(_lstBookGroups[index]);
            }),
          );
        }
      } else {
        return BookListView(listBooks: _lstBooks);
      }
    }
  }

  Widget _createBookGroupItemUI(BookGroup bookGroup) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: Flex(
          direction: Axis.vertical,
          children: [
            SizedBox(height: 10),
            Expanded(
              flex: 3,
              child: Container(
                child: CachedNetworkImage(
                    imageUrl: bookGroup.cover,
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
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          bookGroup.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                height: 1.0,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Logger.debug("_PageSub", "build type = ${widget.type}");
    return Center(
      child: _createBodyUI(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
