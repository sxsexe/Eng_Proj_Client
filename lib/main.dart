import 'package:my_eng_program/app.dart';
import 'package:flutter/material.dart';
import 'package:my_eng_program/io/Api.dart';
import 'package:my_eng_program/ui/book_chapters_page.dart';
import 'package:my_eng_program/util/logger.dart';

import 'ui/book_content_page.dart';
import 'ui/book_gallery_page.dart';
import 'ui/main_page.dart';
import 'ui/register_page.dart';
import 'ui/splash_page.dart';
import 'ui/word_detail_page.dart';
import 'util/sp_util.dart';
import 'util/strings.dart';

void main() {
  Logger.debug("Main", "main");
//   Service.getSentenceToday().then((value) {
//     Logger.debug("getSentenceToday", "value = $value");
//   });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<StatefulWidget> {
  _MyAppState() {
    App.themeNotifier.addListener(() {
      setState(() {
        Logger.debug("main app", "ThemeChanged Notify App.ThemeIsDark = " + App.ThemeIsDark.toString());
        _curThemeMode = App.ThemeIsDark ? ThemeMode.dark : ThemeMode.light;
      });
    });

    // Load theme
    SPUtil.getInstance().then((spInstance) {
      App.ThemeIsDark = spInstance.getBool(Strings.KEY_THEME_DARK) ?? false;
      App.themeNotifier.changeTheme();
    });
  }

  ThemeMode _curThemeMode = ThemeMode.light;
  static final ThemeData _lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Color.fromARGB(255, 238, 229, 222),
          // 主要文本颜色
          primary: Colors.black,
          // 一级Widget的背景色
          primaryContainer: Color.fromARGB(255, 174, 214, 241),
          // 页面和大的Container背景色
          background: Color.fromARGB(255, 243, 224, 181),
          // Subtitle 文本颜色
          secondary: Color.fromARGB(255, 58, 79, 243),
          // 二级Widget的背景色
          secondaryContainer: Color.fromARGB(255, 174, 157, 133),
          // 三级Widget的背景色
          tertiaryContainer: Color.fromARGB(255, 208, 189, 132),
          error: Colors.red),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 116, 192, 230),
            foregroundColor: Colors.orangeAccent,
            shadowColor: Colors.orange,
            surfaceTintColor: Colors.red,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))),
      ),
      indicatorColor: Color.fromARGB(255, 4, 73, 141),
      useMaterial3: true,
      textTheme: _defaultTextTheme,
      brightness: Brightness.light);

  static final ThemeData _darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Color.fromARGB(255, 75, 73, 73),
          // 主要文本颜色
          primary: Color.fromARGB(255, 228, 222, 222),
          // 一级Widget的背景色
          primaryContainer: Color.fromARGB(255, 233, 103, 22),
          // 页面和大的Container背景色
          background: Color.fromARGB(255, 40, 43, 47),
          // Subtitle 文本颜色
          secondary: Color.fromARGB(255, 244, 240, 240),
          // 二级Widget的背景色
          secondaryContainer: Color.fromARGB(255, 222, 190, 5),
          // 三级Widget的背景色
          tertiaryContainer: Colors.blueGrey,
          error: Color.fromARGB(255, 241, 92, 6)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 2, 47, 42),
            foregroundColor: Colors.orangeAccent,
            shadowColor: Colors.orange,
            surfaceTintColor: Colors.red,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4)))),
      ),
      indicatorColor: Color.fromARGB(255, 22, 237, 3),
      useMaterial3: true,
      textTheme: _defaultTextTheme,
      brightness: Brightness.dark);

  static final _defaultTextTheme = TextTheme(
    titleSmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    titleMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
    titleLarge: const TextStyle(fontSize: 64, fontWeight: FontWeight.normal),
    displayLarge: const TextStyle(fontSize: 48, fontWeight: FontWeight.normal),
    displayMedium: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
    displaySmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
    bodySmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    bodyMedium: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
    bodyLarge: const TextStyle(fontSize: 48, fontWeight: FontWeight.normal),
    labelSmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    labelMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
    labelLarge: const TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
  );

  @override
  Widget build(BuildContext context) {
    // Logger.debug("Splash", "_lightTheme.colorScheme.background = " + _lightTheme.colorScheme.background.toString());
    return MaterialApp(
      title: 'EnglishER',
      scrollBehavior: AppScrollBehavior(),
      // theme: ThemeData.dark(useMaterial3: true),
      initialRoute: "/",
      routes: {
        "/": (context) => const Splash(),
        App.ROUTE_SPLASH: (context) => const Splash(),
        App.ROUTE_BOOK_GALLERY_PAGE: (context) => BookGalleryPage(),
        App.ROUTE_CHAPTERS_LIST_PAGE: (context) => BookChaptersPage(),
        App.ROUTE_WORDS_DETAIL: (context) => const WordDetailPage(),
        App.ROUTE_BOOK_CONTENT: (context) => const BookContentPage(),
        App.ROUTE_REGISTER: (context) => const RegisterPage(),
        App.ROUTE_MAIN: (context) => const MainPage(),
      },

      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _curThemeMode,
    );
  }
}
