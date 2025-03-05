import 'dart:convert';

import 'package:get/get.dart';
import 'package:mmkv/mmkv.dart';
import 'package:wanandroidflutter/network/bean/user_info_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

class UserController extends GetxController {
  static const String _userInfoKey = "userInfo";
  // 使用 Rx 变量代替普通变量
  final Rx<UserInfoEntity?> _userInfo = Rx<UserInfoEntity?>(null);

  final RxBool _isLoggedIn = false.obs;

  // 提供 getter 方法
  UserInfoEntity? get userInfo => _userInfo.value;
  RxBool get isLoggedIn => _isLoggedIn;
  String get userName => _userInfo.value?.username ?? "";
  int get userCoinCount => _userInfo.value?.coinCount ?? 0;

  // 实现单例模式 (GetX 已内置支持单例)
  static UserController get to => Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    loadFromLocal();
  }

  loadFromLocal() {
    try {
      MMKV mmkv = MMKV.defaultMMKV();
      String? infoContent = mmkv.decodeString(_userInfoKey);
      if (infoContent == null || infoContent.isEmpty) {
        _isLoggedIn.value = false;
        return;
      }
      _userInfo.value = UserInfoEntity.fromJson(
        json.decoder.convert(infoContent),
      );
      _isLoggedIn.value = true;
    } catch (e) {
      Wanlog.e("获取本地用户信息失败 $e");
    }
  }

  loginSuccess(UserInfoEntity userInfoEntity) {
    _userInfo.value = userInfoEntity;
    _isLoggedIn.value = true;
    try {
      MMKV mmkv = MMKV.defaultMMKV();
      String infoContent = userInfoEntity.toString();
      mmkv.encodeString(_userInfoKey, infoContent);
    } catch (e) {
      Wanlog.e("保存用户信息失败 $e");
    }
    update();
  }

  logout() {
    _userInfo.value = null;
    _isLoggedIn.value = false;
    HttpGo.instance.cookieJar?.deleteAll();
    try {
      MMKV mmkv = MMKV.defaultMMKV();
      mmkv.encodeString(_userInfoKey, null);
    } catch (e) {
      Wanlog.e("退出登录删除用户信息失败 $e");
    }
    update(); // 通知所有使用GetBuilder的UI更新
  }
}
