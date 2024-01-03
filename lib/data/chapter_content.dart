enum ContentType { C_TEXT, C_AUDIO, C_VIDEO, C_IMAGE }

class ChapterContent {
  ContentType type = ContentType.C_TEXT;

  String content;

  ChapterContent({required this.type, required this.content});

  factory ChapterContent.fromJson(Map<String, dynamic> json) {
    ContentType cType = ContentType.values[json['type'] as int];
    return ChapterContent(type: cType, content: json['content']);
  }

  @override
  String toString() {
    return "[ChapterContent type = $type, content = $content]";
  }
}
