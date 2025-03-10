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

    // 创建一个函数来处理主题选择和对话框关闭
    void handleThemeModeSelection(ThemeMode mode, BuildContext dialogContext) {
      // 先设置主题模式
      themeController.setThemeMode(mode);

      // 保存Navigator引用，避免异步间隙后的BuildContext问题
      final navigator = Navigator.of(dialogContext);

      // 添加短暂延迟以提供视觉反馈
      Future.delayed(const Duration(milliseconds: 150), () {
        navigator.pop();
      });
    }

    // 创建主题选项ListTile的辅助函数
    Widget buildThemeOptionTile(
      String title,
      IconData icon,
      ThemeMode mode,
      BuildContext dialogContext,
    ) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => handleThemeModeSelection(mode, dialogContext),
          child: ListTile(
            title: Text(title),
            leading: Icon(icon),
            selected: themeController.themeMode == mode,
            selectedTileColor: Theme.of(
              context,
            ).colorScheme.primaryContainer.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('选择外观模式'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildThemeOptionTile(
                  '浅色',
                  Icons.brightness_5,
                  ThemeMode.light,
                  dialogContext,
                ),
                const SizedBox(height: 4),
                buildThemeOptionTile(
                  '深色',
                  Icons.brightness_3,
                  ThemeMode.dark,
                  dialogContext,
                ),
                const SizedBox(height: 4),
                buildThemeOptionTile(
                  '跟随系统',
                  Icons.brightness_auto,
                  ThemeMode.system,
                  dialogContext,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
    );
  }
}
