import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:photo_gallery/core/cubits/photo_list/photo_list_cubit.dart';
import 'package:photo_gallery/core/utils/networking/network_connection.dart';
import 'package:photo_gallery/ui/styling/image_path.dart';
import 'package:photo_gallery/ui/widgets/loader_widget.dart';

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

  _syncPhoto() async {
    setState(() {
      isLoading = true;
    });
    await context.read<PhotoListCubit>().getAllPhotos(context);
    Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            onPressed: () => _syncPhoto(),
            icon: const Icon(Icons.sync),
          )
        ],
      ),
      body: BlocBuilder<PhotoListCubit, PhotoListState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  if (state.allPhotos.isNotEmpty)
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
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
                              errorWidget: (context, url, error) => Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage(ImagePath.offline_image),
                                  fit: BoxFit.cover,
                                )),
                              ),
                              placeholder: (context, placeHolder) => Shimmer.fromColors(
                                baseColor: Colors.white24,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.black,
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
                  if (isLoading == true && state.allPhotos.isNotEmpty) const Center(child: CircularProgressIndicator())
                ],
              ),
              if (state.allPhotos.isEmpty && isLoading == false)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 100, width: 100, child: Image.asset(ImagePath.no_image)),
                      const Text('No Image available')
                    ],
                  ),
                ),
              if (state.allPhotos.isEmpty && isLoading == true) LoadingWidget(loaderTitle: 'Loading photo'),
              if (downloading) LoadingWidget(loaderTitle: 'Photo is downloding')
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloaded to gallery')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to download the photo')));
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
