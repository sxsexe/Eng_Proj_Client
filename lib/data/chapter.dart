import 'chapter_content.dart';

class Chapter {
  final String id;
  final String name;
  final int index;
  String? desc;

  List<ChapterContent> contentList = [];

  Chapter({required this.id, required this.name, required this.index});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    Chapter chapter = Chapter(id: json['_id'] as String, name: json['name'] as String, index: json['index']);
    chapter.desc = json['desc'];

    var lstData = json['contents'];
    for (var e in lstData) {
      chapter.contentList.add(ChapterContent.fromJson(e));
    }
    return chapter;
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "index": index, "desc": desc, 'content': contentList};
  }

  @override
  String toString() {
    return "[ChapterContent id = $id, name = $name, index = $index, desc=$desc, content=$contentList]";
  }
}
