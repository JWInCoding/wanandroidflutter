import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/mine/login_page.dart';
import 'package:wanandroidflutter/module/mine/mine_coin_page.dart';
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
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
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
            height: 110,
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
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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
                const SizedBox(height: 5),
                Obx(
                  () => Text(
                    user.isLoggedIn.value
                        ? '等级：${user.userLevel}    排名：${user.userRank}'
                        : '点击登录',
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
    final items = [
      Obx(
        () => _buildFuntionItem(
          icon: Icons.grade,
          title: '我的积分',
          rightText: Get.find<UserController>().userCoinCount.toString(),
          onTap: () {
            if (UserController.to.isLoggedIn.value) {
              Get.to(() => const MineCoinPage());
            } else {
              Get.to(() => const LoginPage());
            }
          },
          colorScheme: colorScheme,
        ),
      ),
      _buildFuntionItem(
        icon: Icons.favorite_border,
        title: '我的收藏',
        onTap: () {
          Get.to(() => const SettingPage());
        },
        colorScheme: colorScheme,
      ),
      _buildFuntionItem(
        icon: Icons.settings_outlined,
        title: '设置',
        onTap: () {
          Get.to(() => const SettingPage());
        },
        colorScheme: colorScheme,
      ),
    ];

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
      separatorBuilder:
          (context, index) => Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: colorScheme.outline.withOpacity(0.6),
          ),
    );
  }

  Widget _buildFuntionItem({
    required IconData icon,
    required String title,
    String? rightText, // 改为rightText表示右侧文本
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: colorScheme.primary),
      title: Text(title),
      trailing:
          rightText != null && rightText.isNotEmpty
              ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(rightText, style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              )
              : const Icon(
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
