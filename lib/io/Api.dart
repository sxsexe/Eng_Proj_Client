import 'package:common_utils/common_utils.dart';
import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/book_group.dart';
import 'package:my_eng_program/data/server_resp.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/io/Http.dart';
import 'package:my_eng_program/util/cache_manager.dart';
import 'package:my_eng_program/util/logger.dart';
import 'package:my_eng_program/util/strings.dart';

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
    var today = DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    String? sentence = await RamCacheManager.getInstance().getSenetence(today);
    if (StringUtil.isStringEmpty(sentence)) {
      var resp = await Http().get("get_sentence_a_day");
      if (resp.isSuccess()) {
        try {
          sentence = resp.data['rs']['en'];
          RamCacheManager.getInstance().addSenetence(today, sentence!);
        } catch (e) {}
      }
    }

    return sentence;
  }

  static Future<List<BookGroup>> getBookGroups(userId) async {
    List<BookGroup> bookGroups = await RamCacheManager.getInstance().BookGroupsCache;
    if (bookGroups.isEmpty) {
      var resp = await Http().post("book_groups", data: {'user_id': userId});
      bookGroups = BookGroup.listFromJson(resp.data['book_groups']);
      RamCacheManager.getInstance().BookGroupsCache = bookGroups;
    }

    return bookGroups;
  }

  static Future<List<Book>> getBooksByGroup(groupId, userId) async {
    List<Book> lstBooks = await RamCacheManager.getInstance().getBooksByGroup(groupId);
    if (lstBooks.isEmpty) {
      var resp = await Http().post("book_infos_by_group", data: {'user_id': userId, "group_id": groupId});
      if (resp.isSuccess()) {
        lstBooks = Book.listFromJson(resp.data['book_infos']);
        RamCacheManager.getInstance().addBooksByGroup(groupId, lstBooks);
      }
    }
    return lstBooks;
  }

  static Future<bool> updateUserBookStatus(
      String userId, String bookId, int leartState, int? bookType, String? createTime, String? lastTime) async {
    var resp = await Http().post(
      "learn_a_book",
      data: {
        'user_id': userId,
        'book_id': bookId,
        "book_type": bookType,
        "learn_state": leartState,
        "create_time": createTime,
        "last_time": lastTime,
      },
    );
    return resp.isSuccess();
  }

  static Future<List<Book>> getUserBooks(String userId, BooKLearnState learnState) async {
    List<Book> lstResult = [];
    List<Book> lstAllBooks = await RamCacheManager.getInstance().UserBooks;
    if (lstAllBooks.isEmpty) {
      var resp = await Http().post("get_user_books", data: {'user_id': userId});
      if (resp.isSuccess()) {
        lstAllBooks = Book.listFromJson(resp.data['user_books']);
        RamCacheManager.getInstance().UserBooks = lstAllBooks;
      }
    }
    lstResult = await RamCacheManager.getInstance().getUserBooksByLearnState(learnState);

    return lstResult;
  }

  static Future<Word?> getRandomWord(wordDbName, [count = RamCacheManager.WORDS_CACHE_COUNT]) async {
    Word? word = await RamCacheManager.getInstance().getNextWord();
    if (word == null) {
      var resp = await Http().post("random_words", data: {'word_db_nm': wordDbName, "count": count});
      if (resp.isSuccess()) {
        List<Word> lstWords = Word.listFromJson(resp.data['words']);
        RamCacheManager.getInstance().Words = lstWords;
        word = RamCacheManager.getInstance().getNextWord();
      }
    }

    return word;
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
