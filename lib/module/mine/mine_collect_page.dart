import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/article_item_layout.dart';
import 'package:wanandroidflutter/module/detail_page.dart';
import 'package:wanandroidflutter/module/mine/mine_collect_controller.dart';

class MineCollectPage extends StatefulWidget {
  const MineCollectPage({super.key});

  @override
  State<MineCollectPage> createState() => _MineCollectPageState();
}

class _MineCollectPageState extends State<MineCollectPage>
    with BasePage<MineCollectPage> {
  final _controller = Get.put(MineCollectController());

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
        foregroundColor: appBarTheme.foregroundColor,
        backgroundColor: appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (_controller.articleList.isEmpty) {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.hasError.value) {
            return RetryWidget(onTapRetry: _controller.refreshData);
          }
          return EmptyWidget();
        }
        return EasyRefresh.builder(
          controller: _controller.refreshController,
          onRefresh: _controller.refreshData,
          onLoad: _controller.loadMoreData,
          childBuilder: (context, physics) {
            return ListView.builder(
              physics: physics,
              itemCount: _controller.articleList.length,
              itemBuilder: (context, index) {
                // 计算文章列表中的实际索引
                final article = _controller.articleList[index];

                return GestureDetector(
                  onTap: () {
                    Get.to(() => DetailPage(article.link, article.title));
                  },
                  child: ArticleItemLayout(
                    itemEntity: article,
                    onCollectTap: () {},
                    displayCollectButton: false,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
