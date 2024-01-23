import 'chapter_content.dart';

class Chapter {
  final String name;
  List<ChapterContent> contentList = [];

  Chapter({required this.name});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    Chapter chapter = Chapter(name: json['name'] as String);
    chapter.contentList = ChapterContent.listFromJson(json['contents']);
    return chapter;
  }

  Map<String, dynamic> toJson() {
    return {"name": name, 'contents': contentList};
  }

  @override
  String toString() {
    return "[ChapterContent name = $name, content=$contentList]";
  }
}
