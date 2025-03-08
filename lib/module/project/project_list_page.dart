import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/project_list_data_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
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
  var _currentPageIndex = 1;

  List<ProjectListDataItemEntity> data = [];

  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    _getProjectListData();
  }

  _getProjectListData() async {
    AppResponse<ProjectListDataEntity> res = await HttpGo.instance.get(
      "${Api.projectList}$_currentPageIndex/json",
      queryParams: {"cid": widget.cid},
    );

    if (_currentPageIndex == 1) {
      data.clear();
      _refreshController.finishRefresh();
    } else {
      _refreshController.finishLoad();
    }

    if (res.isSuccessful) {
      setState(() {
        data.addAll(res.data!.datas);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return EasyRefresh.builder(
      controller: _refreshController,
      onRefresh: () {
        _currentPageIndex = 1;
        _getProjectListData();
      },
      onLoad: () {
        _currentPageIndex++;
        _getProjectListData();
      },
      childBuilder: (context, physics) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: GridView.builder(
            clipBehavior: Clip.none,
            physics: physics,
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.45,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => DetailPage(data[index].link, data[index].title));
                },
                child: _generateItem(context, index),
              );
            },
          ),
        );
      },
    );
  }

  Widget _generateItem(BuildContext context, int index) {
    var entity = data[index];
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
