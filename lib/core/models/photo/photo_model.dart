import 'package:json_annotation/json_annotation.dart';

import 'package:photo_gallery/core/models/photo/photo_url_model.dart';

part 'photo_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhotoModel {
  PhotoUrlModel? urls;

  PhotoModel({this.urls});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'urls': urls};
  }

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    return PhotoModel(urls: map['urls'] as PhotoUrlModel);
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) => _$PhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);

  @override
  String toString() => 'PhotoModel(urls:$urls)';
}
