import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/search/search_result_page.dart';
import 'package:wanandroidflutter/network/api.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/network/bean/hot_keyword_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with BasePage<SearchPage> {
  static const String historyKey = 'historykey';

  List<String> histories = [];

  List<HotKeywordEntity> hotKeywords = [];

  final List<Color> _keywordsColors = [
    const Color(0xffe35454),
    const Color(0xff549A3A),
    const Color(0xff34856E),
    const Color(0xffB59B42),
    const Color(0xff9B4BAA),
    const Color(0xff4966B1),
  ];

  @override
  void initState() {
    super.initState();

    try {
      var mmkv = MMKV.defaultMMKV();
      String historyContent = mmkv.decodeString(historyKey) ?? "";
      if (historyContent.trim().isNotEmpty) {
        histories.addAll(
          (json.decoder.convert(historyContent) as List<dynamic>).map(
            (e) => e as String,
          ),
        );
      }
    } catch (e) {
      Wanlog.e("加载搜索记录失败 - ${e.toString()}");
    }
    _getHotkeywords();
  }

  @override
  void dispose() {
    super.dispose();
    _saveHistoryToLocal();
  }

  _getHotkeywords() async {
    AppResponse<List<HotKeywordEntity>> res = await HttpGo.instance.get(
      Api.hotKeywords,
    );

    if (res.isSuccessful) {
      setState(() {
        hotKeywords.clear();
        hotKeywords.addAll(res.data!);
      });
    }
  }

  _saveHistoryToLocal() {
    try {
      var mmkv = MMKV.defaultMMKV();
      String historyContent = json.encoder.convert(histories);
      mmkv.encodeString(historyKey, historyContent);
    } catch (e) {
      Wanlog.e("保存搜索记录失败 - ${e.toString()}");
    }
  }

  _onSearch(String content) {
    setState(() {
      if (histories.contains(content)) {
        histories.remove(content);
      }
      histories.insert(0, content);
    });
    // 跳转搜索结果页
    Get.to(() => SearchResultPage(keyword: content));
  }

  _deleteHistory(int index) {
    setState(() {
      histories.removeAt(index);
    });
  }

  _onClearClick() async {
    bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确定要清除所有搜索记录吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back<bool>(result: false);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('确定', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (result) {
      setState(() {
        histories.clear();
        _saveHistoryToLocal();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: appbarTheme.backgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: MySearchBar(onSubmit: _onSearch),
        ),
        iconTheme: IconThemeData(color: appbarTheme.foregroundColor),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: Wrap(
                direction: Axis.horizontal,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                spacing: 10,
                runAlignment: WrapAlignment.center,
                children: List.generate(hotKeywords.length, (index) {
                  return GestureDetector(
                    onTap: () => _onSearch(hotKeywords[index].name),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            _keywordsColors[index % (_keywordsColors.length)],
                      ),
                      child: Text(
                        hotKeywords[index].name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('搜索记录', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _onClearClick,
                      child: const Text('清空'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              margin: const EdgeInsets.only(top: 5),
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: histories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onSearch(histories[index]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(histories[index]),
                          Expanded(
                            child: GestureDetector(
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.close),
                              ),
                              onTap: () => _deleteHistory(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key, required this.onSubmit});

  final void Function(String) onSubmit;

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    final appbarTheme = Theme.of(context).appBarTheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.5),
        color: appbarTheme.foregroundColor,
      ),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        autofocus: true,
        decoration: InputDecoration(
          isDense: true,
          hintText: '搜索',
          hintStyle: TextStyle(
            color: textTheme.titleSmall?.color,
            fontSize: 14,
          ),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.search, size: 20),
          suffixIconColor: textTheme.titleSmall?.color,
        ),
        onSubmitted: (value) {
          widget.onSubmit(value);
        },
      ),
    );
  }
}
