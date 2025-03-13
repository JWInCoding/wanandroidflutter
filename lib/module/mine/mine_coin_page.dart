import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wanandroidflutter/base/base_page.dart';
import 'package:wanandroidflutter/module/mine/mine_coin_controller.dart';

class MineCoinPage extends StatefulWidget {
  const MineCoinPage({super.key});

  @override
  State<MineCoinPage> createState() => _MineCoinPageState();
}

class _MineCoinPageState extends State<MineCoinPage>
    with BasePage<MineCoinPage> {
  final _controller = Get.put(MineCoinController());

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('我的积分'), scrolledUnderElevation: 0),
      body: Column(
        children: [
          // 蓝色区域容器
          Container(
            color: appBarTheme.backgroundColor,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Obx(
                () => Text(
                  _controller.coinCount.value,
                  style: textTheme.bodyLarge?.copyWith(
                    color: appBarTheme.foregroundColor,
                    fontSize: 44,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // 列表区域
          Expanded(
            child: Obx(() {
              if (_controller.coinList.isEmpty) {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_controller.hasError.value) {
                  return RetryWidget(onTapRetry: _controller.refreshData);
                }
                return EmptyWidget();
              }
              return EasyRefresh.builder(
                controller: _controller.refreshController,
                onRefresh: _controller.refreshData,
                onLoad: _controller.loadMoreData,
                childBuilder:
                    (context, physics) => ListView.separated(
                      physics: physics,
                      padding: EdgeInsets.zero,
                      itemCount: _controller.coinList.length,
                      itemBuilder: (context, index) {
                        return _buildItem(context, index);
                      },
                      //分割线
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 1,
                          thickness: 0.5,
                          indent: 16,
                          endIndent: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.6),
                        );
                      },
                    ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = _controller.coinList[index];

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.reason, style: textTheme.titleMedium),
              SizedBox(height: 5),
              Text(
                _formatTimestamp(item.date),
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            "+${item.coinCount.toString()}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    // 判断时间戳长度，确定是秒还是毫秒
    final DateTime dateTime =
        timestamp.toString().length > 10
            ? DateTime.fromMillisecondsSinceEpoch(timestamp)
            : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }
}
