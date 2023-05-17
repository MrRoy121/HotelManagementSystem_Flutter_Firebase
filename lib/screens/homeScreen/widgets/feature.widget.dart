import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';


class FeatureRooms extends StatelessWidget {
  String roomnumber, price, roomimage, quantity, service, package;
  FeatureRooms(
      {required this.roomnumber,
        required this.price,
        required this.roomimage,
        required this.quantity,
        required this.service,
        required this.package,
        required this.onTap,
        required this.onTapFavorite});
  final GestureTapCallback? onTapFavorite;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 815;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _height * 280,
        width: 220,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: roomimage,
                imageBuilder: (context, imageProvider) => Container(
                  height: _height * 280,
                  width: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Container(
                height: _height * 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0.5, 0.8],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Room Number $roomnumber",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _height * 14,
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 150,
                      child: Text(
                        'For : $quantity Person',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _height * 14,
                        ),
                      ),
                    ),
                    Text(
                      '৳ ${price} Per Night',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.yellowish,
                        fontSize: _height * 12,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 140,
                top: 3,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_outline_rounded,
                    size: _height * 25,
                    color: Colors.white,
                    shadows: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(
                          0.0,
                          0.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 4.0,
                      ),
                    ],
                  ),
                  onPressed: onTapFavorite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
