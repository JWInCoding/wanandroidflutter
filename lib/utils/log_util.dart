import 'package:logger/logger.dart';
import 'package:wanandroidflutter/constants/constans.dart';

class Wanlog {
  static const String logTag = "Wanlog";

  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1, // 显示的方法调用数量
      errorMethodCount: 5, // 错误情况下显示的方法调用数量
      lineLength: 80, // 每行长度
      colors: true, // 启用颜色
      printEmojis: true, // 打印表情符号
    ),
  );

  /// 获取当前时间戳字符串
  static String _getTimestamp() {
    DateTime now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  /// 打印信息级别(Info)日志
  static void i(String msg, {String tag = logTag}) {
    if (Constant.debug) {
      String timestamp = _getTimestamp();
      logger.i("[$timestamp][$tag] $msg");
    }
  }

  /// 打印调试级别(Debug)日志
  static void d(String msg, {String tag = logTag}) {
    if (Constant.debug) {
      String timestamp = _getTimestamp();
      logger.d("[$timestamp][$tag] $msg");
    }
  }

  /// 打印警告级别(Warning)日志
  static void w(String msg, {String tag = logTag}) {
    if (Constant.debug) {
      String timestamp = _getTimestamp();
      logger.w("[$timestamp][$tag] $msg");
    }
  }

  /// 打印错误级别(Error)日志
  static void e(String msg, {String tag = logTag}) {
    if (Constant.debug) {
      String timestamp = _getTimestamp();
      logger.e("[$timestamp][$tag] $msg");
    }
  }
}
