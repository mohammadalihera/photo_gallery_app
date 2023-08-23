import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/core/cubits/photo_list/photo_list_cubit.dart';
import 'package:shimmer/shimmer.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  ScrollController scrollController = ScrollController();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final scrollThreshold = 100.0;
  bool isLoading = false;

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_scrollListener);
    context.read<PhotoListCubit>().getAllPhotos(context);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    // final maxScroll = scrollController.position.maxScrollExtent;
    // final currentScroll = scrollController.position.pixels;
    // if (maxScroll - currentScroll <= scrollThreshold) {
    //   context.read<PhotoListCubit>().getAllPhotos(context);
    // }
    final state = context.read<PhotoListCubit>().state;
    if (isLoading) {
      return;
    }
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      await context.read<PhotoListCubit>().getAllPhotos(context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: BlocBuilder<PhotoListCubit, PhotoListState>(
        builder: (context, state) {
          print(state.allPhotos);
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // childAspectRatio: 1.5,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  shrinkWrap: true,
                  itemCount: state.allPhotos.length,
                  controller: scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: CachedNetworkImage(
                        key: Key(state.allPhotos[index].urls!.regular!),
                        cacheKey: state.allPhotos[index].urls!.regular!,
                        imageUrl: state.allPhotos[index].urls!.regular!,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                          );
                        },
                        placeholder: (context, placeHolder) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: SizedBox(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),
                        ),
                        fit: BoxFit.fill,
                      ),
                    );
                    // Display photo from URL
                  },
                ),
              ),
              if (isLoading == true)
                const Center(
                  child: CircularProgressIndicator(),
                )
            ],
          );
        },
      ),
    );
  }
}
