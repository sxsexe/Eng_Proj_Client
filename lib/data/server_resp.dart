import 'dart:convert';

class Resp {
  late ErrorInfo error;
  Map<String, dynamic>? data;

  Resp({required this.error});

  Resp.fromJson(Map<String, dynamic> json) {
    error = ErrorInfo.fromJson(json['error']);
    data = json['data'];
  }

  String toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['error'] = error.toJson();
    json['data'] = this.data;
    return jsonEncode(json);
  }

  bool isSuccess() {
    return error.errorNo == 0;
  }
}

class ErrorInfo {
  late int errorNo;
  late String errorMsg;

  ErrorInfo({required this.errorNo, required this.errorMsg});

  ErrorInfo.fromJson(Map<String, dynamic> json) {
    errorNo = json['ERR_NO'];
    errorMsg = json['ERR_MSG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorNo'] = errorNo;
    data['errorMsg'] = errorMsg;
    return data;
  }
}
