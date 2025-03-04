import 'package:mmkv/mmkv.dart';

/// 封装MMKV框架提供的键值存储功能
class Persistent {
  // 创建MMKV的默认实例
  var mmkv = MMKV.defaultMMKV();

  /// 存储布尔值到持久化存储
  void encodeBool(String key, bool value) {
    mmkv.encodeBool(key, value);
  }

  /// 存储字符串到持久化存储
  void encodeString(String key, String value) {
    mmkv.encodeString(key, value);
  }

  /// 存储整数到持久化存储
  void encodeInt(String key, int value) {
    mmkv.encodeInt(key, value);
  }

  /// 读取指定键的布尔值
  bool decodeBool(String key, {bool defautValue = false}) {
    return mmkv.decodeBool(key, defaultValue: defautValue);
  }

  /// 读取指定键的字符串值
  String? decodeString(String key) {
    return mmkv.decodeString(key);
  }

  /// 读取指定键的整数值
  int decodeInt(String key, {int defaultValue = 0}) {
    return mmkv.decodeInt(key, defaultValue: defaultValue);
  }

  /// 从存储中移除指定的键值对
  void remove(String key) {
    mmkv.removeValue(key);
  }
}
