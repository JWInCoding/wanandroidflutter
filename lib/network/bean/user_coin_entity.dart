import 'dart:convert';

import 'package:wanandroidflutter/generated/json/base/json_field.dart';
import 'package:wanandroidflutter/generated/json/user_coin_entity.g.dart';

@JsonSerializable()
class UserCoinEntity {
  late int coinCount;
  late int level;
  late int rank;
  late int userId;
  late String username;

  UserCoinEntity();

  factory UserCoinEntity.fromJson(Map<String, dynamic> json) =>
      $UserCoinEntityFromJson(json);

  Map<String, dynamic> toJson() => $UserCoinEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
