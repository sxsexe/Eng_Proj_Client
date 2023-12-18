import 'package:flutter/material.dart';

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
