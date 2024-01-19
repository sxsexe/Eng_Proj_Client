import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/book_group.dart';
import 'package:my_eng_program/data/server_resp.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/io/Http.dart';

class Api {
  static const PATH_LOGIN = "login";
  static const PATH_SENTENCE_TODAY = "get_sentence_a_day";

  static Future<Resp> register(identifier, credential, type) async {
    var resp = await Http().post("register", data: {
      'identifier': identifier,
      'credential': credential,
      'identity_type': type,
    });
    return resp;
  }

  static Future<Resp> login(identifier, credential) async {
    return Http().post("login", data: {'identifier': identifier, 'credential': credential});
  }

  static Future<String?> getSentenceToday() async {
    var resp = await Http().get("get_sentence_a_day");
    if (resp.isSuccess()) {
      return resp.data['rs']['en'];
    }
    return null;
  }

  static Future<List<BookGroup>> getBookGroups(userId) async {
    var resp = await Http().post("book_groups", data: {'user_id': userId});
    var lstData = resp.data['book_groups'];
    List<BookGroup> bookGroups = [];
    for (var group in lstData) {
      BookGroup bookGroup = BookGroup.fromJson(group);
      bookGroups.add(bookGroup);
    }
    return bookGroups;
  }

  static Future<List<Book>> getBooksByGroup(groupId, userId) async {
    var resp = await Http().post("book_infos", data: {'user_id': userId, "group_id": groupId});
    List<Book> lstBooks = [];
    if (resp.isSuccess()) {
      var lstData = resp.data['book_infos'];
      for (var item in lstData) {
        Book book = Book.fromJson(item);
        lstBooks.add(book);
      }
    }

    return lstBooks;
  }

  static Future<List<Book>> getUserBooks(String userId, bool isDone) async {
    var resp = await Http().post("get_user_books", data: {'user_id': userId, "is_done": isDone ? 1 : 0});

    List<Book> lstBooks = [];
    if (resp.isSuccess()) {
      var lstData = resp.data['user_books'];
      for (var item in lstData) {
        Book book = Book.fromJson(item);
        lstBooks.add(book);
      }
    }

    return lstBooks;
  }

  static Future<List<Word>> getRandomWords(wordDbName, [count = 1]) async {
    var resp = await Http().post("random_words", data: {'word_db_nm': wordDbName, "count": count});
    List<Word> lstWords = [];
    if (resp.isSuccess()) {
      var lstData = resp.data['words'];
      for (var item in lstData) {
        Word word = Word.fromJson(item);
        lstWords.add(word);
      }
    }

    return lstWords;
  }

/**
 * 获取生词数
 */
  static Future<int> getUnknownWordsCount(userId, [maxScore = 80]) async {
    var resp = await Http().post("count_user_word", data: {'user_id': userId, "max_score": maxScore});
    int count = resp.data['count'];
    return count;
  }

  /**
     * 增加生词
     * @param(score) 10 : 完全忘记   50 ：模模糊糊    80 ： So Easy
     */
  static Future<bool> upsertUserWord(userId, wordId, wordName, score, wordDBName) async {
    await Http().post("upsert_user_word", data: {
      'user_id': userId,
      "word_id": wordId,
      "score": score,
      "word_name": wordName,
      "word_db": wordDBName,
    });

    return true;
  }
}
