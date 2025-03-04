import 'package:logger/logger.dart';
import 'package:wanandroidflutter/constants/constans.dart';

class Wanlog {
  static const String tag = "Wanlog";

  static Logger logger = Logger();

  static void i(String msg, {String tag = tag}) {
    if (Constant.debug) {
      logger.i(msg);
    }
  }

  static void d(String msg, {String tag = tag}) {
    if (Constant.debug) {
      logger.d(msg);
    }
  }

  static void w(String msg, {String tag = tag}) {
    if (Constant.debug) {
      logger.w(msg);
    }
  }

  static void e(String msg, {String tag = tag}) {
    if (Constant.debug) {
      logger.e(msg);
    }
  }
}
