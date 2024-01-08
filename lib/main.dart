import 'package:flutter/material.dart';
import 'package:my_eng_program/app.dart';
import 'package:my_eng_program/ui/book_gallery_page.dart';
import 'package:my_eng_program/ui/register_page.dart';
import 'package:my_eng_program/ui/splash_page.dart';

import 'ui/word_detail_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final theme = ThemeData(
      useMaterial3: true,
      dividerColor: Color.fromARGB(128, 247, 187, 13),
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Color.fromARGB(255, 176, 187, 23),
          primary: Color.fromARGB(246, 246, 234, 221),
          onPrimary: Colors.black,
          primaryContainer: Colors.blue,
          secondary: Color.fromARGB(255, 225, 241, 240),
          onSecondary: Colors.black87,
          secondaryContainer: Colors.blueGrey),
      textTheme: TextTheme(
          titleSmall: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          titleMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          titleLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
          displayLarge: const TextStyle(fontSize: 48, fontWeight: FontWeight.normal),
          displayMedium: const TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
          displaySmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal)));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EnglishER',
      theme: theme,
      initialRoute: App.ROUTE_SPLASH,
      routes: {
        App.ROUTE_SPLASH: (context) => const Splash(),
        App.ROUTE_BOOK_GROUP: (context) => const BookGalleryPage(),
        App.ROUTE_WORDS_DETAIL: (context) => const WordDetailPage(),
        App.ROUTE_REGISTER: (context) => const RegisterPage(),
      },
    );
  }
}
