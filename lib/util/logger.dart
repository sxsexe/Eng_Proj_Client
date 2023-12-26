import 'package:ansicolor/ansicolor.dart';

class Logger {
  static AnsiPen _penRed = AnsiPen()..red();
  static AnsiPen _penGreen = AnsiPen()..green();
  static AnsiPen _penBlue = AnsiPen()..blue();
  static AnsiPen _penCyan = AnsiPen()..cyan();
  static AnsiPen _penGray = AnsiPen()..gray();

  static String _getFileLineNo() {
    // StackTrace trace = StackTrace.current;
    // var traceString = trace.toString().split("\n")[0];
    // var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
    // var fileInfo = traceString.substring(indexOfFileName);
    // var listOfInfos = fileInfo.split(":");

    // var fileName = listOfInfos[0];
    // var lineNumber = int.parse(listOfInfos[1]);

    // return fileName + " : " + lineNumber.toString();
    return "";
  }

  static String _getDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch, isUtc: true).toString();
  }

  static String _getLogPreString() {
    String str = _getDateTime();
    return str;
  }

  static void debug(tag, message) {
    ansiColorDisabled = false;
    print(_penGreen(_getLogPreString() + " [ " + tag + " ]     " + message));
  }

  static void error(tag, message) {
    ansiColorDisabled = false;
    print(_penRed(_getLogPreString() + " [ " + tag + " ]     " + message));
  }
}
