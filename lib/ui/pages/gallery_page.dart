import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/core/cubits/photo_list/photo_list_cubit.dart';
import 'package:photo_gallery/core/utils/networking/network_connection.dart';
import 'package:photo_gallery/ui/widgets/loader_widget.dart';
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
  bool downloading = false;

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
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
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
                                decoration:
                                    BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () => downLoadPhoto(state.allPhotos[index].urls!.raw!),
                                      // async {
                                      //   setState(() {
                                      //     downloading = true;
                                      //   });
                                      //   final tempDir = await getTemporaryDirectory();
                                      //   final path = '${tempDir.path}/photo_gallery.jpg';
                                      //   String url = state.allPhotos[index].urls!.raw!;
                                      //   await Dio().download(url, path);
                                      //   await GallerySaver.saveImage(path, albumName: 'PhotoGallery');
                                      //   setState(() {
                                      //     downloading = false;
                                      //   });
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(const SnackBar(content: Text('Downloaded to Gallery')));
                                      // },
                                      child: Container(
                                        constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        child: const Center(child: Icon(Icons.download_rounded)),
                                      ),
                                    ),
                                  ],
                                ),
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
              ),
              if (downloading) LoadingWidget(loaderTitle: 'Photo is Downloding')
            ],
          );
        },
      ),
    );
  }

  Future downLoadPhoto(String url) async {
    final networkConnection = NetworkConnection.getInstance();
    bool hasConnection = await networkConnection.checkConnection();
    if (hasConnection) {
      setState(() {
        downloading = true;
      });
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/photo_gallery.jpg';
      await Dio().download(url, path);
      GallerySaver.saveImage(path, albumName: 'PhotoGallery').then((bool? success) {
        if (success != null && success == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloaded to Gallery')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to Download the photo')));
        }
      });
      setState(() {
        downloading = false;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please connect with network and try again')));
    }
  }
}
