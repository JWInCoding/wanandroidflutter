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
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 170,
            child: Container(color: colorScheme.primary),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 30),
                _buildUserInfoHeader(colorScheme, textTheme),
                Expanded(child: _buildListView(colorScheme)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoHeader(ColorScheme colorScheme, TextTheme textTheme) {
    final bool isLoggedIn = Get.find<UserController>().isLoggedIn.value;

    return GestureDetector(
      child: Container(
        color: colorScheme.primary,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: colorScheme.primary, size: 30),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLoggedIn ? '用户名' : '未登录',
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLoggedIn ? '等级：0  积分：0' : '点击登录',
                  style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (isLoggedIn == false) {
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
