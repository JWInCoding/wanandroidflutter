import 'package:flutter/material.dart';

class PlazaPage extends StatefulWidget {
  const PlazaPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlazaPageState();
}

class _PlazaPageState extends State<PlazaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 使用鲜明的背景色，便于在切换页面时识别
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '广场页面',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
