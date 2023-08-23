import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:photo_gallery/core/models/photo/photo_model.dart';
import 'package:photo_gallery/core/utils/exception_handler/_index.dart';
import 'package:photo_gallery/core/utils/networking/dio_client.dart';
import 'package:photo_gallery/core/utils/networking/endpoint.dart';

// @Injectable(as: PhotoRepository)
class PhotoDao {
  final _dio = DioClient.instance.dio;

  @override
  Future<Either<AppException, List<PhotoModel>>> loadPhotos(int page) async {
    try {
      final response =
          await _dio.get('${ApiEndPoint.photosUrl}/?page=${page}&client_id=${ApiEndPoint.photoAcessToken}');
      List<PhotoModel> photos = [];
      if (response.statusCode == 200) {
        if (response.data is List) {
          for (var photo in response.data) {
            PhotoModel photoModel = PhotoModel.fromJson(photo);
            photos.add(photoModel);
          }
        }
        return Right(photos);
      }

      return Left(AppException(response.statusMessage));
    } on DioError catch (e) {
      return Left(DioExceptions(e));
    } on Exception catch (_) {
      return Left(AppException.unknown());
    }
  }

  List<PhotoModel> parseItems(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PhotoModel>((json) => PhotoModel.fromJson(json)).toList();
  }
}
