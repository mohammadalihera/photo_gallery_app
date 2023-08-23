import 'package:dio/dio.dart';

import 'package:photo_gallery/core/utils/networking/endpoint.dart';

class DioClient {
  static DioClient get instance => DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return instance;
  }

  DioClient._internal() {
    dio = Dio();
    dio.options.baseUrl = ApiEndPoint.baseUrl;
    dio
      ..options.connectTimeout
      ..interceptors.clear()
      ..interceptors.add(LogInterceptor(responseBody: false));
  }
}
