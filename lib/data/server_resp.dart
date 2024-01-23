import 'dart:convert';

class Resp {
  late ErrorInfo error;
  late Map<String, dynamic> data;

  Resp({required this.error});

  Resp.fromJson(Map<String, dynamic> json) {
    error = ErrorInfo.fromJson(json['error']);
    if (json.containsKey("data") && json['data'] != null) {
      data = json['data'];
    } else {
      data = new Map<String, dynamic>();
    }
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

class ErrorInfo implements Exception {
  late int errorNo;
  late String errorMsg;

  static ErrorInfo PARSE_ERROR() => ErrorInfo(errorNo: 2001, errorMsg: "Parse Error");
  static ErrorInfo HTTP_ERROR() => ErrorInfo(errorNo: 2002, errorMsg: "Http Error");
  static ErrorInfo CUSTOME_ERROR(no, msg) => ErrorInfo(errorNo: no, errorMsg: msg);

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

  @override
  String toString() {
    return "[errorNo=$errorNo, errorMsg=$errorMsg]";
  }
}
