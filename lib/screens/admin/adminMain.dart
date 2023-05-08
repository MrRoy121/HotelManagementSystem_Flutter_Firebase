import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/RoomCard.dart';
import 'adminAddRoom.dart';
import 'adminRoomDetails.dart';
import 'adminShowBookings.dart';
import 'login.screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

CollectionReference Rooms = FirebaseFirestore.instance.collection('Rooms');

class _AdminMainScreenState extends State<AdminMainScreen> {
  FirebaseStorage storageRef = FirebaseStorage.instance;
  int length = 0;
  var prefs;
  Future<String?> getImage(String st) async {
    await storageRef
        .ref("Rooms/$st/primary.jpeg")
        .getDownloadURL()
        .then((value) {
      return value;
    });
    return null;
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

  sharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    sharedPref();
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Admin Main", style: TextStyle(color: Colors.lightBlue),),
        leading: IconButton(
          onPressed: () {
            prefs.setBool('admin', false);
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => AdminLoginScreen()),
                    (Route<dynamic> route) => false);
          },
          icon: const Icon(
            Icons.logout,
            size: 24,
            color: Colors.lightBlue,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width/4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        TextButton(
                          child: const Text(
                            "Add New Room",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) => AdminAddRoom()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5.0),
                    margin: const EdgeInsets.only(top: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.bookmark_added_sharp,
                          color: Colors.white,
                        ),
                        TextButton(
                          child: const Text(
                            "Show Bookings",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AdminShowBookings()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.5, color: Colors.lightBlueAccent),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                            snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AdminRoomDetails(
                                    image['Room ID'],
                                    image['Room Number'],
                                    image['Price'],
                                    image['url'],
                                    image['Quantity'],
                                    image['Service'],
                                    image['Package'])));
                          },
                          child:
                           RoomCard(image['Room Number'], image['Price'], image['url'], image['Quantity'], image['Service'],"${image['Package']} Available"),
                        );
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
