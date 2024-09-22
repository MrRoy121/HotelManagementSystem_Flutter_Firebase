import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/mapScreen/mapscreen.dart';
import 'package:hotels_syl/screens/roomScreen/widgets/image.slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../widgets/ExpandableText.dart';
import '../../widgets/custom.snackbar.dart';
import '../bookingScreen/booking.screen.dart';
import '../navigationScreen/navigation.screen.dart';

class RoomScreen extends StatefulWidget {
  String roomid, roomnumber, price, quantity, service, package;

  RoomScreen(
      {super.key,
      required this.roomid,
      required this.roomnumber,
      required this.price,
      required this.quantity,
      required this.service,
      required this.package});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

CollectionReference Bookings =
    FirebaseFirestore.instance.collection('Bookings');

class _RoomScreenState extends State<RoomScreen> {
  bool book = false;
  String userid = "",
      bookid = '',
      startdate = '',
      enddate = '',
      total = '',
      payment = '';


  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("uid")!;
      checkbook();
    });
  }

  checkbook() async {
    Bookings.where("User id", isEqualTo: userid)
        .where("Room id", isEqualTo: widget.roomid)
        .where("booking", isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          setState(() {
            book = true;
            bookid = doc.id;
            startdate = doc["Start Date"];
            enddate = doc["End Date"];
            total = doc["Total"];
            payment = doc["Payment Number"];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.roomid)
        .collection("Package");

    return Scaffold(
        backgroundColor: AppColors.mirage,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              imageSlider(roomid: widget.roomid, context: context),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                decoration: BoxDecoration(
                  color: AppColors.mirage,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(100),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Room Number: ${widget.roomnumber}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.creamColor,
                            ),
                          ),
                          Text(
                            '৳ ${widget.price}',
                            style: TextStyle(
                                color: AppColors.yellowish,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_city,
                                color: AppColors.creamColor,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'For : ${widget.quantity} Person',
                                style: TextStyle(
                                  color: AppColors.creamColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "per night",
                            style: TextStyle(
                              color: AppColors.creamColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Card(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   color: AppColors.mirage,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 10,
                    //       vertical: 10,
                    //     ),
                    //     height: MediaQuery.of(context).size.height * 0.08,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(15)),
                    //     child:
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       crossAxisAlignment: CrossAxisAlignment.end,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             const Icon(
                    //               Icons.star,
                    //               size: 18,
                    //               color: Colors.amber,
                    //             ),
                    //             Text(
                    //               "4.5",
                    //               style: TextStyle(
                    //                 color:AppColors.creamColor,
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //         Text(
                    //           "10 reviews",
                    //           style: TextStyle(
                    //             color: AppColors.creamColor,
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "What they offer",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.creamColor,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 7,
                      child: StreamBuilder(
                        stream: users.snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: streamSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot stuone =
                                    streamSnapshot.data!.docs[index];
                                return Card(
                                  elevation: 5,
                                  color: AppColors.rawSienna,
                                  shadowColor: AppColors.yellowish,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(
                                                child: SizedBox(
                                              height: 1,
                                            )),
                                            Text(
                                              textAlign: TextAlign.end,
                                              "৳ ${stuone['Package Price']}",
                                              style: TextStyle(
                                                  color: AppColors.creamColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Name : ${stuone['Package Name']}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.mirage),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "For ${stuone['Package Quantity']} People",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: AppColors.mirage),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "For ${stuone['Package Service']}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: AppColors.mirage),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.creamColor,
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Room_Description')
                            .doc(widget.roomid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Loading...');
                          }
                          return Container(
                            margin: const EdgeInsets.only(top: 15),
                            child: ExpandableText(
                              text: snapshot.data!['Description'],
                            ),
                          );
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (BuildContext context) => MapScreen()),
                                (Route<dynamic> route) => false);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        final Uri url = Uri.parse('tel:// 111');
                        launchUrl(url);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.shade200,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 15,
                      child: book
                          ? ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmation"),
                                content: Text(
                                    "Proceed to Confirm the Check Out ?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Proceed"),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('Bookings')
                                          .doc(bookid)
                                          .set({
                                        'Room id': widget.roomid,
                                        'User id': userid,
                                        'Total': total,
                                        'booking': true,
                                        'Payment Number': payment,
                                        'Start Date': startdate,
                                        'End Date': enddate,
                                      }).then((value) async {
                                        SnackUtil.showSnackBar(
                                          context: context,
                                          text: 'Checked Out Successfully',
                                          textColor: AppColors.mirage,
                                          backgroundColor: Colors.green,
                                        );
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    NavigationScreen()),
                                                (Route<dynamic> route) => false);
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellowish,
                              ),
                              child: const Text(
                                "Check Out",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BookingScreen(
                                      price: widget.price,
                                      quantity: widget.quantity,
                                      service: widget.service,
                                      package: false,
                                      packagename: "",
                                      roomnumber: widget.roomnumber,
                                      roomid: widget.roomid,
                                    )),
                          );
                        },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellowish,
                              ),
                              child: const Text(
                                "Book Now",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
