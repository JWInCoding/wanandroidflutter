import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/mine/login_page.dart';
import 'package:wanandroidflutter/module/mine/setting_page.dart';
import 'package:wanandroidflutter/user.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with BasePage<MinePage>, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    // 设置状态栏颜色为透明
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final colorScheme = Theme.of(context).colorScheme;
    final appBarColorScheme = Theme.of(context).appBarTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 170,
            child: Container(color: appBarColorScheme.backgroundColor),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 30),
                _buildUserInfoHeader(context),
                Expanded(child: _buildListView(colorScheme)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarTheme = Theme.of(context).appBarTheme;
    final textTheme = Theme.of(context).textTheme;

    final user = Get.find<UserController>();

    return GestureDetector(
      child: Container(
        color: appBarTheme.backgroundColor,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(Icons.person, color: colorScheme.primary, size: 30),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    user.isLoggedIn.value ? user.userName : '未登录',
                    style: textTheme.titleMedium?.copyWith(
                      color: appBarTheme.foregroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    user.isLoggedIn.value ? '积分：${user.userCoinCount}' : '点击登录',
                    style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (user.isLoggedIn.value == false) {
          Get.to(() => const LoginPage(), fullscreenDialog: true);
        }
      },
    );
  }

  ListView _buildListView(ColorScheme colorScheme) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        _buildFuntionItem(
          icon: Icons.settings_outlined,
          title: '设置',
          onTap: () {
            Get.to(() => const SettingPage());
          },
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildFuntionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: colorScheme.primary),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
