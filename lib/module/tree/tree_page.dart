import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/tree/tree_list_page.dart';
import 'package:wanandroidflutter/module/tree/tree_page_controller.dart';

class TreePage extends StatefulWidget {
  const TreePage({super.key});

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage>
    with BasePage<TreePage>, AutomaticKeepAliveClientMixin {
  final TreePageController _controller = Get.put(TreePageController());

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
          body: RetryWidget(onTapRetry: _controller.getTreeData),
        );
      } else {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildListView(context),
        );
      }
    });
  }

  Widget _buildListView(BuildContext context) {
    final cardScheme = Theme.of(context).cardTheme;
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _controller.treeList.length,
      itemBuilder: (context, index) {
        final tree = _controller.treeList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                tree.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  tree.children.map((childTree) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: cardScheme.surfaceTintColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        child: Text(
                          childTree.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          Get.to(
                            () => TreeListPage(childTree.id, childTree.name),
                          );
                        },
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
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
      title: const Text('体系'),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
