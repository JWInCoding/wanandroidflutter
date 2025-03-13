import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(this.url, this.title, {super.key});

  final String url;
  final String title;

  @override
  State createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  _DetailPageState();

  Key progressKey = GlobalKey();
  Key contentKey = GlobalKey();

  final WebViewController _controller = WebViewController();

  bool finish = false;
  int loadProgress = 0; // 添加加载进度变量

  @override
  void initState() {
    super.initState();
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => {},
          onProgress: (progress) {
            // 更新加载进度
            setState(() {
              loadProgress = progress;
            });
          },
          onPageFinished: (content) {
            setState(() {
              finish = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Html(
          data: widget.title,
          style: {
            "html": Style(
              color: Colors.white,
              margin: Margins.zero,
              textOverflow: TextOverflow.ellipsis,
              fontSize: FontSize(18),
              padding: HtmlPaddings.zero,
              alignment: Alignment.topLeft,
            ),
            "body": Style(
              color: Colors.white,
              margin: Margins.zero,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              fontSize: FontSize(18),
              padding: HtmlPaddings.zero,
              alignment: Alignment.topLeft,
            ),
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          !finish
              ? Container(
                key: progressKey,
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text("加载中... $loadProgress%"), // 显示加载进度百分比
                  ],
                ),
              )
              : WebViewWidget(controller: _controller, key: contentKey),
    );
  }
}
