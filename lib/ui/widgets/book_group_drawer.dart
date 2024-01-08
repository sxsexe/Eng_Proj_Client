import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:provider/provider.dart';

import '../../data/book_group.dart';
import '../../io/net.dart';

// ignore: must_be_immutable
class DrawerListView extends StatelessWidget {
  late List<BookGroup> bookGroupItems;
  DrawerListView({required this.onItemClick});
  final void Function(BookGroup bookGroup) onItemClick;

  Widget _createUserHeader() {
    String _userName = App.getUser()!.name ?? "";
    String _userCover = App.getUser()!.avatar ?? "";

    return UserAccountsDrawerHeader(
        accountName: new Text(_userName),
        decoration: BoxDecoration(color: Colors.black45),
        currentAccountPicture: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(imageUrl: _userCover),
        ),
        accountEmail: new Text(_userName));
  }

  Widget _createNonUserHeader() {
    return const DrawerHeader(
      child: Text("Learn English Everyday, Everywhere"),
      decoration: BoxDecoration(color: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    bookGroupItems = context.watch<List<BookGroup>>();
    return ListView.builder(
      itemCount: bookGroupItems.length,
      itemBuilder: (context, index) {
        var title = bookGroupItems[index].name;

        if (index == 0) {
          if (App.isLoginSuccess()) {
            return _createUserHeader();
          } else {
            return _createNonUserHeader();
          }
        } else {
          return ListTile(
            title: Text(
              '$title',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Logger.debug("Drawer", "on click drawer index $index");
              BookGroup group = bookGroupItems[index];
              this.onItemClick(group);
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }
}

class BookGroupDrawer extends StatelessWidget {
  BookGroupDrawer({super.key, required this.onBookItemClick});

  final void Function(BookGroup bookGroup) onBookItemClick;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.orange,
        child: FutureProvider<List<BookGroup>>(
          initialData: [],
          lazy: false,
          create: (context) => Service.getBookGroups(App.getUser()!.id),
          child: DrawerListView(onItemClick: onBookItemClick),
        ));
  }
}
