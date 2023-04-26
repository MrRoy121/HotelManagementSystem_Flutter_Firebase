import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/allRoomsScreen/all.rooms.screen.dart';
import 'package:hotels_syl/screens/homeScreen/widgets/events.widget.dart';
import 'package:hotels_syl/screens/homeScreen/widgets/feature.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';

import '../../widgets/custom.snackbar.dart';
import '../../widgets/shimmer.effects.dart';
import '../roomScreen/room.screen.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

CollectionReference Rooms = FirebaseFirestore.instance.collection('Rooms');
FirebaseStorage storageRef = FirebaseStorage.instance;

class _HomeScreenState extends State<HomeScreen> {
  String uid = "", name = "";

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid")!;
      name = prefs.getString("name")!;
    });
  }

  Future<int> loadId() async {
    int id = await Future.delayed(const Duration(seconds: 7), () => 42);
    return id;
  }

  Future<List<Map<String, dynamic>>> _loadImages() async {
    late List<Map<String, dynamic>> files = [];
    Rooms.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        storageRef
            .ref("Rooms/${doc.id}/primary.jpeg")
            .getDownloadURL()
            .then((value) {
          files.add({
            'Room ID': doc.id,
            'Room Number': doc["Room Number"],
            'Price': doc["Price"].toString(),
            'Quantity': doc["Quantity"],
            'Service': doc["Service"],
            'Package': doc["Package"],
            "url": value,
            // "path": file.fullPath
          });
        });
      }
    });
    await loadId();
    return files;
  }

  Future<List<Map<String, dynamic>>> _loadUnbooked() async {
    late List<Map<String, dynamic>> files = [];
    Rooms.where('Booked', isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        storageRef
            .ref("Rooms/${doc.id}/primary.jpeg")
            .getDownloadURL()
            .then((value) {
          files.add({
            'Room ID': doc.id,
            'Room Number': doc["Room Number"],
            'Price': doc["Price"].toString(),
            'Quantity': doc["Quantity"],
            'Service': doc["Service"],
            'Package': doc["Package"],
            "url": value,
          });
        });
      }
    });
    await loadId();
    return files;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 815;

    return Scaffold(
      backgroundColor: AppColors.mirage,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hi!, $name",
                        style: TextStyle(
                          color: AppColors.creamColor,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Find and Book",
                        style: TextStyle(
                          color: AppColors.creamColor,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "The Best Room For You",
                        style: TextStyle(
                          color: AppColors.creamColor,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.5, color: AppColors.yellowish),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      Text(
                        "Available Room's",
                        style: TextStyle(
                          color: AppColors.creamColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: height * 280,
                  child: FutureBuilder(
                        future: _loadUnbooked(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return ShimmerEffects.loadShimmerHome(
                              context: context,
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final Map<String, dynamic> image =
                                    snapshot.data![index];
                                return FeatureRooms(
                                  price: image['Price'],
                                  roomimage: image['url'],
                                  quantity: image['Quantity'],
                                  service: image['Service'],
                                  package: "${image['Package']} Available",
                                  roomnumber: image['Room Number'],
                                  onTapFavorite: () async {
                                    if (true) {
                                      SnackUtil.showSnackBar(
                                        context: context,
                                        text: 'Added To Favourite',
                                        textColor: AppColors.mirage,
                                        backgroundColor: Colors.green.shade200,
                                      );
                                    }
                                  },
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => RoomScreen(
                                                  price: image['Price'],
                                                  quantity: image['Quantity'],
                                                  service: image['Service'],
                                                  package:
                                                      "${image['Package']} Available",
                                                  roomnumber:
                                                      image['Room Number'],
                                              roomid: image['Room ID'],
                                                )));
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "All Room's",
                            style: TextStyle(
                              color: AppColors.creamColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "In The Hotel",
                            style: TextStyle(
                              color: AppColors.creamColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {

                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => const AllRoomScreen()),
                                  );
                        },
                        child: Text(
                          "See All",
                          style: TextStyle(
                            height: 3,
                            color: AppColors.yellowish,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 200,
                  child: FutureBuilder(
                        future: _loadImages(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return ShimmerEffects.loadShimmerEvent(
                              context: context,
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final Map<String, dynamic> image =
                                    snapshot.data![index];
                                return EventsItem(
                                  price: image['Price'],
                                  roomimage: image['url'],
                                  quantity: image['Quantity'],
                                  service: image['Service'],
                                  package: "${image['Package']} Available",
                                  roomnumber: image['Room Number'],
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => RoomScreen(
                                                  price: image['Price'],
                                                  quantity: image['Quantity'],
                                                  service: image['Service'],
                                                  package:
                                                      "${image['Package']} Available",
                                                  roomnumber:
                                                      image['Room Number'],
                                                  roomid: image['Room ID'],
                                                )));
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
