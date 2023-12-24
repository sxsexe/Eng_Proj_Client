class Book {
  final String id;
  final String title;

  const Book({required this.id, required this.title});

  @override
  String toString() {
    return '[Book : id=$id, title=$title]';
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(id: json['_id'] as String, title: json['name'] as String);
  }
}
