
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'English is not hard to study!', home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      // Column is a vertical linear layout
      child: Column(
        children: [MyAppBar(title: Text('Follow me')), Expanded(child: Center(child: Text('Hello')))],
      ),
    );
  }
}


class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.blue[500]),
      //Row is a horizontal linear layout
      child: Row(
        children: [const IconButton(onPressed: null, icon: Icon(Icons.menu)), Expanded(child: title)],
      ),
    );
  }
}

