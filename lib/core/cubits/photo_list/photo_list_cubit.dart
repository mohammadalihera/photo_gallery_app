import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/core/models/photo/photo_model.dart';
import 'package:photo_gallery/core/repositories/photo/photo_repository.dart';

part 'photo_list_state.dart';

class PhotoListCubit extends Cubit<PhotoListState> {
  final PhotoRepository photoRepository = PhotoRepository();
  PhotoListCubit() : super(const PhotoListState());

  getAllPhotos(BuildContext context) async {
    final request = await photoRepository.loadPhotos();
    request.fold((exception) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(exception.message ?? 'Unknown Error')));
    }, (response) {
      emit(state.copyWith(allPhotos: response));
    });
  }
}
