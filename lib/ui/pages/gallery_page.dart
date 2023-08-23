import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/core/cubits/photo_list/photo_list_cubit.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    context.read<PhotoListCubit>().getAllPhotos(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: BlocBuilder<PhotoListCubit, PhotoListState>(
        builder: (context, state) {
          print(state.allPhotos);
          return SingleChildScrollView(
            child: Column(
              children: [],
            ),
          );
        },
      ),
    );
  }
}
