// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoUrlModel _$PhotoUrlModelFromJson(Map<String, dynamic> json) =>
    PhotoUrlModel(
      raw: json['raw'] as String?,
      full: json['full'] as String?,
      regular: json['regular'] as String?,
    );

Map<String, dynamic> _$PhotoUrlModelToJson(PhotoUrlModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('raw', instance.raw);
  writeNotNull('full', instance.full);
  writeNotNull('regular', instance.regular);
  return val;
}
