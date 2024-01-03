/**
 * 书的类目
 */
class BookGroup {
  final String id;
  final String name;

  BookGroup({required this.id, required this.name});

  factory BookGroup.fromJson(Map<String, dynamic> json) {
    BookGroup group = BookGroup(id: json['_id'] as String, name: json['name'] as String);
    return group;
  }

  @override
  String toString() {
    return "[BookGroup id = $id, name = $name]";
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };
}
