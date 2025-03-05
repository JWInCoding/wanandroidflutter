import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mmkv/mmkv.dart';
import 'package:wanandroidflutter/network/bean/user_info_entity.dart';
import 'package:wanandroidflutter/network/request_util.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

typedef LoginStatusChangeCallback = void Function();

class User extends ChangeNotifier {
  static const String _userInfoKey = "userInfo";

  User._internal();

  static final User _singleton = User._internal();

  factory User() => _singleton;

  UserInfoEntity? _userInfoEntity;

  bool isLoggedIn() => _userInfoEntity != null;

  String get userName => _userInfoEntity!.username;

  int get userCoinCount => _userInfoEntity!.coinCount;

  final List<LoginStatusChangeCallback> _list = [];

  on(LoginStatusChangeCallback loginStatusChange) {
    _list.add(loginStatusChange);
  }

  off(LoginStatusChangeCallback loginStatusChange) {
    _list.remove(loginStatusChange);
  }

  loadFromLocal() {
    try {
      MMKV mmkv = MMKV.defaultMMKV();
      String? infoContent = mmkv.decodeString(_userInfoKey);
      if (infoContent == null || infoContent.isEmpty) {
        return;
      }
      _userInfoEntity = UserInfoEntity.fromJson(
        json.decoder.convert(infoContent),
      );
    } catch (e) {
      Wanlog.e("获取本地用户信息失败 $e");
    }
  }

  loginSuccess(UserInfoEntity userInfoEntity) {
    _userInfoEntity = userInfoEntity;
    try {
      MMKV mmkv = MMKV.defaultMMKV();
      String infoContent = _userInfoEntity.toString();
      mmkv.encodeString(_userInfoKey, infoContent);
    } catch (e) {
      Wanlog.e("保存用户信息失败 $e");
    }
  }

  logout() {
    _userInfoEntity = null;
    HttpGo.instance.cookieJar?.deleteAll();
    try {
      MMKV mmkv = MMKV.defaultMMKV();
      mmkv.encodeString(_userInfoKey, null);
    } catch (e) {
      Wanlog.e("退出登录删除用户信息失败 $e");
    }

    notifyListeners();
    for (var callback in _list) {
      callback();
    }
  }
}
