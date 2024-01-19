import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/book_group.dart';
import 'package:my_eng_program/data/server_resp.dart';
import 'package:my_eng_program/data/user.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/io/Http.dart';

class Api {
  static const PATH_LOGIN = "login";
  static const PATH_SENTENCE_TODAY = "get_sentence_a_day";

  static Future<Resp> register(identifier, credential, type) async {
    return Http().post("register", data: {'identifier': identifier, 'credential': credential, 'identity_type': type});
    // int rs = data['rs'] as int;
    // return rs == 1;
  }

  static Future<Resp> login(identifier, credential) async {
    return Http().post("login", data: {'identifier': identifier, 'credential': credential});
  }

  static Future<Resp> getSentenceToday() async {
    // var data = await Http().get("get_sentence_a_day");
    return Http().get("get_sentence_a_day");
  }

  static Future<Resp> getBookGroups(userId) async {
    // var data = await Http().post("book_groups", data: {'user_id': userId});
    // var lstData = data['book_groups'];
    // List<BookGroup> bookGroups = [];
    // for (var group in lstData) {
    //   BookGroup bookGroup = BookGroup.fromJson(group);
    //   bookGroups.add(bookGroup);
    // }
    return Http().post("book_groups", data: {'user_id': userId});
  }

  static Future<Resp> getBooksByGroup(groupId, userId) async {
    // var data = await Http().post("book_infos", data: {'user_id': userId});
    // var lstData = data['book_infos'];
    // List<Book> lstBooks = [];
    // for (var item in lstData) {
    //   Book book = Book.fromJson(item);
    //   lstBooks.add(book);
    // }
    return Http().post("book_infos", data: {'user_id': userId});
  }

  static Future<Resp> getUserBooks(String userId, bool isDone) async {
    // var data = await Http().post("get_user_books", data: {'user_id': userId, "is_done": isDone ? 1 : 0});
    // var lstData = data['user_books'];
    // List<Book> lstBooks = [];
    // for (var item in lstData) {
    //   Book book = Book.fromJson(item);
    //   lstBooks.add(book);
    // }
    return Http().post("get_user_books", data: {'user_id': userId, "is_done": isDone ? 1 : 0});
  }

  static Future<Resp> getRandomWords(wordDbName, [count = 1]) async {
    // var data = await Http().post("random_words", data: {'word_db_nm': wordDbName, "count": count});
    // var lstData = data['words'];
    // List<Word> lstWords = [];
    // for (var item in lstData) {
    //   Word word = Word.fromJson(item);
    //   // word.name = "businesswoman";
    //   lstWords.add(word);
    // }
    return Http().post("random_words", data: {'word_db_nm': wordDbName, "count": count});
  }

/**
 * 获取生词数
 */
  static Future<Resp> getUnknownWordsCount(userId, [maxScore = 80]) async {
    // var data = await Http().post("count_user_word", data: {'user_id': userId, "max_score": maxScore});
    // int count = data['words'];
    return Http().post("count_user_word", data: {'user_id': userId, "max_score": maxScore});
  }

  /**
     * 增加生词
     * @param(score) 10 : 完全忘记   50 ：模模糊糊    80 ： So Easy
     */
  static Future<Resp> upsertUserWord(userId, wordId, wordName, score, wordDBName) async {
    return Http().post("upsert_user_word", data: {
      'user_id': userId,
      "word_id": wordId,
      "score": score,
      "word_name": wordName,
      "word_db": wordDBName,
    });

    // return true;
  }
}
