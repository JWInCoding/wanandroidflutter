import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/article_item_layout.dart';
import 'package:wanandroidflutter/module/detail_page.dart';
import 'package:wanandroidflutter/module/tree/tree_list_page_controller.dart';

class TreeListPage extends StatefulWidget {
  const TreeListPage(this.cid, this.treeName, {super.key});

  final String treeName;
  final int cid;

  @override
  State<TreeListPage> createState() => _TreeListPageState();
}

class _TreeListPageState extends State<TreeListPage>
    with BasePage<TreeListPage> {
  late TreeListPageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(TreeListPageController(widget.cid));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarColorScheme = Theme.of(context).appBarTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.treeName),
        backgroundColor: appBarColorScheme.backgroundColor,
        foregroundColor: appBarColorScheme.foregroundColor,
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
        return EasyRefresh(
          controller: _controller.refreshController,
          onRefresh: _controller.refreshData,
          onLoad: _controller.loadMoreData,
          child: ListView.builder(
            itemCount: _controller.articleList.length,
            itemBuilder: (context, index) {
              final article = _controller.articleList[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => DetailPage(article.link, article.title));
                },
                child: ArticleItemLayout(
                  itemEntity: article,
                  onCollectTap: () => _controller.toggleCollect(article),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
