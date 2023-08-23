import 'package:dio/dio.dart';

import 'package:photo_gallery/core/utils/exception_handler/_index.dart';

class DioExceptions extends AppException {
  DioExceptions(DioError error) : super(_errorMessage(error));

  static String _errorMessage(DioError error) {
    return error.message ?? 'Unknown error occurred';
  }
}
