import 'dart:convert';

import 'package:my_eng_program/data/chapter.dart';

class Book {
  final String id;
  final String name;
  // 书分类ID
  final String groupID;
  String? avatarUrl;
  String? desc;
  String? subTitle;

  // 0 : word book, 1 : story book, 2 : dialogue book
  int type = -1;

  String? DBName;
  List<Chapter>? chapterList = [];

  Book({required this.id, required this.name, required this.groupID, required this.type});

  factory Book.fromJson(Map<String, dynamic> json) {
    Book book = Book(
        id: json['_id'] as String,
        name: json['name'] as String,
        groupID: json['group_id'] as String,
        type: json['type'] as int);
    book.avatarUrl = json['avatar'];
    book.desc = json['desc'];
    book.subTitle = json['sub_title'];
    book.type = json['type'];

    book.DBName = json['content_db'];

    var lstData = json['chapters'];
    if (lstData != null) {
      for (var e in lstData) {
        book.chapterList!.add(Chapter.fromJson(e));
      }
    }

    return book;
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "group_id": groupID,
        "type": type,
        "avatar": avatarUrl,
        "desc": desc,
        "sub_title": subTitle,
        "DBName": DBName
      };

  @override
  String toString() {
    return "[Book " + jsonEncode(toJson()) + "]";
  }
}
