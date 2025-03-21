import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import "package:dio/dio.dart";
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanandroidflutter/constants/constans.dart';
import 'package:wanandroidflutter/network/bean/AppResponse.dart';
import 'package:wanandroidflutter/user.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

Duration _connectTimeout = const Duration(seconds: 10);
Duration _receiveTimeout = const Duration(seconds: 10);
Duration _sendTimeout = const Duration(seconds: 10);

String _baseUrl = "";
List<Interceptor> _interceptors = [];

void configDio({
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

class HttpGo {
  late Dio _dio;

  static final HttpGo _singleton = HttpGo._internal();
  static HttpGo get instance => _singleton;

  CookieJar? cookieJar;

  bool _isInitialized = false;

  // 私有构造函数
  HttpGo._internal() {
    _initBase();
  }

  // 基础初始化，不包含需要异步的操作
  void _initBase() {
    _dio = Dio(
      BaseOptions(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
        baseUrl: _baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
      ),
    );

    // 缓存配置
    final options = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );
    // 添加缓存拦截器
    _dio.interceptors.add(DioCacheInterceptor(options: options));
    _dio.interceptors.addAll(_interceptors);
  }

  // 公共初始化方法，应在应用启动时调用
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // 获取文档目录
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String cookiePath = "${appDocDir.path}/.cookies/";

      // 确保目录存在
      Directory(cookiePath).createSync(recursive: true);

      // 创建持久化的CookieJar
      PersistCookieJar persistentCookies = PersistCookieJar(
        storage: FileStorage(cookiePath),
      );

      // 创建并添加CookieManager
      CookieManager cookieManager = CookieManager(persistentCookies);
      cookieJar = cookieManager.cookieJar;
      _dio.interceptors.add(cookieManager);

      Wanlog.i("Cookie管理器初始化成功: $cookiePath");
      _isInitialized = true;
    } catch (e) {
      Wanlog.e("Cookie管理器初始化失败: $e");
    }
  }

  Future<AppResponse<T>> request<T>(
    String url,
    String method, {
    Object? data,
    Map<String, dynamic>? queryParams,
    CancelToken? cancleToken,
    Options? options,
    ProgressCallback? progressCallback,
    ProgressCallback? receiveCallback,
  }) async {
    // 确保已初始化
    if (!_isInitialized) {
      await init();
    }
    AppResponse<T> result;
    try {
      Response<String> response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParams,
        cancelToken: cancleToken,
        options: (options ?? Options())..method = method,
        onSendProgress: progressCallback,
        onReceiveProgress: receiveCallback,
      );
      Map<String, dynamic> map = json.decode(response.data.toString());
      result = AppResponse.fromJson(map);
      if (result.errorCode == Constant.invalidateToken) {
        UserController.to.logout();
      }
    } on DioException catch (e) {
      Wanlog.e("请求错误 -- $e");
      result = AppResponse(Constant.otherError, e.message, null);
    }
    return result;
  }

  Future<AppResponse<T>> get<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? progressCallback,
    ProgressCallback? receiveCallback,
  }) async {
    return request(
      url,
      "GET",
      data: data,
      queryParams: queryParams,
      cancleToken: cancelToken,
      options: options,
      progressCallback: progressCallback,
      receiveCallback: receiveCallback,
    );
  }

  Future<AppResponse<T>> post<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? progressCallback,
    ProgressCallback? receiveCallback,
  }) async {
    return request(
      url,
      "POST",
      data: data,
      queryParams: queryParams,
      cancleToken: cancelToken,
      options: options,
      progressCallback: progressCallback,
      receiveCallback: receiveCallback,
    );
  }

  Future<AppResponse<T>> delete<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? progressCallback,
    ProgressCallback? receiveCallback,
  }) async {
    return request(
      url,
      "DELETE",
      data: data,
      queryParams: queryParams,
      cancleToken: cancelToken,
      options: options,
      progressCallback: progressCallback,
      receiveCallback: receiveCallback,
    );
  }

  Future<AppResponse<T>> put<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? progressCallback,
    ProgressCallback? receiveCallback,
  }) async {
    return request(
      url,
      "PUT",
      data: data,
      queryParams: queryParams,
      cancleToken: cancelToken,
      options: options,
      progressCallback: progressCallback,
      receiveCallback: receiveCallback,
    );
  }
}
