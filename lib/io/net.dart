import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/user.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/util/logger.dart';

import '../data/Resp.dart';

const URL_ROOT = "http://127.0.0.1:8889/";

class Service {
  static Future<Resp> login(identifier, crendital) async {
    var url = URL_ROOT + "login";

    Map<String, String> headers = new Map<String, String>();
    headers['Content-Type'] = 'application/json';
    final response = await http.post(Uri.parse(url),
        body: jsonEncode({'identifier': identifier, 'crendital': crendital}), headers: headers);
    Map<String, dynamic> map = jsonDecode(utf8.decode(response.bodyBytes));
    Resp resp = Resp.fromJson(map);
    Logger.debug("NET", resp.toJson());

    return resp;
  }

  static List<Book> s_books = [];
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

  static Future<List<Book>> fetchBooks(http.Client client) async {
    print("NET : fetchBooks Begin");
    if (s_books.isEmpty) {
      final response = await http.get(Uri.parse(URL_ROOT + "books"));
      print("NET : fetchBooks resp.code = ${response.statusCode}");

      if (response.statusCode == 200) {
        List<Book> books = [Book(id: 'ID_Header', title: 'Header')];
        // Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
        // return Category.fromJson(map);
        var list_books = jsonDecode(response.body);
        for (var book_map in list_books) {
          Book book = Book.fromJson(book_map);
          books.add(book);
        }

        s_books.addAll(books);
        return books;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to fetchCategories');
      }
    } else {
      return s_books;
    }
  }
}
