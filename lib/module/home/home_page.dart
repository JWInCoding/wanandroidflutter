import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/home/home_controller.dart';
import 'package:wanandroidflutter/network/bean/banner_entity.dart';
import 'package:wanandroidflutter/pages/detail_page.dart';
import 'package:wanandroidflutter/pages/widget/article_item_layout.dart';
import 'package:wanandroidflutter/utils/image_util.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with BasePage<HomePage>, AutomaticKeepAliveClientMixin {
  // 控制器实例
  late HomeController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.put(HomeController(), tag: "首页");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 获取当前主题色
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        title: Text('首页'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Wanlog.i("跳转搜索");
            },
            icon: Icon(Icons.search, color: colorScheme.onPrimary),
            tooltip: '搜索',
          ),
        ],
      ),
      backgroundColor: colorScheme.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hasError.value) {
          return RetryWidget(onTapRetry: controller.refreshData);
        }

        // 检查是否有Banner数据
        final hasBanner =
            controller.bannerData.value != null &&
            controller.bannerData.value!.isNotEmpty;

        return EasyRefresh(
          controller: controller.refreshController,
          onRefresh: controller.refreshData,
          onLoad: controller.loadMoreData,
          child: ListView.builder(
            // 列表总长度 = 文章数量 + (有Banner时为1，无Banner时为0)
            itemCount: controller.articleList.length + (hasBanner ? 1 : 0),
            itemBuilder: (context, index) {
              // 如果有Banner且是第一个位置，显示Banner
              if (hasBanner && index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: CarouselSlider(
                    items: _bannerList(controller.bannerData.value!),
                    options: CarouselOptions(
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                  ),
                );
              }

              // 计算文章列表中的实际索引
              final articleIndex = hasBanner ? index - 1 : index;
              final article = controller.articleList[articleIndex];

              return GestureDetector(
                onTap: () {
                  Get.to(() => DetailPage(article.link, article.title));
                },
                child: ArticleItemLayout(
                  itemEntity: article,
                  onCollectTap: () => controller.toggleCollect(article),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  List<Widget> _bannerList(List<BannerEntity> banners) {
    final divoderColor = Theme.of(context).dividerColor;

    return banners
        .map(
          (e) => Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: divoderColor, width: 0.5),
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
  }

  @override
  bool get wantKeepAlive => true;
}
