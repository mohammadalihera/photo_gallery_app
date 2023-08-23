import 'package:json_annotation/json_annotation.dart';

part 'photo_url_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhotoUrlModel {
  String? raw;
  String? full;
  String? regular;

  PhotoUrlModel({this.raw, this.full, this.regular});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'raw': raw, 'full': full, 'regular': regular};
  }

  factory PhotoUrlModel.fromMap(Map<String, dynamic> map) {
    return PhotoUrlModel(raw: map['raw'] as String, full: map['full'] as String, regular: map['regular'] as String);
  }

  factory PhotoUrlModel.fromJson(Map<String, dynamic> json) => _$PhotoUrlModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoUrlModelToJson(this);

  @override
  String toString() => 'PhotoUrlModel(raw:$raw, full: $full, regular: $regular)';
}
