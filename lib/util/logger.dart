import 'package:ansicolor/ansicolor.dart';

class Logger {
  static AnsiPen _penRed = AnsiPen()..red();
  static AnsiPen _penGreen = AnsiPen()..green();

  static String _getDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch, isUtc: true).toString();
  }

  static String _getLogPreString() {
    String str = _getDateTime();
    return str;
  }

  static void debug(tag, message) {
    ansiColorDisabled = false;
    if (message.runtimeType != String) message = message.toString;
    print(_penGreen(_getLogPreString() + " [ " + tag + " ]     " + message));
  }

  static void error(tag, message) {
    ansiColorDisabled = false;
    if (message.runtimeType != String) message = message.toString;
    print(_penRed(_getLogPreString() + " [ " + tag + " ]     " + message));
  }
}
