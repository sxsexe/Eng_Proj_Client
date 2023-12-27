class Word {
  String? sId;
  String? id;
  String? name;
  String? imageUrl;
  Map<String, dynamic>? genderMaps;
  List<GenderDetail> listGenderDetails = [];

  Word({this.sId, this.id, required this.name, this.genderMaps});

  String? get ID => sId ?? "";

  Word.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
    genderMaps = json['genders'];
    listGenderDetails = [];
    genderMaps?.keys.toList().forEach((key) {
      var detailMap = genderMaps?[key];
      GenderDetail detail = GenderDetail.fromJson(detailMap);
      detail.genderName = key;
      listGenderDetails.add(detail);
    });
  }
}

class GenderDetail {
  List<Define>? defines;
  List<Define>? phrases;
  List<String>? alters;
  String? uKAudio;
  String? uSAudio;
  String? text;
  String? genderName;

  GenderDetail({this.defines, this.phrases, this.alters, this.uKAudio, this.uSAudio, this.text});

  GenderDetail.fromJson(Map<String, dynamic> json) {
    if (json['defines'] != null) {
      defines = <Define>[];
      json['defines'].forEach((v) {
        defines!.add(new Define.fromJson(v));
      });
    }
    if (json['phrases'] != null) {
      phrases = <Define>[];
      json['phrases'].forEach((v) {
        phrases!.add(new Define.fromJson(v));
      });
    }
    if (json['alters'] != null) {
      alters = <String>[];
      json['alters'].forEach((v) {
        alters!.add(v);
      });
    }
    uKAudio = json['UK_audio'];
    uSAudio = json['US_audio'];
    text = json['text'];
  }
}

class Define {
  String? text;
  String? transCh;
  String? transEn;
  List<Example>? examples;

  Define({this.text, this.transCh, this.transEn, this.examples});

  Define.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    transCh = json['trans_ch'];
    transEn = json['trans_en'];
    if (json['examples'] != null) {
      examples = <Example>[];
      json['examples'].forEach((v) {
        examples!.add(new Example.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['trans_ch'] = this.transCh;
    data['trans_en'] = this.transEn;
    if (this.examples != null) {
      data['examples'] = this.examples!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Example {
  String? ch;
  String? en;

  Example({this.ch, this.en});

  Example.fromJson(Map<String, dynamic> json) {
    ch = json['ch'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ch'] = this.ch;
    data['en'] = this.en;
    return data;
  }
}
