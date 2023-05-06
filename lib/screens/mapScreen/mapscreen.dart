import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/colors.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng initialLocation = const LatLng(24.91409754711196, 91.85254862476269);
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomIcon();
    super.initState();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/map.png")
        .then(
          (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height / 815;
    return Scaffold(
      backgroundColor:  AppColors.mirage,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                child: Text(
                  "Track Hotel",
                  style: TextStyle(
                    color:  AppColors.creamColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: Text(
                  "Track Hotel Through Map",
                  style: TextStyle(
                    color:  AppColors.creamColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                height: _height * 600,
                child: GoogleMap(
                  markers: {
                    Marker(
                      icon: markerIcon,
                      markerId: const MarkerId("Hotel"),
                      position: const LatLng(24.91409754711196, 91.85254862476269),
                      draggable: true,
                      onDragEnd: (value) {
                      },
                    ),
                  },
                  initialCameraPosition: CameraPosition(
                    target: initialLocation,
                    zoom: 14,
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
