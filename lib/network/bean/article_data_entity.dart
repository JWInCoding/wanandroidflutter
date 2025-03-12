import 'dart:convert';

import 'package:get/get.dart';
import 'package:wanandroidflutter/generated/json/article_data_entity.g.dart';
import 'package:wanandroidflutter/generated/json/base/json_field.dart';

@JsonSerializable()
class ArticleDataEntity {
  late int curPage;
  late List<ArticleItemEntity> datas;
  late int offset;
  late bool over;
  late int pageCount;
  late int size;
  late int total;

  ArticleDataEntity();

  factory ArticleDataEntity.fromJson(Map<String, dynamic> json) =>
      $ArticleDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $ArticleDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class ArticleItemEntity {
  late bool adminAdd;
  late String apkLink;
  late int audit;
  late String? author;
  late bool canEdit;
  late int chapterId;
  late String? chapterName;

  // 使用 GetX 的响应式变量
  final Rx<bool> _collect = false.obs;
  // 保持原有的 getter/setter 接口以保证 JSON 序列化的兼容性
  set collect(bool value) => _collect.value = value;
  bool get collect => _collect.value;

  late int courseId;
  late String desc;
  late String descMd;
  late String envelopePic;
  bool fresh = false;
  late String host;
  late int id;
  late bool isAdminAdd;
  late String link;
  late String niceDate;
  late String niceShareDate;
  late String origin;
  late String prefix;
  late String projectLink;
  late int publishTime;
  late int realSuperChapterId;
  late int selfVisible;
  late int shareDate;
  String? shareUser;
  late int superChapterId;
  String? superChapterName;
  late List<TagEntity> tags;
  late String title;
  int? type;
  late int userId;
  late int visible;
  late int zan;

  ArticleItemEntity();

  factory ArticleItemEntity.fromJson(Map<String, dynamic> json) {
    var entity = $ArticleItemEntityFromJson(json);
    // 确保 collect 属性被正确设置为响应式变量
    if (json['collect'] != null) {
      entity.collect = json['collect'] as bool;
    }
    return entity;
  }

  Map<String, dynamic> toJson() {
    var json = $ArticleItemEntityToJson(this);
    // 确保 collect 值被正确序列化
    json['collect'] = collect;
    return json;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  // 为了在列表中方便比较和更新，添加 == 和 hashCode
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleItemEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // 添加 copyWith 方法便于创建新实例
  ArticleItemEntity copyWith({
    bool? adminAdd,
    String? apkLink,
    int? audit,
    String? author,
    bool? canEdit,
    int? chapterId,
    String? chapterName,
    bool? collect,
    int? courseId,
    String? desc,
    String? descMd,
    String? envelopePic,
    bool? fresh,
    String? host,
    int? id,
    bool? isAdminAdd,
    String? link,
    String? niceDate,
    String? niceShareDate,
    String? origin,
    String? prefix,
    String? projectLink,
    int? publishTime,
    int? realSuperChapterId,
    int? selfVisible,
    int? shareDate,
    String? shareUser,
    int? superChapterId,
    String? superChapterName,
    List<TagEntity>? tags,
    String? title,
    int? type,
    int? userId,
    int? visible,
    int? zan,
  }) {
    final newArticle = ArticleItemEntity();
    newArticle.adminAdd = adminAdd ?? this.adminAdd;
    newArticle.apkLink = apkLink ?? this.apkLink;
    newArticle.audit = audit ?? this.audit;
    newArticle.author = author ?? this.author;
    newArticle.canEdit = canEdit ?? this.canEdit;
    newArticle.chapterId = chapterId ?? this.chapterId;
    newArticle.chapterName = chapterName ?? this.chapterName;
    newArticle.collect = collect ?? this.collect;
    newArticle.courseId = courseId ?? this.courseId;
    newArticle.desc = desc ?? this.desc;
    newArticle.descMd = descMd ?? this.descMd;
    newArticle.envelopePic = envelopePic ?? this.envelopePic;
    newArticle.fresh = fresh ?? this.fresh;
    newArticle.host = host ?? this.host;
    newArticle.id = id ?? this.id;
    newArticle.isAdminAdd = isAdminAdd ?? this.isAdminAdd;
    newArticle.link = link ?? this.link;
    newArticle.niceDate = niceDate ?? this.niceDate;
    newArticle.niceShareDate = niceShareDate ?? this.niceShareDate;
    newArticle.origin = origin ?? this.origin;
    newArticle.prefix = prefix ?? this.prefix;
    newArticle.projectLink = projectLink ?? this.projectLink;
    newArticle.publishTime = publishTime ?? this.publishTime;
    newArticle.realSuperChapterId =
        realSuperChapterId ?? this.realSuperChapterId;
    newArticle.selfVisible = selfVisible ?? this.selfVisible;
    newArticle.shareDate = shareDate ?? this.shareDate;
    newArticle.shareUser = shareUser ?? this.shareUser;
    newArticle.superChapterId = superChapterId ?? this.superChapterId;
    newArticle.superChapterName = superChapterName ?? this.superChapterName;
    newArticle.tags = tags ?? List.from(this.tags);
    newArticle.title = title ?? this.title;
    newArticle.type = type ?? this.type;
    newArticle.userId = userId ?? this.userId;
    newArticle.visible = visible ?? this.visible;
    newArticle.zan = zan ?? this.zan;
    return newArticle;
  }
}

@JsonSerializable()
class TagEntity {
  String name = "";
  String url = "";

  TagEntity({this.name = "", this.url = ""});

  factory TagEntity.fromJson(Map<String, dynamic> json) {
    return TagEntity(
      name: json['name'] as String? ?? "",
      url: json['url'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'url': url};

  @override
  String toString() {
    return jsonEncode(this);
  }

  TagEntity copyWith({String? name, String? url}) {
    return TagEntity(name: name ?? this.name, url: url ?? this.url);
  }
}
