class JsonSerializable {
  const JsonSerializable();
}

class JsonField {
  final String? name;

  final bool? serialize;

  final bool? deserialize;

  final bool? isEnum;

  const JsonField({this.name, this.serialize, this.deserialize, this.isEnum});
}
