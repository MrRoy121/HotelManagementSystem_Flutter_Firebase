import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/prevBookingScreen/widgets/booking.item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../widgets/shimmer.effects.dart';
import '../roomScreen/room.screen.dart';

class PreviousBookingScreen extends StatefulWidget {
  const PreviousBookingScreen({Key? key}) : super(key: key);

  @override
  State<PreviousBookingScreen> createState() => _PreviousBookingScreenState();
}

CollectionReference Bookings =
    FirebaseFirestore.instance.collection('Bookings');
CollectionReference Rooms = FirebaseFirestore.instance.collection('Rooms');
FirebaseStorage storageRef = FirebaseStorage.instance;

class _PreviousBookingScreenState extends State<PreviousBookingScreen> {
  String userid = "";

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("uid")!;
    });
  }

  Future<List<Map<String, dynamic>>> _loadbooked() async {
    late List<Map<String, dynamic>> files = [];
    Bookings.where("User id", isEqualTo: userid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        storageRef
            .ref("Rooms/${doc["Room id"]}/primary.jpeg")
            .getDownloadURL()
            .then((value) {
          Rooms.doc(doc["Room id"]).get().then((val) {
            files.add({
              'Booking id': doc.id,
              'Booking': doc["booking"],
              'End Date': doc["End Date"],
              'Start Date': doc["Start Date"],
              'Total': doc["Total"],
              'Payment': doc["Payment Number"],
              'Room id': doc["Room id"],
              'Room Number': val["Room Number"],
              'Quantity': val["Quantity"],
              'Package': val["Package"],
              'Price': val["Price"].toString(),
              'Service': val["Service"],
              "url": value,
            });
          });
        });
      }
    });
    await loadId();
    return files;
  }

  Future<int> loadId() async {
    int id = await Future.delayed(const Duration(seconds: 7), () => 42);
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: Text(
                    "Bookings",
                    style: TextStyle(
                      color: AppColors.mirage,
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: Text(
                    "Your Previous Bookings",
                    style: TextStyle(
                      color: AppColors.mirage,
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: _loadbooked(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ShimmerEffects.loadBookingItem(context: context);
                    } else {
                      List _snapshot = snapshot.data as List;

                      if (_snapshot.isEmpty) {
                        return Text(
                          "No Bookings Found",
                          style: TextStyle(color: AppColors.creamColor),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> image =
                                snapshot.data![index];
                            return BookingItem(
                              total: image['Total'],
                              startdate: image['Start Date'],
                              bookid: image['Booking id'],
                              enddate: image['End Date'],
                              payment: image['Payment'],
                              roomnumber: image['Room Number'],
                              url: image['url'],
                              onTap: () {
                                if(!image["Booking"]){
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
                                            roomid: image['Room id'],
                                          )));
                                }
                              },
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
