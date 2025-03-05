import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/article_data_entity.dart';
import 'package:wanandroidflutter/network/bean/banner_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class HomeController extends GetxController {
  // 控制器状态
  final _pageIndex = 0.obs;
  final articleList = <ArticleItemEntity>[].obs;
  final bannerData = Rxn<List<BannerEntity>>();

  // 刷新控制器
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  //加载状态
  final isLoading = true.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 初始化时加载数据
    refreshData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // 刷新数据
  Future<void> refreshData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      bool success = await _refreshRequest();
      if (!success) {
        hasError.value = true;
      }
    } catch (e) {
      Wanlog.e("刷新数据失败：$e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
      refreshController.finishRefresh();
    }
  }

  //加载更多
  Future<void> loadMoreData() async {
    try {
      _pageIndex.value++;
      await _loadRequest();
    } catch (e) {
      Wanlog.e("加载更多失败:$e");
      _pageIndex.value--; // 加载失败，恢复页码
    } finally {
      refreshController.finishLoad();
    }
  }

  // 内部刷新请求
  Future<bool> _refreshRequest() async {
    _pageIndex.value = 0;
    bool resultStatus = true;

    // 获取 banner
    List<ArticleItemEntity> result = [];
    AppResponse<List<BannerEntity>> bannerRes = await HttpGo.instance.get(
      Api.banner,
    );
    bannerData.value = bannerRes.data;
    resultStatus &= bannerRes.isSuccessful;

    // 获取置顶
    AppResponse<List<ArticleItemEntity>> topRes = await HttpGo.instance.get(
      Api.topArticle,
    );
    if (topRes.isSuccessful) {
      result.addAll(topRes.data ?? []);
    }
    resultStatus &= topRes.isSuccessful;

    // 获取文章列表
    AppResponse<ArticleDataEntity> res = await HttpGo.instance
        .get<ArticleDataEntity>(
          "${Api.homePageArticle}${_pageIndex.value}/json",
        );
    resultStatus &= res.isSuccessful;
    if (res.isSuccessful) {
      result.addAll(res.data?.datas ?? []);
    }

    // 更新文章列表
    articleList.value = result;
    return resultStatus;
  }

  // 加载更多文章列表
  Future<void> _loadRequest() async {
    AppResponse<ArticleDataEntity> res = await HttpGo.instance
        .get<ArticleDataEntity>(
          "${Api.homePageArticle}${_pageIndex.value}/json",
        );
    if (res.isSuccessful) {
      articleList.addAll(res.data?.datas ?? []);
    }
  }

  // 收藏/取消
  Future<void> toggleCollect(ArticleItemEntity itemEntity) async {
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
      int index = articleList.indexWhere(
        (element) => element.id == itemEntity.id,
      );
      if (index != -1) {
        articleList[index] = itemEntity;
        articleList.refresh();
      }
    } else {
      Fluttertoast.showToast(msg: (collected ? "取消失败" : "收藏失败"));
    }
  }
}
