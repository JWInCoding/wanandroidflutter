import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';
import 'package:wanandroidflutter/constants/constans.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/pages/main_page.dart';
import 'package:wanandroidflutter/theme/theme_controller.dart';
import 'package:wanandroidflutter/user.dart';
import 'package:wanandroidflutter/utils/error_handle.dart';

Future<void> main() async {
  handleError(() async {
    WidgetsFlutterBinding.ensureInitialized();
    configDio(baseUrl: Constant.baseUrl);

    // 初始化 mmkv
    await MMKV.initialize();
    // 初始化 GetX 控制器 (替代Provider)
    Get.put(UserController(), permanent: true);
    // 初始化主题控制器
    Get.put(ThemeController(), permanent: true);
    // 加载本地用户信息
    UserController.to.loadFromLocal();

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder:
          (themeController) => GetMaterialApp(
            builder: FToastBuilder(),
            debugShowCheckedModeBanner: false,
            title: "Flutter",
            themeMode: themeController.themeMode,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            home: const MainPage(title: "WanAndroidFlutter"),
          ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        primary: Colors.blueAccent,
        seedColor: Colors.lightBlue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      cardTheme: const CardTheme(
        surfaceTintColor: Colors.white,
        color: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      cardTheme: CardTheme(
        surfaceTintColor: Colors.grey[850],
        color: Colors.grey[850],
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
