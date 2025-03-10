import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/project/project_list_controller.dart';
import 'package:wanandroidflutter/pages/detail_page.dart';
import 'package:wanandroidflutter/utils/image_util.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage(this.cid, {super.key});

  final int cid;

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage>
    with BasePage<ProjectListPage>, AutomaticKeepAliveClientMixin {
  late ProjectListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      ProjectListController(widget.cid),
      tag: widget.cid.toString(),
    );
  }

  @override
  void dispose() {
    Get.delete<ProjectListController>(tag: widget.cid.toString());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      if (_controller.projectList.isEmpty) {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.hasError.value) {
          return RetryWidget(onTapRetry: _controller.refreshData);
        }
      }
      return EasyRefresh(
        controller: _controller.refreshController,
        onRefresh: _controller.refreshData,
        onLoad: _controller.loadMoreData,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: GridView.builder(
            clipBehavior: Clip.none,
            itemCount: _controller.projectList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.45,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => DetailPage(
                      _controller.projectList[index].link,
                      _controller.projectList[index].title,
                    ),
                  );
                },
                child: _generateItem(context, index),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _generateItem(BuildContext context, int index) {
    var entity = _controller.projectList[index];
    final cardTheme = Theme.of(context).cardTheme;

    return SizedBox(
      width: double.infinity,
      child: Card(
        surfaceTintColor: cardTheme.surfaceTintColor,
        color: cardTheme.color,
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: SizedBox.expand(
                    child: ImageUtil.network(
                      url: entity.envelopePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                height: 45,
                child: Html(
                  data: entity.title,
                  shrinkWrap: false,
                  style: {
                    "html": Style(
                      margin: Margins.zero,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: FontSize(12),
                      padding: HtmlPaddings.zero,
                      alignment: Alignment.topLeft,
                    ),
                    "body": Style(
                      margin: Margins.zero,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      fontSize: FontSize(12),
                      padding: HtmlPaddings.zero,
                      alignment: Alignment.topLeft,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
