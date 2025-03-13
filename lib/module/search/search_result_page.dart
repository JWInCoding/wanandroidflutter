import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/module/article_item_layout.dart';
import 'package:wanandroidflutter/module/detail_page.dart';
import 'package:wanandroidflutter/module/mine/login_page.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/article_data_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/user.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key, required this.keyword});

  final String keyword;

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  int _pageIndex = 0;
  List<ArticleItemEntity> data = [];

  final _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    _searchRequest();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  _searchRequest() async {
    try {
      AppResponse<ArticleDataEntity> res = await HttpGo.instance.post(
        "${Api.searchForKeyword}$_pageIndex/json",
        data: {"k": widget.keyword},
      );

      if (res.isSuccessful) {
        if (_pageIndex == 0) {
          data.clear();
        }

        List<ArticleItemEntity> newData = res.data!.datas;

        setState(() {
          data.addAll(newData);
        });

        // 刷新完成
        _refreshController.finishRefresh();

        // 根据返回数据判断是否还有更多
        bool hasMore =
            newData.isNotEmpty &&
            newData.length == res.data!.size &&
            !res.data!.over;

        if (hasMore) {
          _refreshController.finishLoad(IndicatorResult.success);
        } else {
          _refreshController.finishLoad(IndicatorResult.noMore);
        }
      } else {
        _refreshController.finishRefresh(IndicatorResult.fail);
        _refreshController.finishLoad(IndicatorResult.fail);
      }
    } catch (e) {
      _refreshController.finishRefresh(IndicatorResult.fail);
      _refreshController.finishLoad(IndicatorResult.fail);
    }
  }

  // 收藏/取消
  _toggleCollect(ArticleItemEntity itemEntity) async {
    if (Get.find<UserController>().isLoggedIn.value == false) {
      Get.to(() => LoginPage());
      return;
    }

    bool collected = itemEntity.collect;

    AppResponse<dynamic> res =
        await (collected
            ? HttpGo.instance.post(
              "${Api.uncollectArticel}${itemEntity.id}/json",
            )
            : HttpGo.instance.post(
              "${Api.collectArticle}${itemEntity.id}/json",
            ));
    if (res.isSuccessful) {
      Fluttertoast.showToast(msg: (collected ? "取消收藏" : "收藏成功"));
      itemEntity.collect = !itemEntity.collect;
      // 通知 UI 更新
      setState(() {
        int index = data.indexWhere((element) => element.id == itemEntity.id);
        if (index != -1) {
          data[index] = itemEntity;
        }
      });
    } else {
      Fluttertoast.showToast(msg: (collected ? "取消失败" : "收藏失败"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.keyword),
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: EasyRefresh.builder(
        controller: _refreshController,
        onRefresh: () {
          _pageIndex = 0;
          _searchRequest();
        },
        onLoad: () {
          _pageIndex++;
          _searchRequest();
        },
        childBuilder: (context, physics) {
          return ListView.builder(
            itemCount: data.length,
            physics: physics,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap:
                    () => Get.to(
                      () => DetailPage(data[index].link, data[index].title),
                    ),
                child: ArticleItemLayout(
                  itemEntity: data[index],
                  onCollectTap: () => _toggleCollect(data[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
