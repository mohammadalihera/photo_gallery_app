import 'package:dartz/dartz.dart';
import 'package:photo_gallery/core/models/photo/photo_model.dart';
import 'package:photo_gallery/core/repositories/photo/photo_repository_impl.dart';
import 'package:photo_gallery/core/utils/exception_handler/_index.dart';

class PhotoRepository {
  final PhotoDao _authDAO = PhotoDao();

  Future<Either<AppException, List<PhotoModel>>> loadPhotos() {
    return _authDAO.loadPhotos();
  }
}
