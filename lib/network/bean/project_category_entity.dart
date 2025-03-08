import 'dart:convert';

import 'package:wanandroidflutter/generated/json/base/json_field.dart';
import 'package:wanandroidflutter/generated/json/project_category_entity.g.dart';

@JsonSerializable()
class ProjectCategoryEntity {
  late int courseId;
  late int id;
  late String name;
  late int order;
  late int parentChapterId;
  late int visible;

  ProjectCategoryEntity();

  factory ProjectCategoryEntity.fromJson(Map<String, dynamic> json) =>
      $ProjectCategoryEntityFromJson(json);

  Map<String, dynamic> toJson() => $ProjectCategoryEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
