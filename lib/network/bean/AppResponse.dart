import 'package:wanandroidflutter/constants/constans.dart';
import 'package:wanandroidflutter/generated/json/base/json_convert_content.dart';

class Appresponse<T> {
  int errorCode = -1;
  String? errorMsg;
  T? data;

  Appresponse(this.errorCode, this.errorMsg, this.data);

  Appresponse.fromJson(Map<String, dynamic> map) {
    errorCode = (map['errorCode'] as int?) ?? -1;
    errorMsg = map['errorMsg'] as String?;
    if (map.containsKey('data')) {
      data = _generateOBJ(map['data']);
    }
  }

  T? _generateOBJ<O>(Object? json) {
    if (json == null) {
      return null;
    }
    if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    } else {
      return JsonConvert.fromJsonAsT<T>(json);
    }
  }

  bool get isSuccessful => errorCode == Constant.successCode;
}
