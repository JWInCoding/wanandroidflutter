import 'package:flutter/material.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 添加AppBar可以更清晰看出是新页面
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("首页", style: const TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Wanlog.i("跳转搜索");
            },
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: '搜索',
          ),
        ],
      ),
      // 使用鲜明的背景色，便于在切换页面时识别
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '首页',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
