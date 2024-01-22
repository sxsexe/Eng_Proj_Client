import 'dart:convert';

import 'package:my_eng_program/data/chapter.dart';
import 'package:my_eng_program/data/chapter_content.dart';

enum BookType { T_WORD, T_STORY, T_DIALOG }

enum BooKLearnState { T_NOT_START, T_ING, T_DONE }

class Book {
  final String id;
  final String name;
  // 书分类ID
  final String groupID;
  String? cover;
  String? desc;
  String? subTitle;

  // 0 : word book, 1 : story book, 2 : dialogue book
  int type = -1;
  late BookType bookType;

  String? DBName;
  List<Chapter> chapterList = [];
  List<ChapterContent> contentList = [];

  BooKLearnState learnState = BooKLearnState.T_NOT_START;

  Book({required this.id, required this.name, required this.groupID, required this.type});

  static List<Book> listFromJson(list) => List<Book>.from(list.map((e) => Book.fromJson(e)));

  factory Book.fromJson(Map<String, dynamic> json) {
    Book book = Book(
        id: json['_id'] as String,
        name: json['name'] as String,
        groupID: json['group_id'] as String,
        type: json['type'] as int);

    book.cover = json['cover'];
    book.desc = json['desc'];
    book.subTitle = json['sub_title'];
    book.bookType = BookType.values[book.type];

    if (json.containsKey('word_db_name')) {
      book.DBName = json['word_db_name'];
    }

    if (json.containsKey('learn_state')) {
      book.learnState = BooKLearnState.values[json['learn_state']];
    }

    var lstData = json['chapters'];
    if (lstData != null) {
      for (var e in lstData) {
        book.chapterList.add(Chapter.fromJson(e));
      }
    }

    lstData = json['contents'];
    if (lstData != null) {
      for (var e in lstData) {
        book.contentList.add(ChapterContent.fromJson(e));
      }
    }

    return book;
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "group_id": groupID,
        "type": type,
        "cover": cover,
        "desc": desc,
        "sub_title": subTitle,
        "word_db_name": DBName,
        "chapters": chapterList
      };

  @override
  String toString() {
    return "[Book " + jsonEncode(toJson()) + "]";
  }
}
