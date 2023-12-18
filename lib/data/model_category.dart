class Category {
  final int id;
  final String title;

  const Category({required this.id, required this.title});

  @override
  String toString() {
    return '[Category : id=$id, title=$title]';
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as int, title: json['title'] as String);
  }
}
