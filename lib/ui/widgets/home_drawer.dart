import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:my_eng_program/util/sp_util.dart';
import 'package:my_eng_program/util/strings.dart';

class DrawerListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawListState();
}

class _DrawListState extends State<StatefulWidget> {
  final double _avatarRadius = 48;

  bool _themeDark = App.ThemeIsDark;

  @override
  void initState() {
    super.initState();
  }

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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        radius: _avatarRadius,
        child: Text(
          C,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
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
          SizedBox(height: 8),
          _avater,
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "$_name",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.primary),
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
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            radius: _avatarRadius,
            child: Text(
              Strings.STR_YOU,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Material(
              child: InkWell(
                child: Text(
                  Strings.STR_ASK_TO_REGISTER,
                  style:
                      Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
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
        leading: Icon(Icons.book_online_outlined),
        title: Text(
          Strings.LABEL_WORDS_NOTE,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        onTap: () {
          Logger.debug("Drawer", "onClick LABEL_WORDS_NOTE");
        },
      ),
      SizedBox(height: 8),
      ListTile(
        leading: Icon(Icons.favorite),
        title: Text(
          Strings.LABEL_FAV_NOTE,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        onTap: () {
          Logger.debug("Drawer", "onClick LABEL_FAV_NOTE");
        },
      ),
      SizedBox(height: 12),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text(
          Strings.LABEL_SETTING,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        onTap: () {
          Logger.debug("Drawer", "onClick LABEL_SETTING_");
        },
      ),
      SizedBox(height: 32),
      SwitchListTile(
        value: _themeDark,
        onChanged: (value) {
          setState(() {
            _themeDark = value;
            App.ThemeIsDark = value;
            App.themeNotifier.changeTheme();
            SPUtil.getInstance().then((spInstance) => spInstance.setBool(Strings.KEY_THEME_DARK, value));
          });
        },
        title: Text(
          Strings.LABEL_DARK_THEME,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      //   backgroundColor: Color.fromARGB(200, 220, 194, 165),
      shape: BeveledRectangleBorder(),
      child: DrawerListView(),
    );
  }
}
