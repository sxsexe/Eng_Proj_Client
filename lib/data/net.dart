import 'package:http/http.dart' as http;
import 'package:my_eng_program/data/model_category.dart';

class Service {
  static List<Category> s_categories = [];

  static Future<List<Category>> fetchCategories(http.Client client) async {
    if (s_categories.isEmpty) {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/albums/1"));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        // Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
        // return Category.fromJson(map);

        List<Category> categories = [];
        categories.add(Category(id: 1, title: 'A-Z'));
        categories.add(Category(id: 2, title: '小学单词800'));
        categories.add(Category(id: 3, title: '扩展单词1200'));
        categories.add(Category(id: 3, title: '情景对话100篇'));

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
