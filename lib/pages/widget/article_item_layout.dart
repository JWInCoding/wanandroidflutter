import 'package:flutter/material.dart';
import 'package:wanandroidflutter/network/bean/article_data_entity.dart';

class ArticleItemLayout extends StatefulWidget {
  const ArticleItemLayout({
    super.key,
    required this.itemEntity,
    required this.onCollectTap,
    this.showCollectBtn,
  });

  final ArticleItemEntity itemEntity;

  final void Function() onCollectTap;

  final bool? showCollectBtn;

  @override
  State<ArticleItemLayout> createState() => _ArticleItemLayoutState();
}

class _ArticleItemLayoutState extends State<ArticleItemLayout> {
  @override
  void initState() {
    super.initState();
    widget.itemEntity.addListener(_onCollectChange);
  }

  @override
  void didUpdateWidget(covariant ArticleItemLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemEntity != widget.itemEntity) {
      oldWidget.itemEntity.removeListener(_onCollectChange);
      widget.itemEntity.addListener(_onCollectChange);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.itemEntity.removeListener(_onCollectChange);
  }

  _onCollectChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(widget.itemEntity.title));
  }
}
