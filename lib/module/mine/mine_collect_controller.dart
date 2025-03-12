import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/article_data_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class MineCollectController extends GetxController {
  final _pageIndex = 0.obs;
  final articleList = <ArticleItemEntity>[].obs;
  final lastLoadedData = <ArticleItemEntity>[].obs;

  //加载状态
  final isLoading = true.obs;
  final hasError = false.obs;

  // 刷新控制器
  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void onInit() {
    super.onInit();

    refreshData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      _pageIndex.value = 0; // 重置页码
      articleList.clear(); // 清空当前数据

      bool success = await _loadRequest();
      if (!success) {
        hasError.value = true; // 失败时只标记错误，不恢复数据
      } else {
        lastLoadedData.assignAll(articleList); // 更新上一次加载的数据
      }
    } catch (e) {
      Wanlog.e("刷新数据失败 $e");
      hasError.value = true; // 直接更新错误状态
      articleList.assignAll(lastLoadedData); // 使用上一次成功加载的数据
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
    AppResponse<ArticleDataEntity> res = await HttpGo.instance.get(
      "${Api.collectList}${_pageIndex.value}/json",
    );

    List<ArticleItemEntity> items = res.data?.datas ?? [];
    if (items.isNotEmpty) {
      articleList.addAll(items);
      articleList.refresh();
      return true;
    }
    return false;
  }
}
