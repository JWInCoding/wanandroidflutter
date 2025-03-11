import 'dart:convert';

import 'package:wanandroidflutter/generated/json/base/json_field.dart';
import 'package:wanandroidflutter/generated/json/coin_data_entity.g.dart';
import 'package:wanandroidflutter/network/bean/coin_list_data_entity.dart';

@JsonSerializable()
class CoinDataEntity {
  late List<CoinListDataItemEntity> datas;

  CoinDataEntity();

  factory CoinDataEntity.fromJson(Map<String, dynamic> json) =>
      $CoinDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $CoinDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
