import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'adminMain.dart';

class AdminAddRoom extends StatefulWidget {
  @override
  State<AdminAddRoom> createState() => _AdminAddRoomState();
}

class _AdminAddRoomState extends State<AdminAddRoom> {
  Color day = Colors.white;
  Color night = Colors.white;
  Color fight = Colors.white;
  bool _day = false, _night = false, _fight = false, img = false;
  final picker = ImagePicker();
  late File imageFile;
  late String fileName;
  XFile? pickedImage;
  final _conroomnum = TextEditingController();
  final _conroomprice = TextEditingController();
  final _conroomquantity = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  addroom() async {
    String rnumber = _conroomnum.text;
    String price = _conroomprice.text;
    String quantity = _conroomquantity.text;
    String service;
    int package = 0;

    if (rnumber.isEmpty ||
        price.isEmpty ||
        quantity.isEmpty ||
        (!_day && !_night && !_fight) || !img) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("ALL Fields Are Required"),
      ));
    } else {
      if (_day) {
        service = 'Cheap';
      } else if(_night) {
        service = 'Normal';
      } else {
        service = 'Luxury';
      }

      FirebaseFirestore.instance.collection('Rooms').add({
        'Room Number': rnumber,
        'Price': double.parse(price),
        'Quantity': quantity,
        'Package': package,
        'Booked': false,
        'Service': service
      }).then((value) async {
        try {
          FirebaseFirestore.instance
              .collection("Room_Description")
              .doc(value.id)
              .set({'Description': "N/A"});
          await storage.ref("Rooms/${value.id}/primary.jpeg").putFile(
              imageFile,
              SettableMetadata(customMetadata: {
                'Boat Name': rnumber,
              }));
        } on FirebaseException catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("room Added Successfully!"),
        ));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AdminMainScreen()),
            (Route<dynamic> route) => false);
      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  Future<void> selectImage() async {
    try {
      pickedImage =
          await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
      fileName = path.basename(pickedImage!.path);
      imageFile = File(pickedImage!.path);
      img = true;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        "Add Room Room Form",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoSlab',
                            color: Colors.blue,
                            fontSize: MediaQuery.of(context).size.width / 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: _conroomnum,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.house_outlined),
                      hintText: "Room Number",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _conroomprice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.attach_money),
                      hintText: "Charge",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: _conroomquantity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.groups),
                      hintText: "Quantity",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        padding: EdgeInsets.only(left: 10.0),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: day, width: 3),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: TextButton(
                          child: const Text(
                            "Cheap",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            setState(() {
                              if (!_day) {
                                day = Colors.blueAccent;
                                _day = true;
                                _night = false;
                                night = Colors.white;
                                _fight = false;
                                fight = Colors.white;
                              } else {
                                day = Colors.white;
                                _day = false;
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
                        padding: const EdgeInsets.only(left: 10.0),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: night, width: 3),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: TextButton(
                          child: const Text(
                            "Normal",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            setState(() {
                              if (!_night) {
                                night = Colors.blueAccent;
                                day = Colors.white;
                                _night = true;
                                _day = false;
                                _fight = false;
                                fight = Colors.white;
                              } else {
                                night = Colors.white;
                                _night = false;
                              }
                            });
                          },
                        ),
                      ),Container(
                        width: MediaQuery.of(context).size.width / 4,
                        padding: const EdgeInsets.only(left: 10.0),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: fight, width: 3),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: TextButton(
                          child: const Text(
                            "Luxury",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            setState(() {
                              if (!_fight) {
                                fight = Colors.blueAccent;
                                day = Colors.white;
                                night = Colors.white;
                                _fight = true;
                                _day = false;
                                _night = false;
                              } else {
                                fight = Colors.white;
                                _fight = false;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      margin: const EdgeInsets.only(left: 20, top: 10, bottom: 50),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add_a_photo_outlined,
                          ),
                          TextButton(
                            child: Text("Add Image"),
                            onPressed: () {
                              selectImage();
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.width / 3,
                      margin: const EdgeInsets.only(right: 20, top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(Radius.circular(30))),
                      child: img
                          ? Container(
                              padding: EdgeInsets.all(5),
                              child: Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(
                              width: 1,
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 10.0),
                  width: 240,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: TextButton(
                      child: const Text(
                        "Add room",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        addroom();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
