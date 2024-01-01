import 'dart:convert';

class BookGroup {
  final String id;
  final String name;

  BookGroup({required this.id, required this.name});

  factory BookGroup.fromJson(Map<String, dynamic> json) {
    BookGroup group = BookGroup(id: json['_id'] as String, name: json['name'] as String);
    return group;
  }

  String toJson() {
    return jsonEncode(this);
  }
}
