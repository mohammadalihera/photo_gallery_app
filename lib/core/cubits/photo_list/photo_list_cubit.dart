import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/core/models/photo/photo_model.dart';
import 'package:photo_gallery/core/repositories/photo/photo_repository.dart';
import 'package:photo_gallery/core/utils/cache/shared_preferences_helper.dart';
import 'package:photo_gallery/core/utils/networking/network_connection.dart';

part 'photo_list_state.dart';

class PhotoListCubit extends Cubit<PhotoListState> {
  final PhotoRepository photoRepository = PhotoRepository();
  PhotoListCubit() : super(const PhotoListState());

  int page = 0;

  getAllPhotos(BuildContext context) async {
    final PhotoListState currentState = state;
    final networkConnection = NetworkConnection.getInstance();
    try {
      bool hasConnection = await networkConnection.checkConnection();
      if (hasConnection == true) {
        page = page + 1;

        //Unsplash image api give access 50 requiest in an hour. This is why here this condition is needed
        if (page < 50) {
          final request = await photoRepository.loadPhotos(page);
          request.fold((exception) async {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exception.message ?? 'Unknown Error')));
            List<PhotoModel> cachedPhotoList = await SharedPreferencesHelper.getPhotoList();
            emit(currentState.copyWith(allPhotos: cachedPhotoList));
          }, (response) async {
            List<PhotoModel> updatedPhotoList = currentState.allPhotos + response;
            SharedPreferencesHelper.setPhotoList(updatedPhotoList);
            int cachedPageNumber = await SharedPreferencesHelper.getCachedPhotoPageNumber();
            if (cachedPageNumber < page) {
              SharedPreferencesHelper.setCachedPhotoPageNumber(page);
              SharedPreferencesHelper.setPhotoList(updatedPhotoList);
            }
            emit(currentState.copyWith(allPhotos: updatedPhotoList));
          });
          return;
        }
        List<PhotoModel> cachedPhotoList = await SharedPreferencesHelper.getPhotoList();
        emit(currentState.copyWith(allPhotos: cachedPhotoList));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You do not have network connection')));
        List<PhotoModel> cachedPhotoList = await SharedPreferencesHelper.getPhotoList();
        emit(currentState.copyWith(allPhotos: cachedPhotoList));
      }
    } catch (e) {
      print(e);
    }
  }
}
