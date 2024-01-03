import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/util/logger.dart';

import '../data/book_group.dart';
import '../data/server_resp.dart';

const URL_ROOT = "http://127.0.0.1:8889/";

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

  static Future<Resp> login(identifier, crendital) async {
    var url = URL_ROOT + "login";

    final response = await http.post(Uri.parse(url),
        body: _createBodyParams({'identifier': identifier, 'crendital': crendital}), headers: _createHeader());
    Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
    Resp resp = Resp.fromJson(map);
    Logger.debug("NET", resp.toJson());

    return resp;
  }

//---------------------------------USER END----------------------------------

//---------------------------------BOOKS----------------------------------

  static List<BookGroup> _sGroups = [];
  /**
   * @param userId   根据用户ID获取图书分类
   */
  static Future<List<BookGroup>> getBookGroups(userId) async {
    Logger.debug("NET", "getBookGroups userId = $userId");
    if (_sGroups.isEmpty) {
      final response = await http.post(Uri.parse(URL_ROOT + "book_groups"),
          body: _createBodyParams({'user_id': userId}), headers: _createHeader());

      if (response.statusCode == 200) {
        var maps = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        var errorObj = maps['error'];
        if (_checkRestSuccess(errorObj)) {
          List<BookGroup> bookGroups = [BookGroup(id: 'ID_Header', name: 'Header')];
          var lstData = maps['data']['book_groups'];
          for (var group in lstData) {
            BookGroup bookGroup = BookGroup.fromJson(group);
            bookGroups.add(bookGroup);
          }

          _sGroups.addAll(bookGroups);
          return bookGroups;
        } else {
          Logger.error("NET", "getBookGroups error " + errorObj);
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
    final response = await http.post(Uri.parse(URL_ROOT + "book_infos"),
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
        //FIXME
        lstBooks.add(Book.fromJson({
          '_id': '121321323123',
          'name': 'KET 1200高频词汇',
          'group_id': '6590d54abf8a3ab2facf3749',
          'type': 0,
          'avatar': 'https://img-blog.csdnimg.cn/20210324100419204.png'.trim()
        }));
        lstBooks.add(Book.fromJson({
          '_id': '658d49e6bf8a3ab2facf312',
          'name': 'KET 1200高频词汇',
          'group_id': '6590d54abf8a3ab2facf3749',
          'type': 0,
          'avatar':
              'https://upload-images.jianshu.io/upload_images/574822-14c4f10cd4edb1df.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp'
        }));
        lstBooks.add(Book.fromJson({
          '_id': '235234234234234',
          'name': 'KET 1200高频词汇',
          'group_id': '6590d54abf8a3ab2facf3749',
          'type': 0,
          'avatar':
              'https://upload-images.jianshu.io/upload_images/13564023-350987fa42e50d8d.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp'
        }));
        lstBooks.add(Book.fromJson({
          '_id': 'asd132123szsd123123',
          'name': 'KET 1200高频词汇',
          'group_id': '6590d54abf8a3ab2facf3749',
          'type': 0,
          'avatar':
              'https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/384edd6e7f6d40ae91cd551ea9e19982~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp'
        }));

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

//---------------------------------BOOKS END----------------------------------

  static Future<List<Word>> getRandomWords(wordDbName, [count = 1]) async {
    var url = URL_ROOT + "random_words?";
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
