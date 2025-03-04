import 'dart:async';

import 'package:flutter/cupertino.dart';

/// 全局错误处理函数，用于捕获并处理应用中的各类异常
void handleError(void Function() body) {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  // 在一个有错误处理能力的 Zone 中运行应用
  runZonedGuarded(body, (error, stack) async {
    await reportError(error, stack);
  });
}

/// 上报错误信息到远程服务器或日志系统
Future<void> reportError(Object error, StackTrace stack) async {
  // 上传报错信息
}
