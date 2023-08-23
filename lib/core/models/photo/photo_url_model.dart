import 'package:json_annotation/json_annotation.dart';

part 'photo_url_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhotoUrlModel {
  String? raw;
  String? full;
  String? regular;

  PhotoUrlModel({this.raw, this.full, this.regular});

  factory PhotoUrlModel.fromJson(Map<String, dynamic> json) => _$PhotoUrlModelFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoUrlModelToJson(this);

  @override
  List<Object?> get props => [raw, full, regular];
}
