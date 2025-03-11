import 'dart:convert';

import 'package:wanandroidflutter/generated/json/base/json_field.dart';
import 'package:wanandroidflutter/generated/json/tree_list_data_entity.g.dart';

@JsonSerializable()
class TreeListDataEntity {
  late List<TreeListDataEntity> children;
  late int courseId;
  late int id;
  late String name;
  late int order;
  late int parentChapterId;
  late int visible;

  TreeListDataEntity();

  factory TreeListDataEntity.fromJson(Map<String, dynamic> json) =>
      $TreeListDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $TreeListDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
