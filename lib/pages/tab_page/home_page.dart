import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/article_data_entity.dart';
import 'package:wanandroidflutter/network/bean/banner_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/pages/detail_page.dart';
import 'package:wanandroidflutter/pages/widget/article_item_layout.dart';
import 'package:wanandroidflutter/user.dart';
import 'package:wanandroidflutter/utils/image_util.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with BasePage<HomePage>, AutomaticKeepAliveClientMixin {
  var _pageIndex = 0;

  List<ArticleItemEntity> _articleList = List.empty();

  List<BannerEntity>? bannerData;

  var retryCount = 0.obs;
  var dataUpdate = 0.obs;

  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<User>(
      builder: (context, user, child) {
        return Obx(() {
          Wanlog.i("retry count: ${retryCount.value}");
          return _build(context);
        });
      },
    );
  }

  Widget _build(BuildContext context) {
    return FutureBuilder(
      future: _refreshRequest(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == false) {
            return RetryWidget(onTapRetry: () => retryCount.value++);
          }
          return Obx(() {
            Wanlog.i("data update: ${dataUpdate.value}");
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
              body: EasyRefresh.builder(
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoad: _loadRequest,
                childBuilder: (context, physics) {
                  return CustomScrollView(
                    physics: physics,
                    slivers: [
                      if (bannerData != null && bannerData!.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                            child: CarouselSlider(
                              items: _bannerList(),
                              options: CarouselOptions(
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                              ),
                            ),
                          ),
                        ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => DetailPage(
                                  _articleList[index].link,
                                  _articleList[index].title,
                                ),
                              );
                            },
                            child: ArticleItemLayout(
                              itemEntity: _articleList[index],
                              onCollectTap: () {},
                            ),
                          );
                        }, childCount: _articleList.length),
                      ),
                    ],
                  );
                },
              ),
            );
          });
        } else {
          return const Center(
            widthFactor: 1,
            heightFactor: 1,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  List<Widget> _bannerList() =>
      bannerData!
          .map(
            (e) => Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                child: ImageUtil.network(
                  url: e.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          )
          .toList();

  Future<bool> _refreshRequest() async {
    _pageIndex = 0;
    bool resultStatus = true;

    // 获取 banner
    List<ArticleItemEntity> result = [];
    AppResponse<List<BannerEntity>> bannerRes = await HttpGo.instance.get(
      Api.banner,
    );
    bannerData = bannerRes.data;
    resultStatus &= bannerRes.isSuccessful;

    // 获取置顶
    AppResponse<List<ArticleItemEntity>> topRes = await HttpGo.instance.get(
      Api.topArticle,
    );
    if (topRes.isSuccessful) {
      result.addAll(topRes.data ?? List.empty());
    }
    resultStatus &= topRes.isSuccessful;
    // 获取文章列表
    AppResponse<ArticleDataEntity> res = await HttpGo.instance
        .get<ArticleDataEntity>("${Api.homePageArticle}$_pageIndex/json");
    resultStatus &= res.isSuccessful;
    if (res.isSuccessful) {
      result.addAll(res.data?.datas ?? List.empty());
    }
    _articleList = result;
    return resultStatus;
  }

  void _loadRequest() async {
    _pageIndex++;
    AppResponse<ArticleDataEntity> res = await HttpGo.instance
        .get<ArticleDataEntity>("${Api.homePageArticle}$_pageIndex/json");
    if (res.isSuccessful) {
      _articleList.addAll(res.data?.datas ?? List.empty());
    }
    _refreshController.finishLoad();
    dataUpdate.refresh();
  }

  void _onRefresh() async {
    await _refreshRequest();
    _refreshController.finishRefresh();
    dataUpdate.refresh();
  }

  @override
  bool get wantKeepAlive => true;
}
