import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../widgets/ExpandableText.dart';
import 'adminAddRoomPackage.dart';
import 'adminMain.dart';

class AdminRoomDetails extends StatefulWidget {
  String Roomid, Roomname, price, Roomimage, quantity, service;
  int package;

  AdminRoomDetails(this.Roomid, this.Roomname, this.price, this.Roomimage,
      this.quantity, this.service, this.package);

  @override
  State<AdminRoomDetails> createState() => _AdminRoomDetailsState(
      Roomid, Roomname, price, Roomimage, quantity, service, package);
}

class _AdminRoomDetailsState extends State<AdminRoomDetails> {
  String Roomid, Roomname, price, Roomimage, quantity, service;
  int package;
  final picker = ImagePicker();
  late File imageFile;
  late String fileName;
  XFile? pickedImage;
  FirebaseStorage storage = FirebaseStorage.instance;
  _AdminRoomDetailsState(this.Roomid, this.Roomname, this.price, this.Roomimage,
      this.quantity, this.service, this.package);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(Roomid)
        .collection("Package");

    String pack = package.toString();
    Future<void> selectImage() async {
      try {
        pickedImage =
            await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
        fileName = path.basename(pickedImage!.path);
        imageFile = File(pickedImage!.path);
        Random random = new Random();
        int randomNumber = random.nextInt(100);
        String rnd = randomNumber.toString();
        await storage
            .ref("Rooms/" + Roomid + "/" + rnd + ".jpeg")
            .putFile(
                imageFile,
                SettableMetadata(customMetadata: {
                  'Room Name': Roomname,
                }))
            .then((p0) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Room Image Added Successfully!"),
                )));
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
      setState(() {});
    }

    Future<List<Map<String, dynamic>>> _loadImages() async {
      List<Map<String, dynamic>> files = [];

      final ListResult result =
          await storage.ref("Rooms/" + Roomid + "/").list();
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

    TextEditingController _textdes = TextEditingController();
    _addDescription(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Write The New Description Here! '),
              content: TextField(
                minLines: 2,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                controller: _textdes,
                decoration: const InputDecoration(
                  hintText: "Enter Text...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              actions: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: TextButton(
                    child: const Text(
                      "ADD",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      String des = _textdes.text.toString();
                      if (!(des.length == 0)) {
                        FirebaseFirestore.instance
                            .collection('Room_Description')
                            .doc(Roomid)
                            .set({'Description': des}).then((value) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => AdminRoomDetails(
                                      Roomid,
                                      Roomname,
                                      price,
                                      Roomimage,
                                      quantity,
                                      service,
                                      package)),
                              (Route<dynamic> route) => false);
                        });
                      }
                    },
                  ),
                ),
              ],
            );
          });
    }

    _deleteRoom(BuildContext context) {
      Widget continueButton = TextButton(
        child: Text("Continue"),
        onPressed: () {
          storage.ref("Rooms/" + Roomid).delete();
          DocumentReference d =
              FirebaseFirestore.instance.collection('Rooms').doc(Roomid);
          d.collection("Package").get().then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
            d.delete().then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Room Deleted Successfully!")));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => AdminMainScreen()),
                  (Route<dynamic> route) => false);
            });
          });
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text("Delete The Room"),
        content: Text("Are You Sure You Want To Permanently Delete The Room?"),
        actions: [
          continueButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


    Future<void> _deleteImage(String ref) async {
      await storage.ref(ref).delete();
      setState(() {});
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => AdminMainScreen()),
            (Route<dynamic> route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                child: Image.network(Roomimage),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height/2.41 - 10,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width/42.2,
                    right:  MediaQuery.of(context).size.width/42.2,
                    top:  MediaQuery.of(context).size.width/42.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular( MediaQuery.of(context).size.width/42.2),
                    topLeft: Radius.circular( MediaQuery.of(context).size.width/42.2),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Room Number: $Roomname",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          margin: EdgeInsets.only(right: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.lightBlueAccent,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              TextButton(
                                child: const Text(
                                  "Add Package",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => AdminAddRoomPackage(
                                            Roomid,
                                            Roomname,
                                            price,
                                            Roomimage,
                                            quantity,
                                            service,
                                            package)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 6.0, left: 10, right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25, top: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Details",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 18),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            bool bday = false,
                                                bnight = false;
                                            if (service.length == 3) {
                                              bday = true;
                                            } else if (service.length ==
                                                5) {
                                              bnight = true;
                                            } else {
                                              bday = true;
                                              bnight = true;
                                            }


                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.lightBlueAccent,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.groups,
                                        color: Colors.black38,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Quantity : $quantity',
                                        style: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 36,),
                                      ),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      const Icon(
                                        Icons.room_service,
                                        color: Colors.black38,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Service : $service',
                                        style: TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 36,),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        const Icon(
                                          Icons.attach_money,
                                          color: Colors.black38,
                                        ),
                                        Text(
                                          'Charge ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 36,),
                                        ),
                                        Text(
                                          ': $price/-',
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 36,),
                                        ),
                                      ]),
                                      Row(children: [
                                        const Icon(
                                          Icons.local_offer_outlined,
                                          color: Colors.black38,
                                        ),
                                        Text(
                                          ' Package : $pack Available ',
                                          style: TextStyle(
                                              color: Colors.black38,fontSize: MediaQuery.of(context).size.width / 36,),
                                        ),
                                      ]),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child:const  Text(
                                    "Description",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Montserrat',
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(right: 25),
                                    child: IconButton(
                                        onPressed: () {
                                          _addDescription(context);
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.lightBlueAccent,
                                        ))),
                              ],
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(right: 60, left: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.lightBlueAccent),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin:const  EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 5),
                              child: FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('Room_Description')
                                      .doc(Roomid)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('Loading...');
                                    }
                                    return ExpandableText(
                                      text: snapshot.data!['Description'],
                                    );
                                  }),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const  EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Available Packages",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Montserrat',
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "$pack      ",
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(right: 60, left: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.lightBlueAccent),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(left: 20, right: 20),
                              child: StreamBuilder(
                                stream: users.snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot>
                                    streamSnapshot) {
                                  if (streamSnapshot.hasData) {
                                    return Container(
                                      height: 200,
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                          streamSnapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot stuone =
                                            streamSnapshot
                                                .data!.docs[index];
                                            return const SizedBox();
                                             // PackageCard(id: stuone.id, pname:  stuone["Package Name"], validity: stuone["Package Service"], pprice: stuone["Package Price"], pquantity: stuone["Package Quantity"], Roomid: Roomid, b: false, Roomname: Roomname, price: price, quantity: quantity, service: service, package: package);
                                          }),
                                    );
                                  } else {
                                    return const Text("No Package Available");
                                  }
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 20, right: 40),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Images",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: 'Montserrat',
                                        fontSize: 14),
                                  ),

                                  Container(
                                      child: IconButton(
                                          onPressed: () {
                                            selectImage();
                                          },
                                          icon: const Icon(
                                            Icons.add_a_photo_outlined,
                                            color: Colors.lightBlueAccent,
                                          ))),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(right: 60, left: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5,
                                      color: Colors.lightBlueAccent),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            FutureBuilder(
                              future: _loadImages(),
                              builder: (context,
                                  AsyncSnapshot<List<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Container(
                                    height: 300,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 8.0,
                                      children: List.generate(
                                          snapshot.data?.length ?? 0, (index) {
                                        final Map<String, dynamic> image =
                                            snapshot.data![index];
                                        return GestureDetector(
                                          onLongPress: () {
                                            _deleteImage(image['path']);
                                          },
                                          child: Center(
                                              child: Card(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Image.network(image['url']),
                                          )),
                                        );
                                      }),
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                _deleteRoom(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      "Delete Room",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
