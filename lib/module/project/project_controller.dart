import 'package:get/get.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/project_category_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';

class ProjectController extends GetxController {
  final _tabs = <ProjectCategoryEntity>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;

  List<ProjectCategoryEntity> get tabs => _tabs;

  @override
  void onInit() {
    super.onInit();
    getCategoryList();
  }

  Future<void> getCategoryList() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      AppResponse<List<ProjectCategoryEntity>> categoryRes = await HttpGo
          .instance
          .get(Api.projectCategory);

      if (categoryRes.isSuccessful && categoryRes.data != null) {
        _tabs.assignAll(categoryRes.data!);
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
