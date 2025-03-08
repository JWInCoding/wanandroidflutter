import 'package:get/get.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/project_category_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';

class ProjectController extends GetxController {
  final _tabs = <ProjectCategoryEntity>[].obs;
  final isLoading = true.obs;

  List<ProjectCategoryEntity> get tabs => _tabs;

  @override
  void onInit() {
    super.onInit();
    _getCategoryList();
  }

  Future<void> _getCategoryList() async {
    isLoading.value = true;
    AppResponse<List<ProjectCategoryEntity>> categoryRes = await HttpGo.instance
        .get(Api.projectCategory);

    if (categoryRes.isSuccessful && categoryRes.data != null) {
      _tabs.assignAll(categoryRes.data!);
    }
    isLoading.value = false;
  }
}
