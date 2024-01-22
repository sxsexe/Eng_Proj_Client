import 'package:my_eng_program/data/book.dart';
import 'package:my_eng_program/data/book_group.dart';
import 'package:my_eng_program/data/word.dart';
import 'package:my_eng_program/util/logger.dart';

class RamCacheManager {
  RamCacheManager._in();

  factory RamCacheManager() => _instance;

  static final RamCacheManager _instance = RamCacheManager._in();

  static RamCacheManager getInstance() => _instance;

/**
 * 书籍分类缓存
 */
  static List<BookGroup> _sBookGroups = [];
  set BookGroupsCache(List<BookGroup> data) => _sBookGroups = data;
  List<BookGroup> get BookGroupsCache => _sBookGroups;

/**
 * Sentence 缓存
 */
  Map<String, String> _sSenetenEachDay = {};
  void addSenetence(String day, String data) => _sSenetenEachDay[day] = data;
  String? getSenetence(String day) => _sSenetenEachDay[day];

/**
 * books缓存
 */
  Map<String, List<Book>> _sBooksByGroup = {};
  void addBooksByGroup(String groupId, List<Book> books) => _sBooksByGroup[groupId] = books;
  List<Book> getBooksByGroup(String groupId) {
    List<Book> rs = [];
    if (_sBooksByGroup.containsKey(groupId)) {
      rs = _sBooksByGroup[groupId]!;
    }
    return rs;
  }

/**
 * 用户的books cache
 */
  List<Book> _sUserBooks = [];
  set UserBooks(List<Book> data) => _sUserBooks = data;
  List<Book> get UserBooks => _sUserBooks;
  int getIndexOfUserBook(String bookId) {
    int index = -1;
    for (var el in _sUserBooks) {
      if (el.id == bookId) {
        index = _sUserBooks.indexOf(el);
        break;
      }
    }
    return index;
  }

  bool updateBookLearnState(String bookId, BooKLearnState learnState) {
    int index = getIndexOfUserBook(bookId);
    if (index >= 0) {
      Book book = _sUserBooks[index];
      book.learnState = learnState;
      return true;
    }
    return false;
  }

  void addNewUserBook(Book book) {
    _sUserBooks.insert(0, book);
  }

  List<Book> getUserBooksByLearnState(BooKLearnState learnState) {
    List<Book> lstResult = [];
    for (var el in _sUserBooks) {
      if (el.learnState == learnState) {
        lstResult.add(el);
      }
    }
    return lstResult;
  }

/**
 * 单词Cache
 */
  static const int WORDS_CACHE_COUNT = 10;
  static int _sWordCursor = -1;
  List<Word> _sListWords = [];
  set Words(List<Word> data) {
    _sListWords = data;
    _sWordCursor = 0;
  }

  Word? getNextWord() {
    Word? word = null;
    if (_sWordCursor >= 0 && _sWordCursor < WORDS_CACHE_COUNT) {
      word = _sListWords[_sWordCursor++];
    }
    if (word == null) {
      Logger.debug("CACHE", "getNextWord _sWordCursor=$_sWordCursor, word is null");
    } else {
      Logger.debug("CACHE", "getNextWord _sWordCursor=$_sWordCursor, word is ${word.name}");
    }

    return word;
  }
}
