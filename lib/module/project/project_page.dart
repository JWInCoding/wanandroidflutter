import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
          appBar: _buildAppBar(context),
          body: const Center(child: CircularProgressIndicator()),
        );
      } else if (_controller.hasError.value) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: RetryWidget(onTapRetry: _controller.getCategoryList),
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

        final colorScheme = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: _buildAppBar(
            context,
            bottom: ColoredTabBar(
              color: colorScheme.background,
              tabBar: TabBar(
                labelColor: colorScheme.primary,
                unselectedLabelColor: Colors.grey[800],
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                dividerHeight: 0,
                tabs: _controller.tabs.map((e) => Tab(text: e.name)).toList(),
                isScrollable: true,
                controller: _tabController,
              ),
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

  // 提取公共的 AppBar 逻辑
  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    PreferredSizeWidget? bottom,
  }) {
    final appBarColorScheme = Theme.of(context).appBarTheme;

    return AppBar(
      backgroundColor: appBarColorScheme.backgroundColor,
      foregroundColor: appBarColorScheme.foregroundColor,
      elevation: 0,
      title: const Text('项目'),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Fluttertoast.showToast(msg: '搜索功能开发中');
          },
          icon: Icon(Icons.search, color: appBarColorScheme.foregroundColor),
          tooltip: '搜索',
        ),
      ],
      bottom: bottom,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ColoredTabBar extends ColoredBox implements PreferredSizeWidget {
  const ColoredTabBar({super.key, required super.color, required this.tabBar})
    : super(child: tabBar);

  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;
}
