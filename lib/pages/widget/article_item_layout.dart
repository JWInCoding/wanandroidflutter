import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wanandroidflutter/network/bean/article_data_entity.dart';

class ArticleItemLayout extends StatelessWidget {
  const ArticleItemLayout({
    super.key,
    required this.itemEntity,
    required this.onCollectTap,
    this.displayCollectButton = true,
  });

  final ArticleItemEntity itemEntity;
  final void Function() onCollectTap;
  final bool displayCollectButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8), // 保留外层容器
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 8,
        margin: const EdgeInsets.all(5),
        child: Padding(
          // 为Card内容添加统一的5像素内边距
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  if (itemEntity.fresh)
                    const Text(
                      "新",
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 10,
                      ),
                    ),
                  // 移除原有的左侧内边距
                  Text(
                    itemEntity.author?.isNotEmpty == true
                        ? itemEntity.author!
                        : itemEntity.shareUser ?? "",
                  ),
                  if (itemEntity.tags.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 5), // 只保留左边距
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _getTagColor(itemEntity.tags.first),
                          width: 0.5,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        itemEntity.tags.first.name,
                        style: TextStyle(
                          color: _getTagColor(itemEntity.tags.first),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(itemEntity.niceDate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5), // 添加垂直间距
              Row(
                children: [
                  Expanded(
                    child: Html(
                      data: itemEntity.title,
                      style: {
                        "html": Style(
                          margin: Margins.zero,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: FontSize(14),
                          padding: HtmlPaddings.zero,
                          alignment: Alignment.topLeft,
                        ),
                        "body": Style(
                          margin: Margins.zero,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: FontSize(14),
                          padding: HtmlPaddings.zero,
                          alignment: Alignment.topLeft,
                        ),
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5), // 添加垂直间距
              Row(
                children: [
                  // 移除左侧内边距
                  Text(_getSource()),
                  Expanded(
                    child: Container(
                      width: 14,
                      height: 24,
                      alignment: Alignment.topRight,
                      child: Builder(
                        builder: (context) {
                          if (displayCollectButton == false) {
                            return Container();
                          }
                          return GestureDetector(
                            onTap: onCollectTap,
                            child: Icon(
                              itemEntity.collect
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.primaries.first,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSource() {
    StringBuffer sb = StringBuffer(itemEntity.superChapterName ?? "");
    if (sb.isNotEmpty &&
        itemEntity.chapterName != null &&
        itemEntity.chapterName!.isNotEmpty) {
      sb.write("•");
    }
    sb.write(itemEntity.chapterName ?? "");
    return sb.toString();
  }

  Color _getTagColor(TagEntity tag) {
    switch (tag.name) {
      case "置顶":
        return Colors.red;
      case "本站发布":
        return Colors.lightBlue;
      case "问答":
        return Colors.cyan;
      case "公众号":
        return Colors.green;
      case "项目":
        return Colors.teal;
      default:
        return Colors.primaries.first;
    }
  }
}
