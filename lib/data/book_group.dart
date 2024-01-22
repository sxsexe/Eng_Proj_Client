/**
 * 书的类目
 */
class BookGroup {
  final String id;
  final String name;
  final String cover;

  BookGroup({required this.id, required this.name, required this.cover});

  factory BookGroup.fromJson(Map<String, dynamic> json) {
    BookGroup group =
        BookGroup(id: json['_id'] as String, name: json['name'] as String, cover: json['cover'] as String);
    return group;
  }

  static List<BookGroup> listFromJson(list) => List<BookGroup>.from(list.map((e) => BookGroup.fromJson(e)));

  @override
  String toString() {
    return "[BookGroup id = $id, name = $name, cover = $cover]";
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}
