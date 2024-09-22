import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../widgets/shimmer.effects.dart';
import '../roomScreen/room.screen.dart';
import '../searchScreen/widgets/search.items.dart';

class AllRoomScreen extends StatefulWidget {
  const AllRoomScreen({Key? key}) : super(key: key);

  @override
  State<AllRoomScreen> createState() => _AllRoomScreenState();
}

CollectionReference Rooms = FirebaseFirestore.instance.collection('Rooms');
FirebaseStorage storageRef = FirebaseStorage.instance;
class _AllRoomScreenState extends State<AllRoomScreen> {
  final List<String> items = [
    'Price Low To High',
    'Price High To Low',
  ];
  String? selectedValue;

  Future<int> loadId() async {
    int id = await Future.delayed(const Duration(seconds: 7), () => 42);
    return id;
  }

  Future<List<Map<String, dynamic>>> _loadImages() async {
    late List<Map<String, dynamic>> files = [];
    print(selectedValue);
    print(items[1]);

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
            });
          });
        }
      });
    await loadId();

    if(selectedValue==items[1]){
      files.sort((a, b) => b["Price"].compareTo(a["Price"]));
    }else {
      files.sort((a, b) => a["Price"].compareTo(b["Price"]));
    }
    return files;
  }

  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 815;
    return Scaffold(
      backgroundColor: AppColors.mirage,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: Text(
                  "All Rooms",
                  style: TextStyle(
                    color: AppColors.creamColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Find The Best Available Room",
                      style: TextStyle(
                        color:
                            AppColors.creamColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        customButton: Icon(
                          Icons.sort_sharp,
                          size: 35,
                          color: AppColors.creamColor,
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String?;
                          });
                        },
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200, // You can adjust the max height
                          width: 160,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.mirage,
                          ),
                          elevation: 8,
                          offset: const Offset(0, 8),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 48,
                          padding: EdgeInsets.only(left: 16, right: 16),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                height: _height * 670,
                child: FutureBuilder(
                  future: _loadImages(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ShimmerEffects.loadShimmerFavouriteandSearch(
                        context: context,
                        displayTrash: false,
                      );
                    } else {
                      List _snapshot = snapshot.data as List;
                      if (_snapshot.isEmpty) {
                        return SizedBox(

                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> image =
                            snapshot.data![index];
                            return SearchItem(
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
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
