import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../widgets/custom.snackbar.dart';

Widget imageSlider(
    {required String roomid, required BuildContext context}) {


  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result =
    await storage.ref("Rooms/" + roomid + "/").list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
      });
    });

    return files;
  }


  return Container(
    height: MediaQuery.of(context).size.width - 50,
    child: Stack(
      clipBehavior: Clip.none,
      children: [

        FutureBuilder(
          future: _loadImages(),
          builder: (context,
              AsyncSnapshot<List<Map<String, dynamic>>>
              snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.done) {
              return
                Swiper(
                  itemCount: snapshot.data!.length,
                  pagination: const SwiperPagination(
                    builder: SwiperPagination.dots,
                  ),
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> image =
                  snapshot.data![index];
                    return CachedNetworkImage(
                      imageUrl: image['url'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  },
                );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        Positioned(
          right: 10,
          bottom: -20,
          child: InkWell(
            onTap: () async {

              if (true) {
                SnackUtil.showSnackBar(
                  context: context,
                  text: 'Added To Favourite',
                  textColor: AppColors.creamColor,
                  backgroundColor: Colors.red.shade200,
                );
              } else {
                SnackUtil.showSnackBar(
                  context: context,
                  text:" data.error!",
                  textColor: AppColors.creamColor,
                  backgroundColor: Colors.red.shade200,
                );
              }
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.pink.shade400,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
