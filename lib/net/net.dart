import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/word.dart';

const URL_ROOT = "http://192.168.0.122:8889/";

class Service {
  static List<Book> s_books = [];

  static Future<List<Word>> getRandomWords(count) async {
    final response = await http.get(Uri.parse(URL_ROOT + "get_random_words"));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> sss = jsonDecode(response.body).cast<Map<String, dynamic>>();
      //   Word word = Word.fromJson(jsonDecode(response.body));

      List<Word> wordList = [];
      sss.forEach((element) {
        wordList.add(Word.fromJson(element));
      });
      return wordList;
    } else {
      throw Exception('Failed to getRandomWords');
    }
  }

  static Future<List<Book>> fetchBooks(http.Client client) async {
    if (s_books.isEmpty) {
      final response = await http.get(Uri.parse(URL_ROOT + "books"));

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
