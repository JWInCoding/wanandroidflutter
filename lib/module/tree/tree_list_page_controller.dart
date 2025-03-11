import 'package:easy_refresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/module/mine/login_page.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/article_data_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/user.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class TreeListPageController extends GetxController {
  final isLoading = true.obs;
  final hasError = true.obs;

  final int cid;
  final _pageIndex = 1.obs;
  final _articleList = <ArticleItemEntity>[].obs;
  final lastLoadedData = <ArticleItemEntity>[].obs; // 新增状态存储上一次加载的数据

  List<ArticleItemEntity> get articleList => _articleList;

  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  TreeListPageController(this.cid);

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      _pageIndex.value = 1;
      _articleList.clear();
      bool success = await _loadRequest();
      if (success) {
        lastLoadedData.assignAll(_articleList);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      Wanlog.e("刷新数据失败 $e");
      hasError.value = true;
      _articleList.assignAll(lastLoadedData);
    } finally {
      isLoading.value = false;
      refreshController.finishRefresh();
    }
  }

  Future<void> loadMoreData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      _pageIndex.value++;
      bool hasMoreData = await _loadRequest();
      if (hasMoreData) {
        refreshController.finishLoad();
      } else {
        refreshController.finishLoad(IndicatorResult.noMore);
      }
    } catch (e) {
      _pageIndex.value--;
      refreshController.finishLoad(IndicatorResult.fail);
    } finally {
      isLoading.value = false;
      hasError.value = true;
    }
  }

  Future<bool> _loadRequest() async {
    isLoading.value = true;
    hasError.value = false;
    AppResponse<ArticleDataEntity> articleRes = await HttpGo.instance.get(
      "${Api.treeArticle}${_pageIndex.value}/json",
      queryParams: {"cid": cid},
    );

    if (articleRes.isSuccessful && articleRes.data != null) {
      _articleList.addAll(articleRes.data!.datas);
      _articleList.refresh();
      return true;
    } else {
      return false;
    }
  }

  // 收藏/取消
  Future<void> toggleCollect(ArticleItemEntity itemEntity) async {
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
      int index = articleList.indexWhere(
        (element) => element.id == itemEntity.id,
      );
      if (index != -1) {
        articleList[index] = itemEntity;
        _articleList.refresh();
      }
    } else {
      Fluttertoast.showToast(msg: (collected ? "取消失败" : "收藏失败"));
    }
  }
}
