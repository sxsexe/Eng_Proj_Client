enum ContentType { C_TEXT, C_AUDIO, C_VIDEO, C_IMAGE }

class ChapterContent {
  ContentType type = ContentType.C_TEXT;

  String content;
  int idx = -1;

  ChapterContent({required this.type, required this.content});

  factory ChapterContent.fromJson(Map<String, dynamic> json) {
    ContentType cType = ContentType.values[json['type'] as int];
    ChapterContent obj = ChapterContent(type: cType, content: json['content']);
    if (json.containsKey('idx')) obj.idx = json['idx'];
    return obj;
  }

  @override
  String toString() {
    return "[ChapterContent idx=$idx,  type = $type, content = $content]";
  }
}
