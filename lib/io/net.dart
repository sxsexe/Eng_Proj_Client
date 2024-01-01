import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/user.dart';
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

  static List<BookGroup> sGroups = [];
  static Future<List<BookGroup>> getBookGroups(userId) async {
    if (sGroups.isEmpty) {
      final response = await http.post(Uri.parse(URL_ROOT + "book_groups"),
          body: _createBodyParams({'user_id': userId}), headers: _createHeader());

      if (response.statusCode == 200) {
        List<BookGroup> bookGroups = [BookGroup(id: 'ID_Header', name: 'Header')];
        var maps = jsonDecode(response.body);
        for (var group in maps) {
          BookGroup bookGroup = BookGroup.fromJson(group);
          bookGroups.add(bookGroup);
        }

        sGroups.addAll(bookGroups);
        return bookGroups;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to getBookGroups');
      }
    } else {
      return sGroups;
    }
  }

  static Future<List<BookGroup>> getBooksByGroup(groupId, userId) async {
    if (sGroups.isEmpty) {
      final response = await http.post(Uri.parse(URL_ROOT + "book_groups"));

      if (response.statusCode == 200) {
        List<BookGroup> bookGroups = [BookGroup(id: 'ID_Header', name: 'Header')];
        var maps = jsonDecode(response.body);
        for (var group in maps) {
          BookGroup bookGroup = BookGroup.fromJson(group);
          bookGroups.add(bookGroup);
        }

        sGroups.addAll(bookGroups);
        return bookGroups;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to getBookGroups');
      }
    } else {
      return sGroups;
    }
  }

//---------------------------------BOOKS END----------------------------------

  static Future<List<Word>> getRandomWords(bookName, [count = 1]) async {
    var url = URL_ROOT + "get_random_words?book_id=" + bookName + "&count=$count";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> sss = jsonDecode(utf8.decode(response.bodyBytes)).cast<Map<String, dynamic>>();
      List<Word> wordList = [];
      sss.forEach((element) {
        Word word = Word.fromJson(element);
        // word.name = "businesswoman";
        wordList.add(word);
      });
      return wordList;
    } else {
      throw Exception('Failed to getRandomWords');
    }
  }
}
