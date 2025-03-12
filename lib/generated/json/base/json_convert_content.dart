import 'package:wanandroidflutter/network/bean/article_data_entity.dart';
import 'package:wanandroidflutter/network/bean/banner_entity.dart';
import 'package:wanandroidflutter/network/bean/coin_data_entity.dart';
import 'package:wanandroidflutter/network/bean/coin_list_data_entity.dart';
import 'package:wanandroidflutter/network/bean/hot_keyword_entity.dart';
import 'package:wanandroidflutter/network/bean/project_category_entity.dart';
import 'package:wanandroidflutter/network/bean/project_list_data_entity.dart';
import 'package:wanandroidflutter/network/bean/tree_list_data_entity.dart';
import 'package:wanandroidflutter/network/bean/user_coin_entity.dart';
import 'package:wanandroidflutter/network/bean/user_data_entity.dart';
import 'package:wanandroidflutter/network/bean/user_info_entity.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

JsonConvert jsonConvert = JsonConvert();
typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);
typedef EnumConvertFunction<T> = T Function(String value);
typedef ConverExceptionHandler =
    void Function(Object error, StackTrace stackTrace);

class JsonConvert {
  static ConverExceptionHandler? onError;

  static Map<String, JsonConvertFunction> get convertFuncMap => {
    (ArticleDataEntity).toString(): ArticleDataEntity.fromJson,
    (ArticleItemEntity).toString(): ArticleItemEntity.fromJson,
    (BannerEntity).toString(): BannerEntity.fromJson,
    (HotKeywordEntity).toString(): HotKeywordEntity.fromJson,
    (UserDataEntity).toString(): UserDataEntity.fromJson,
    (UserInfoEntity).toString(): UserInfoEntity.fromJson,
    (UserCoinEntity).toString(): UserCoinEntity.fromJson,
    (ProjectCategoryEntity).toString(): ProjectCategoryEntity.fromJson,
    (ProjectListDataEntity).toString(): ProjectListDataEntity.fromJson,
    (ProjectListDataItemEntity).toString(): ProjectListDataItemEntity.fromJson,
    (ProjectListDataDatasTags).toString(): ProjectListDataDatasTags.fromJson,
    (TreeListDataEntity).toString(): TreeListDataEntity.fromJson,
    (CoinDataEntity).toString(): CoinDataEntity.fromJson,
    (CoinListDataItemEntity).toString(): CoinListDataItemEntity.fromJson,
  };

  T? convert<T>(dynamic value, {EnumConvertFunction? enumConvert}) {
    if (value == null) {
      return null;
    }
    if (value is T) {
      return value;
    }
    try {
      return _asT<T>(value, enumConvert: enumConvert);
    } catch (e, stackTrace) {
      if (onError != null) {
        onError!(e, stackTrace);
        Wanlog.e(e.toString());
      }
      return null;
    }
  }

  List<T?>? convertList<T>(
    List<dynamic>? value, {
    EnumConvertFunction? enumConvert,
  }) {
    if (value == null) {
      return null;
    }
    try {
      return value
          .map((dynamic e) => _asT<T>(e, enumConvert: enumConvert))
          .toList();
    } catch (e, stackTrace) {
      if (onError != null) {
        onError!(e, stackTrace);
        Wanlog.e(e.toString());
      }
      return <T>[];
    }
  }

  List<T>? convertListNotNull<T>(
    dynamic value, {
    EnumConvertFunction? enumConvert,
  }) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>)
          .map((dynamic e) => _asT<T>(e, enumConvert: enumConvert)!)
          .toList();
    } catch (e, stackTrace) {
      if (onError != null) {
        onError!(e, stackTrace);
        Wanlog.e(e.toString());
      }
      return <T>[];
    }
  }

  T? _asT<T extends Object?>(
    dynamic value, {
    EnumConvertFunction? enumConvert,
  }) {
    final String type = T.toString();
    final String values = value.toString();

    if (enumConvert != null) {
      return enumConvert(values) as T;
    } else if (type == "String") {
      return values as T;
    } else if (type == "int") {
      final int? intValue = int.tryParse(values);
      if (intValue == null) {
        return double.tryParse(values)?.toInt() as T;
      } else {
        return intValue as T;
      }
    } else if (type == "double") {
      return double.tryParse(values) as T;
    } else if (type == "DateTime") {
      return DateTime.parse(values) as T;
    } else if (type == "bool") {
      if (value == null || values == 'null') {
        return false as T; // 转换为泛型 T
      }
      if (values == '0' || values == '1') {
        return (values == '1') as T;
      }
      return (values == 'true') as T;
    } else if (type == "Map" || type.startsWith("Map<")) {
      return value as T;
    } else {
      if (convertFuncMap.containsKey(type)) {
        if (value == null) {
          return null;
        }
        return convertFuncMap[type]!(Map<String, dynamic>.from(value)) as T;
      } else {
        throw UnimplementedError('$type unimplemented');
      }
    }
  }

  static M? _getListChildType<M>(List<Map<String, dynamic>> data) {
    if (<ArticleDataEntity>[] is M) {
      return data
              .map<ArticleDataEntity>(
                (Map<String, dynamic> e) => ArticleDataEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<ArticleItemEntity>[] is M) {
      return data
              .map<ArticleItemEntity>(
                (Map<String, dynamic> e) => ArticleItemEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<BannerEntity>[] is M) {
      return data
              .map<BannerEntity>(
                (Map<String, dynamic> e) => BannerEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<HotKeywordEntity>[] is M) {
      return data
              .map<HotKeywordEntity>(
                (Map<String, dynamic> e) => HotKeywordEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<UserInfoEntity>[] is M) {
      return data
              .map<UserInfoEntity>(
                (Map<String, dynamic> e) => UserInfoEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<UserDataEntity>[] is M) {
      return data
              .map<UserDataEntity>(
                (Map<String, dynamic> e) => UserDataEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<UserInfoEntity>[] is M) {
      return data
              .map<UserInfoEntity>(
                (Map<String, dynamic> e) => UserInfoEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<UserCoinEntity>[] is M) {
      return data
              .map<UserCoinEntity>(
                (Map<String, dynamic> e) => UserCoinEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<ProjectCategoryEntity>[] is M) {
      return data
              .map<ProjectCategoryEntity>(
                (Map<String, dynamic> e) => ProjectCategoryEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<ProjectListDataEntity>[] is M) {
      return data
              .map<ProjectListDataEntity>(
                (Map<String, dynamic> e) => ProjectListDataEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<ProjectListDataItemEntity>[] is M) {
      return data
              .map<ProjectListDataItemEntity>(
                (Map<String, dynamic> e) =>
                    ProjectListDataItemEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<ProjectListDataDatasTags>[] is M) {
      return data
              .map<ProjectListDataDatasTags>(
                (Map<String, dynamic> e) =>
                    ProjectListDataDatasTags.fromJson(e),
              )
              .toList()
          as M;
    }
    if (<TreeListDataEntity>[] is M) {
      return data
              .map<TreeListDataEntity>(
                (Map<String, dynamic> e) => TreeListDataEntity.fromJson(e),
              )
              .toList()
          as M;
    }
    return null;
  }

  static M? fromJsonAsT<M>(dynamic json) {
    if (json is M) {
      return json;
    }
    if (json is List) {
      return _getListChildType<M>(
        json.map((e) => e as Map<String, dynamic>).toList(),
      );
    } else {
      return jsonConvert.convert<M>(json);
    }
  }
}
