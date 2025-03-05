import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/constants/constans.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/pages/main_page.dart';
import 'package:wanandroidflutter/user.dart';
import 'package:wanandroidflutter/utils/error_handle.dart';

Future<void> main() async {
  handleError(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 初始化 mmkv
    await MMKV.initialize();
    // 加载本地用户
    User().loadFromLocal();

    configDio(baseUrl: Constant.baseUrl);

    runApp(
      ChangeNotifierProvider(create: (context) => User(), child: const MyApp()),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      title: "Flutter",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MainPage(title: "WanAndroidFlutter"),
    );
  }
}
