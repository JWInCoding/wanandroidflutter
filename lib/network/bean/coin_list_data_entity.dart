import 'dart:convert';

import 'package:wanandroidflutter/generated/json/base/json_field.dart';
import 'package:wanandroidflutter/generated/json/coin_list_data_entigy.g.dart';

@JsonSerializable()
class CoinListDataItemEntity {
  late int id;
  late int coinCount;
  late String reason;
  late int date;

  CoinListDataItemEntity();

  factory CoinListDataItemEntity.fromJson(Map<String, dynamic> json) =>
      $CoinListDataItemEntityFromJson(json);

  Map<String, dynamic> toJson() => $CoinListDataItemEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
