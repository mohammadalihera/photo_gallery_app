import 'package:json_annotation/json_annotation.dart';

import 'package:photo_gallery/core/models/photo/photo_url_model.dart';

part 'photo_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhotoModel {
  PhotoUrlModel? urls;

  PhotoModel({this.urls});

  factory PhotoModel.fromJson(Map<String, dynamic> json) => _$PhotoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoModelToJson(this);

  @override
  List<Object?> get props => [urls];
}
