import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/project_list_data_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class ProjectListController extends GetxController {
  final int cid;

  final _pageIndex = 1.obs;
  final projectList = <ProjectListDataItemEntity>[].obs;
  final lastLoadedData = <ProjectListDataItemEntity>[].obs; // 新增状态存储上一次加载的数据

  final isLoading = true.obs;
  final hasError = false.obs;

  final refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ProjectListController(this.cid);

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
      _pageIndex.value = 1; // 重置页码
      projectList.clear(); // 清空当前数据

      bool success = await _loadRequest();
      if (!success) {
        hasError.value = true; // 失败时只标记错误，不恢复数据
      } else {
        lastLoadedData.assignAll(projectList); // 更新上一次加载的数据
      }
    } catch (e) {
      Wanlog.e("刷新数据失败 $e");
      hasError.value = true; // 直接更新错误状态
      projectList.assignAll(lastLoadedData); // 使用上一次成功加载的数据
    } finally {
      isLoading.value = false;
      refreshController.finishRefresh();
    }
  }

  Future<void> loadMoreData() async {
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
    }
  }

  Future<bool> _loadRequest() async {
    isLoading.value = true;
    hasError.value = false;

    AppResponse<ProjectListDataEntity> res = await HttpGo.instance.get(
      "${Api.projectList}${_pageIndex.value}/json",
      queryParams: {"cid": cid},
    );

    List<ProjectListDataItemEntity> items = res.data?.datas ?? [];

    // 只有在有新数据的时候才更新列表
    if (items.isNotEmpty) {
      projectList.addAll(items);
      projectList.refresh();
      return true;
    }

    return false; // 无新数据
  }
}
