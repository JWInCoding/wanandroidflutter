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
    String publishTime =
        DateTime.fromMillisecondsSinceEpoch(itemEntity.publishTime).toString();
    publishTime = publishTime.substring(0, publishTime.length - 4);
    StringBuffer sb = StringBuffer(itemEntity.superChapterName ?? "");
    if (sb.isNotEmpty &&
        itemEntity.chapterName != null &&
        itemEntity.chapterName!.isNotEmpty) {
      sb.write("•");
    }
    sb.write(itemEntity.chapterName ?? "");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        elevation: 8,
        child: Column(
          children: [
            Row(
              children: [
                if (itemEntity.type == 1)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text("置顶", style: TextStyle(color: Colors.red)),
                  ),
                Container(
                  padding:
                      itemEntity.type == 1
                          ? const EdgeInsets.fromLTRB(8, 0, 0, 0)
                          : const EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: Text(
                    itemEntity.author?.isNotEmpty == true
                        ? itemEntity.author!
                        : itemEntity.shareUser ?? "",
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 8),
                    alignment: Alignment.centerRight,
                    child: Text(publishTime),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
              child: Row(
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
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(sb.toString()),
                ),
                Expanded(
                  child: Container(
                    width: 14,
                    height: 24,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 8),
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
    );
  }
}
