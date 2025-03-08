import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/theme/theme_controller.dart';
import 'package:wanandroidflutter/user.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;
    // 获取当前主题色
    final appBarColorScheme = Theme.of(context).appBarTheme;

    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        foregroundColor: appBarColorScheme.foregroundColor,
        backgroundColor: appBarColorScheme.backgroundColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('外观模式'),
                  subtitle: GetBuilder<ThemeController>(
                    builder:
                        (_) => Text(
                          themeController.themeMode == ThemeMode.light
                              ? '浅色模式'
                              : themeController.themeMode == ThemeMode.dark
                              ? '深色模式'
                              : '跟随系统',
                        ),
                  ),
                  trailing: const Icon(Icons.brightness_6),
                  onTap: () => _showThemeModeDialog(context),
                ),
              ],
            ),
          ),
          if (userController.isLoggedIn.value)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade400, width: 0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    userController.logout();
                    Get.back();
                  },
                  child: const Text(
                    '退出登录',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showThemeModeDialog(BuildContext context) {
    final themeController = ThemeController.to;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('选择外观模式'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('浅色'),
                  leading: const Icon(Icons.brightness_5),
                  onTap: () {
                    themeController.setThemeMode(ThemeMode.light);
                  },
                  selected: themeController.themeMode == ThemeMode.light,
                ),
                ListTile(
                  title: const Text('深色'),
                  leading: const Icon(Icons.brightness_3),
                  onTap: () {
                    themeController.setThemeMode(ThemeMode.dark);
                  },
                  selected: themeController.themeMode == ThemeMode.dark,
                ),
                ListTile(
                  title: const Text('跟随系统'),
                  leading: const Icon(Icons.brightness_auto),
                  selected: themeController.themeMode == ThemeMode.system,
                  onTap: () {
                    themeController.setThemeMode(ThemeMode.system);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
