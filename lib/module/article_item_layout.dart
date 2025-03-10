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
    // 获取当前主题
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // 定义深浅模式下的颜色
    final cardColor = isDarkMode ? theme.colorScheme.surface : Colors.white;
    final cardShadowColor = isDarkMode ? Colors.black54 : Colors.black12;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        // 使用主题相关颜色
        surfaceTintColor: cardColor,
        color: cardColor,
        shadowColor: cardShadowColor,
        elevation: 8,
        margin: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (itemEntity.fresh)
                          Container(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text(
                              "新",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        Text(
                          itemEntity.author?.isNotEmpty == true
                              ? itemEntity.author!
                              : itemEntity.shareUser ?? "",
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        const SizedBox(width: 5),
                        if (itemEntity.tags.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: _buildTagWidgets(
                                  itemEntity.tags,
                                  theme,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    itemEntity.niceDate,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
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
                          // 使用主题的文本颜色
                          color: theme.colorScheme.onSurface,
                        ),
                        "body": Style(
                          margin: Margins.zero,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: FontSize(14),
                          padding: HtmlPaddings.zero,
                          alignment: Alignment.topLeft,
                          // 使用主题的文本颜色
                          color: theme.colorScheme.onSurface,
                        ),
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    _getSource(),
                    // 使用主题的次要文本颜色
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
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
                              // 使用主题的主色
                              color: Colors.redAccent,
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

  List<Widget> _buildTagWidgets(List<TagEntity> tags, ThemeData theme) {
    return tags.map((tag) {
      return Container(
        margin: const EdgeInsets.only(right: 5),
        // 调整水平内边距稍大一些，确保文本有足够空间
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: _getTagColor(tag, theme), width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        // 使用固定高度确保一致的垂直空间
        height: 18,
        // 添加居中对齐
        alignment: Alignment.center,
        child: Text(
          tag.name,
          style: TextStyle(
            color: _getTagColor(tag, theme),
            fontSize: 10,
            // 添加行高设置以解决基线问题
            height: 1.0,
            // 确保文字在基线上对齐
            textBaseline: TextBaseline.alphabetic,
          ),
          // 添加文本对齐设置
          textAlign: TextAlign.center,
        ),
      );
    }).toList();
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

  // 修改为接收theme参数
  Color _getTagColor(TagEntity tag, ThemeData theme) {
    // 在深色模式下调整标签颜色
    final isDark = theme.brightness == Brightness.dark;

    switch (tag.name) {
      case "置顶":
        return isDark ? Colors.redAccent : Colors.red;
      case "本站发布":
        return isDark ? Colors.lightBlueAccent : Colors.lightBlue;
      case "问答":
        return isDark ? Colors.cyanAccent : Colors.cyan;
      case "公众号":
        return isDark ? Colors.lightGreenAccent : Colors.green;
      case "项目":
        return isDark ? Colors.tealAccent : Colors.teal;
      default:
        return theme.colorScheme.primary;
    }
  }
}
