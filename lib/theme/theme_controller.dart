import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  static const String _themeModKey = 'theme_mode';

  final _themeMode = Rx<ThemeMode>(ThemeMode.system);

  ThemeMode get themeMode => _themeMode.value;

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }

  void loadThemeMode() {
    final mmkv = MMKV.defaultMMKV();
    final savedThemeMode = mmkv.decodeInt(_themeModKey);
    // 如果savedThemeMode为null(首次运行)，这里会报错
    _themeMode.value = ThemeMode.values[savedThemeMode];
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final mmkv = MMKV.defaultMMKV();
    mmkv.encodeInt(_themeModKey, mode.index);
  }

  void toggleThemeMode() {
    _themeMode.value =
        _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeMode(_themeMode.value);
    update();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _saveThemeMode(mode);
    update();
    // Get.changeThemeMode(mode);
  }
}
