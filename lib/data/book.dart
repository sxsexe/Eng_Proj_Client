import 'dart:convert';

class Book {
  final String id;
  final String name;
  final String groupID;
  String? avatarUrl;
  String? desc;
  String? subTitle;

  Book({required this.id, required this.name, required this.groupID});

  factory Book.fromJson(Map<String, dynamic> json) {
    Book book = Book(id: json['_id'] as String, name: json['name'] as String, groupID: json['group_id'] as String);
    book.avatarUrl = json['avatar'];
    book.desc = json['desc'];
    book.subTitle = json['sub_title'];

    return book;
  }

  String toJson() {
    return jsonEncode(this);
  }
}
