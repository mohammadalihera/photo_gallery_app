part of 'photo_list_cubit.dart';

class PhotoListState extends Equatable {
  final List<PhotoModel> allPhotos;
  const PhotoListState({this.allPhotos = const []});

  PhotoListState copyWith({
    List<PhotoModel>? allPhotos,
  }) {
    return PhotoListState(
      allPhotos: allPhotos ?? this.allPhotos,
    );
  }

  @override
  List<Object> get props => [allPhotos];
}
