class User {
  late String id;
  String? name;
  String? avatar;
  //1 登录用户 2 VIP用户
  late int type;
  late String createTime;
  String? updateTime;
  List<Auths> auths = [];

  User(
      {required this.id,
      this.name,
      this.avatar,
      required this.type,
      required this.createTime,
      this.updateTime,
      required this.auths});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    avatar = json['avatar'];
    type = json['type'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    json['auths'].forEach((v) {
      auths.add(new Auths.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['type'] = this.type;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    data['auths'] = this.auths.map((v) => v.toJson()).toList();
    return data;
  }
}

// class Id {
//   String oid;

//   Id({this.oid});

//   Id.fromJson(Map<String, dynamic> json) {
//     oid = json['$oid'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$oid'] = this.oid;
//     return data;
//   }
// }

class Auths {
  late String identityType;
  late String credential;
  late String identifier;

  Auths({required this.identityType, required this.credential, required this.identifier});

  Auths.fromJson(Map<String, dynamic> json) {
    identityType = json['identity_type'];
    credential = json['credential'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identity_type'] = this.identityType;
    data['credential'] = this.credential;
    data['identifier'] = this.identifier;
    return data;
  }
}
