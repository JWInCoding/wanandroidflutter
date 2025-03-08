import 'package:flutter/material.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/project/project_list_page.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/project_category_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with
        BasePage<ProjectPage>,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  List<ProjectCategoryEntity> _tabs = [];

  TabController? _tabController;

  _getCategroyList() async {
    AppResponse<List<ProjectCategoryEntity>> categroyRes = await HttpGo.instance
        .get(Api.projectCategory);
    if (categroyRes.isSuccessful && categroyRes.data != null) {
      _tabs = categroyRes.data!;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCategroyList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_tabs.isEmpty) {
      return const Center(
        widthFactor: 1,
        heightFactor: 1,
        child: CircularProgressIndicator(),
      );
    }

    _tabController ??= TabController(length: _tabs.length, vsync: this);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black87,
          tabs:
              _tabs.map((e) {
                return Tab(text: e.name);
              }).toList(),
          isScrollable: true,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            _tabs.map((e) {
              return ProjectListPage(e.id);
            }).toList(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
