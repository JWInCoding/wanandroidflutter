import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/home/home_controller.dart';
import 'package:wanandroidflutter/network/bean/banner_entity.dart';
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

    return Scaffold(
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
      backgroundColor: Colors.white70,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            widthFactor: 1,
            heightFactor: 1,
            child: CircularProgressIndicator(),
          );
        }
        if (controller.hasError.value) {
          return RetryWidget(onTapRetry: controller.refreshData);
        }
        return EasyRefresh.builder(
          controller: controller.refreshController,
          onRefresh: controller.refreshData,
          onLoad: controller.loadMoreData,
          childBuilder: (content, physics) {
            return CustomScrollView(
              physics: physics,
              slivers: [
                // banner
                if (controller.bannerData.value != null &&
                    controller.bannerData.value!.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
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
                    ),
                  ),
              ],
            );
          },
        );
      }),
    );
  }

  List<Widget> _bannerList(List<BannerEntity> banners) =>
      banners
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

  @override
  bool get wantKeepAlive => true;
}
