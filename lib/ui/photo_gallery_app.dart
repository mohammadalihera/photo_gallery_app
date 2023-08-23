import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/core/cubits/photo_list/photo_list_cubit.dart';
import 'package:photo_gallery/ui/pages/gallery_page.dart';
import 'package:photo_gallery/ui/styling/_index.dart';

class PhotoGalleryApp extends StatelessWidget {
  const PhotoGalleryApp({super.key});
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotoListCubit>(create: (context) => PhotoListCubit()),
      ],
      child: MaterialApp(
        title: 'Phot Gallery',
        theme: AppTheme.buildLightTheme,
        home: const GalleryPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
