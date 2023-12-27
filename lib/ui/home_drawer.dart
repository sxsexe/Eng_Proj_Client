import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../data/book.dart';
import '../net/net.dart';

// ignore: must_be_immutable
class DrawerListView extends StatelessWidget {
  late var drawerItems;
  DrawerListView({required this.onItemClick});
  final void Function(Book book) onItemClick;

  @override
  Widget build(BuildContext context) {
    drawerItems = context.watch<List<Book>>();
    return ListView.builder(
      itemCount: drawerItems.length,
      itemBuilder: (context, index) {
        var title = drawerItems[index].title;

        if (index == 0) {
          return const DrawerHeader(
            child: Text("Header"),
            decoration: BoxDecoration(color: Colors.blue),
          );
        } else {
          return ListTile(
            title: Text(
              '$title',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Book book = drawerItems[index];
              this.onItemClick(book);
              Navigator.pop(context);
            },
          );
        }
      },
    );
  }
}

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key, required this.onBookItemClick});

  final void Function(Book book) onBookItemClick;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.orange,
        child: FutureProvider<List<Book>>(
          initialData: [],
          create: (context) => Service.fetchBooks(http.Client()),
          child: DrawerListView(onItemClick: onBookItemClick),
        ));
  }
}
