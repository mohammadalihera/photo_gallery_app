// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoModel _$PhotoModelFromJson(Map<String, dynamic> json) => PhotoModel(
      urls: json['urls'] == null
          ? null
          : PhotoUrlModel.fromJson(json['urls'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PhotoModelToJson(PhotoModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('urls', instance.urls);
  return val;
}
