import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_eng_program/data/model_book.dart';

const URL_ROOT = "http://127.0.0.1:8090/";

class Service {
  static List<Book> s_categories = [];

  static Future<List<Book>> fetchCategories(http.Client client) async {
    if (s_categories.isEmpty) {
      final response = await http.get(Uri.parse(URL_ROOT + "books"));

      if (response.statusCode == 200) {
        List<Book> categories = [Book(id: 'ID_Header', title: 'Header')];
        // Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
        // return Category.fromJson(map);
        var list_books = jsonDecode(response.body);
        for (var book_map in list_books) {
          Book book = Book.fromJson(book_map);
          categories.add(book);
        }

        s_categories.addAll(categories);
        return categories;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to fetchCategories');
      }
    } else {
      return s_categories;
    }
  }
}
