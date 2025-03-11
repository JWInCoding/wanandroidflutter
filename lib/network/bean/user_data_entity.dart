import 'dart:convert';

import 'package:wanandroidflutter/generated/json/base/json_field.dart';
import 'package:wanandroidflutter/generated/json/user_data_entity.g.dart';
import 'package:wanandroidflutter/network/bean/user_coin_entity.dart';
import 'package:wanandroidflutter/network/bean/user_info_entity.dart';

@JsonSerializable()
class UserDataEntity {
  late UserCoinEntity coinInfo;
  late UserInfoEntity userInfo;

  UserDataEntity();

  factory UserDataEntity.fromJson(Map<String, dynamic> json) =>
      $UserDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
