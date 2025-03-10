import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/project/project_controller.dart';
import 'package:wanandroidflutter/module/project/project_list_page.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with
        BasePage<ProjectPage>,
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin {
  final ProjectController _controller = Get.put(ProjectController());

  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (_controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: const Center(child: CircularProgressIndicator()),
        );
      } else {
        if (_tabController == null ||
            _tabController!.length != _controller.tabs.length) {
          _tabController?.dispose();
          _tabController = TabController(
            length: _controller.tabs.length,
            vsync: this,
          );
        }
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: TabBar(
              labelColor: Theme.of(context).appBarTheme.foregroundColor,
              unselectedLabelColor: Colors.grey[800],
              indicatorColor: Theme.of(context).appBarTheme.foregroundColor,
              dividerHeight: 0,
              tabs: _controller.tabs.map((e) => Tab(text: e.name)).toList(),
              isScrollable: true,
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children:
                _controller.tabs.map((e) => ProjectListPage(e.id)).toList(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
