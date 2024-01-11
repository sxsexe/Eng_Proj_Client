import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/util/logger.dart';

import '../data/book_group.dart';
import '../data/server_resp.dart';

// const URL_ROOT = "http://192.168.0.124:8889/";
// const URL_ROOT = "http://127.0.0.1:8889/";

String _getUrlRoot() {
  if (Platform.isWindows) {
    return "http://127.0.0.1:8889/";
  } else {
    return "http://192.168.0.124:8889/";
  }
}

Map<String, String> _createHeader() {
  Map<String, String> headers = new Map<String, String>();
  headers['Content-Type'] = 'application/json';
  return headers;
}

String _createBodyParams(obj) {
  return jsonEncode(obj);
}

bool _checkRestSuccess(errorObj) {
  return errorObj != null && errorObj['ERR_NO'] == 0;
}

class Service {
//---------------------------------USER----------------------------------

  static Future<Resp> login(identifier, credential) async {
    var url = _getUrlRoot() + "login";

    final response = await http.post(Uri.parse(url),
        body: _createBodyParams({'identifier': identifier, 'credential': credential}), headers: _createHeader());
    Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
    Resp resp = Resp.fromJson(map);
    Logger.debug("NET login", resp.toJson());

    return resp;
  }

  static Future<Resp> register(identifier, credential, type) async {
    var url = _getUrlRoot() + "register";

    final response = await http.post(Uri.parse(url),
        body: _createBodyParams({'identifier': identifier, 'credential': credential, 'identity_type': type}),
        headers: _createHeader());
    Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
    Resp resp = Resp.fromJson(map);
    Logger.debug("NET register", resp.toJson());

    return resp;
  }

//---------------------------------USER END----------------------------------

//---------------------------------BOOKS----------------------------------

  /**
   * @param userId   根据用户ID获取图书分类  TODO  现在是返回所有
   */
  static List<BookGroup> _sGroups = [];
  static Future<List<BookGroup>> getBookGroups(userId) async {
    Logger.debug("NET", "getBookGroups userId = $userId");
    if (_sGroups.isEmpty) {
      final response = await http.post(Uri.parse(_getUrlRoot() + "book_groups"),
          body: _createBodyParams({'user_id': userId}), headers: _createHeader());

      if (response.statusCode == 200) {
        var maps = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        var errorObj = maps['error'];
        if (_checkRestSuccess(errorObj)) {
          List<BookGroup> bookGroups = [];
          var lstData = maps['data']['book_groups'];
          for (var group in lstData) {
            BookGroup bookGroup = BookGroup.fromJson(group);
            bookGroups.add(bookGroup);
          }

          _sGroups.addAll(bookGroups);
          return bookGroups;
        } else {
          Logger.error("NET getBookGroups", "getBookGroups error " + errorObj);
          throw Exception('Failed to getBookGroups');
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw HttpException('Failed to getBookGroups');
      }
    } else {
      return _sGroups;
    }
  }

  static Future<List<Book>> getBooksByGroup(groupId, userId) async {
    final response = await http.post(Uri.parse(_getUrlRoot() + "book_infos"),
        body: _createBodyParams({'user_id': userId, "group_id": groupId}), headers: _createHeader());

    if (response.statusCode == 200) {
      var maps = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      var errorObj = maps['error'];
      if (_checkRestSuccess(errorObj)) {
        List<Book> lstBooks = [];
        var lstData = maps['data']['book_infos'];
        for (var item in lstData) {
          Book book = Book.fromJson(item);
          lstBooks.add(book);
        }
        return lstBooks;
      } else {
        Logger.error("NET", "getBooksByGroup error " + errorObj);
        throw Exception('Failed to getBooksByGroup');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw HttpException('Failed to getBooksByGroup');
    }
  }

/**
 * 根据 userId和type获取书
 * type 1 : 正在学习   2 ：学完的
 */
  static Future<List<Book>> getUserBooks(String userId, bool isDone) async {
    var url = _getUrlRoot() + "get_user_books";
    final response = await http.post(Uri.parse(url),
        body: _createBodyParams({'user_id': userId, "is_done": isDone ? 1 : 0}), headers: _createHeader());

    if (response.statusCode == 200) {
      var maps = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      var errorObj = maps['error'];
      if (_checkRestSuccess(errorObj)) {
        List<Book> lstBooks = [];
        var lstData = maps['data']['user_books'];
        lstData.forEach((element) {
          Book book = Book.fromJson(element);
          // word.name = "businesswoman";
          lstBooks.add(book);
        });
        return lstBooks;
      } else {
        Logger.error("NET", "getRandomWords error " + errorObj);
        throw Exception('Failed to getBookGroups');
      }
    } else {
      throw Exception('Failed to getRandomWords');
    }
  }

//---------------------------------BOOKS END----------------------------------

  static Future<List<Word>> getRandomWords(wordDbName, [count = 1]) async {
    var url = _getUrlRoot() + "random_words?";
    final response = await http.post(Uri.parse(url),
        body: _createBodyParams({'word_db_nm': wordDbName, "count": count}), headers: _createHeader());

    if (response.statusCode == 200) {
      var maps = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      var errorObj = maps['error'];
      if (_checkRestSuccess(errorObj)) {
        var s = maps['data']['words'];
        List<Word> wordList = [];
        s.forEach((element) {
          Word word = Word.fromJson(element);
          // word.name = "businesswoman";
          wordList.add(word);
        });
        return wordList;
      } else {
        Logger.error("NET", "getRandomWords error " + errorObj);
        throw Exception('Failed to getBookGroups');
      }
    } else {
      throw Exception('Failed to getRandomWords');
    }
  }
}
