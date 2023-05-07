import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/roomScreen/room.screen.dart';
import 'package:hotels_syl/screens/searchScreen/widgets/search.items.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.styles.dart';
import '../../widgets/custom.text.field.dart';
import '../../widgets/shimmer.effects.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

CollectionReference Rooms = FirebaseFirestore.instance.collection('Rooms');
FirebaseStorage storageRef = FirebaseStorage.instance;

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> allroom = [], foundroom = [];
  final TextEditingController searchProductController = TextEditingController();
  bool isExecuted = false, ispeople = false;
  String dropdownvalue = '';

  var items = [
    '',
    'For 2 Person',
    'For 3 Person',
    'For 4 Person',
    'For 5 Person',
    'For 6 Person',
  ];
  Future<int> loadId() async {
    int id = await Future.delayed(const Duration(seconds: 7), () => 42);
    return id;
  }

  _loadImages() async {
    Rooms.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        storageRef
            .ref("Rooms/${doc.id}/primary.jpeg")
            .getDownloadURL()
            .then((value) {
          allroom.add({
            'Room ID': doc.id,
            'Room Number': doc["Room Number"],
            'Price': doc["Price"],
            'Quantity': doc["Quantity"],
            'Service': doc["Service"],
            'Package': doc["Package"],
            "url": value,
          });
        });
      }
    });
    await loadId();
  }

  @override
  void initState() {
    _loadImages();
    super.initState();
  }


  Future<List<Map<String, dynamic>>> _runFilter() async {
    List<Map<String, dynamic>> results = [];
      results = allroom
          .where((user) => user['Room Number']
          .toLowerCase()
          .contains(searchProductController.text.toLowerCase()))
          .toList();

    return results;
  }


  Future<List<Map<String, dynamic>>> _runsss() async {
    List<Map<String, dynamic>> results = [];
    if(dropdownvalue==items[1]){
      for(var i = 0; i < allroom.length; i++){
        if(allroom[i]['Quantity']=="2"){
          print(allroom[i]['Quantity']);
          results.add(allroom[i]);
        }
      }
    }else if(dropdownvalue==items[2]){
      for(var i = 0; i < allroom.length; i++){
        if(allroom[i]['Quantity']=="3"){
          print(allroom[i]['Quantity']);
          results.add(allroom[i]);
        }
      }
    }else if(dropdownvalue==items[3]){
      for(var i = 0; i < allroom.length; i++){
        if(allroom[i]['Quantity']=="4"){
          print(allroom[i]['Quantity']);
          results.add(allroom[i]);
        }
      }
    }else if(dropdownvalue==items[4]){

      for(var i = 0; i < allroom.length; i++){
        if(allroom[i]['Quantity']=="5"){
          print(allroom[i]['Quantity']);
          results.add(allroom[i]);
        }
      }
    }else{
      for(var i = 0; i < allroom.length; i++){
        if(allroom[i]['Quantity']=="6"){
          print(allroom[i]['Quantity']);
          results.add(allroom[i]);
        }
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height / 815;
    return Scaffold(
      backgroundColor: AppColors.mirage,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: AppColors.rawSienna,
                      width: 1,
                    ),
                  ),
                  elevation: 6,
                  color: AppColors.mirage,
                  child: Stack(
                    children: [
                      CustomTextField.customTextField2(
                        hintText: 'Search',
                        inputType: TextInputType.text,
                        textEditingController: searchProductController,
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a Search' : null,
                        onChanged: (val) {
                          setState(() {
                            isExecuted = true;
                            ispeople =false;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin:EdgeInsets.only(top: 10, right:15),
                            child: DropdownButton(dropdownColor: Color(0xff1d273b),
                              underline: SizedBox(),
                              icon: const Icon(Icons.keyboard_arrow_down, color:  Color(0xffd7834f),),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items, style: const TextStyle(color: Color(0xffd7834f),),),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                  isExecuted = false;
                                  ispeople =true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              isExecuted
                  ? searchData(
                      searchContent: searchProductController.text,
                      bool: null,
                    )
                  :ispeople
                  ? foundData()
                  : Column(
                      children: [
                        SizedBox(
                          height: _height * 290,
                        ),
                        Center(
                          child: Text(
                            'Search Your Room 🔥🤞',
                            style: kBodyText.copyWith(
                              fontSize: _height * 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.creamColor,
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget foundData() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: _runsss(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerEffects.loadShimmerFavouriteandSearch(
                    context: context, displayTrash: false);
              } else {
                List _snapshot = ((snapshot.data ?? []) as List);
                if (_snapshot.length == 0 || _snapshot.isEmpty) {
                  return SizedBox();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> image = snapshot.data![index];
                      return SearchItem(
                        price: image['Price'].toString(),
                        roomimage: image['url'],
                        quantity: image['Quantity'],
                        service: image['Service'],
                        package: "${image['Package']} Available",
                        roomnumber: image['Room Number'],
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => RoomScreen(
                                price: image['Price'],
                                quantity: image['Quantity'],
                                service: image['Service'],
                                package: "${image['Package']} Available",
                                roomnumber: image['Room Number'],
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
    );
  }
  Widget searchData({required String searchContent, required bool}) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: _runFilter(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerEffects.loadShimmerFavouriteandSearch(
                    context: context, displayTrash: false);
              } else {
                List _snapshot = snapshot.data as List;
                if (_snapshot.length == 0 || _snapshot.isEmpty) {
                  return SizedBox();
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> image = snapshot.data![index];
                      return SearchItem(
                        price: image['Price'].toString(),
                        roomimage: image['url'],
                        quantity: image['Quantity'],
                        service: image['Service'],
                        package: "${image['Package']} Available",
                        roomnumber: image['Room Number'],
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => RoomScreen(
                                    price: image['Price'],
                                    quantity: image['Quantity'],
                                    service: image['Service'],
                                    package: "${image['Package']} Available",
                                    roomnumber: image['Room Number'],
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
    );
  }
}
