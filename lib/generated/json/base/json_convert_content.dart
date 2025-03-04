import 'package:wanandroidflutter/network/bean/banner_entity.dart';
import 'package:wanandroidflutter/utils/log_util.dart';

JsonConvert jsonConvert = JsonConvert();
typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);
typedef EnumConvertFunction<T> = T Function(String value);
typedef ConverExceptionHandler =
    void Function(Object error, StackTrace stackTrace);

class JsonConvert {
  static ConverExceptionHandler? onError;

  static Map<String, JsonConvertFunction> get convertFuncMap => {
    (BannerEntity).toString(): BannerEntity.fromJson,
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
    if (<BannerEntity>[] is M) {
      return data
              .map<BannerEntity>(
                (Map<String, dynamic> e) => BannerEntity.fromJson(e),
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
