import 'package:get/get.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/tree_list_data_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';

class TreePageController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;

  final _treeList = <TreeListDataEntity>[].obs;

  List<TreeListDataEntity> get treeList => _treeList;

  @override
  void onInit() {
    super.onInit();
    getTreeData();
  }

  Future<void> getTreeData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      AppResponse<List<TreeListDataEntity>> treeRes = await HttpGo.instance.get(
        Api.treeList,
      );

      if (treeRes.isSuccessful && treeRes.data != null) {
        _treeList.value = treeRes.data!;
        isLoading.value = false;
      } else {
        hasError.value = false;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
