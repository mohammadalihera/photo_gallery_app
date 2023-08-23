import 'dart:convert';

import 'package:photo_gallery/core/models/photo/photo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _photo = 'photo';
  static const String _cached_photo_page_number = '_cached_photo_page_number';

  static Future<bool> setPhotoList(List<PhotoModel> photoList) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonStr = json.encode(photoList);
      bool success = await prefs.setString(_photo, jsonStr);
      return success;
    } catch (_) {
      return false;
    }
  }

  static Future<List<PhotoModel>> getPhotoList() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.reload();

      String? jsonString = prefs.getString(_photo);
      if (jsonString != null && jsonString.isNotEmpty) {
        var photos = json.decode(jsonString);
        List<PhotoModel> photoList = <PhotoModel>[];
        for (var result in photos) {
          photoList.add(PhotoModel.fromJson(result));
        }
        return photoList;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<int> getCachedPhotoPageNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_cached_photo_page_number) ?? 0;
  }

  static Future<bool> setCachedPhotoPageNumber(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(_cached_photo_page_number, value != null ? value : 0);
  }
}
