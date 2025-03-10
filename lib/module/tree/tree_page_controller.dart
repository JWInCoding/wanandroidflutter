import 'package:get/get.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/project_category_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';

class TreePageController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTreeData();
  }

  Future<void> getTreeData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      AppResponse<List<ProjectCategoryEntity>> categoryRes = await HttpGo
          .instance
          .get(Api.projectCategory);

      if (categoryRes.isSuccessful && categoryRes.data != null) {
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
