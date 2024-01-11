import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:my_eng_program/util/strings.dart';

// ignore: must_be_immutable
class DrawerListView extends StatelessWidget {
  Widget _createUserHeader(BuildContext context) {
    String? _name = App.getUser()!.name;
    String _userAvatar = App.getUser()!.avatar ?? "";

    String C = "";
    if (_name != null && _name.isNotEmpty) {
      C = _name[0];
    }

    late Widget _avater;
    if (_userAvatar.isEmpty) {
      _avater = CircleAvatar(
        backgroundColor: Colors.green,
        radius: 32,
        child: Text(
          C,
          style: TextStyle(fontSize: 36, color: Colors.black),
        ),
      );
    } else {
      _avater = Container(
          width: 120,
          height: 120,
          child: ClipRRect(borderRadius: BorderRadius.circular(60), child: CachedNetworkImage(imageUrl: _userAvatar)));
    }

    return DrawerHeader(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          SizedBox(height: 20),
          _avater,
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "$_name",
              style: TextStyle(fontSize: 26),
            ),
          )
        ],
      ),
    );
  }

  Widget _createNonUserHeader(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 32,
            child: Text(
              Strings.STR_YOU,
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Material(
              child: InkWell(
                child: Text(
                  Strings.STR_ASK_TO_REGISTER,
                  style: TextStyle(color: Colors.black87, decoration: TextDecoration.underline, fontSize: 16),
                ),
                onTap: () {
                  //   _gotoRegisterPage();
                  Navigator.pushNamed(context, App.ROUTE_REGISTER);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _items = [
      ListTile(
        leading: Icon(Icons.book),
        title: Text(Strings.LABEL_WORDS_NOTE),
        onTap: () {
          Logger.debug("Drawer", "onClick LABEL_WORDS_NOTE");
        },
      ),
      ListTile(
        leading: Icon(Icons.favorite),
        title: Text(Strings.LABEL_FAV_NOTE),
        onTap: () {
          Logger.debug("Drawer", "onClick LABEL_FAV_NOTE");
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text(Strings.LABEL_SETTING_),
        onTap: () {
          Logger.debug("Drawer", "onClick LABEL_SETTING_");
        },
      ),
      SwitchListTile(
        value: false,
        onChanged: (value) {},
        title: Text(Strings.LABEL_DARK_THEME),
      )
    ];

    return ListView(
      children: [
        if (App.isLoginSuccess()) _createUserHeader(context),
        if (!App.isLoginSuccess()) _createNonUserHeader(context),
        ..._items
      ],
    );
  }
}

class HomeDrawer extends StatelessWidget {
  HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.orange,
      child: DrawerListView(),
    );
  }
}
