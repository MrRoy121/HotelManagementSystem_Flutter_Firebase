import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminShowBookings extends StatefulWidget {
  @override
  State<AdminShowBookings> createState() => _AdminShowBookingsState();
}

class _AdminShowBookingsState extends State<AdminShowBookings> {
  @override
  Widget build(BuildContext context) {
    _launchCaller(String ss) async {
      var url = "tel:$ss";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: null,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              child: const Text(
                "User's Bookings",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoSlab',
                    color: Colors.blue,
                    fontSize: 24),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 40, left: 40, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(30)),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Bookings')
                    .where("booking", isEqualTo: false)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot stuone =
                              streamSnapshot.data!.docs[index];
                          print(streamSnapshot.data!.docs.length);
                          return Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Card(
                              color: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                            child: SizedBox(
                                          width: 1,
                                        )),
                                        const Text(
                                          "Booking From : ",
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontFamily: 'RobotoSlab',
                                              fontSize: 10),
                                        ),
                                        Text(
                                          stuone["Start Date"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'RobotoSlab',
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Expanded(
                                            child: SizedBox(
                                          width: 1,
                                        )),
                                        const Text(
                                          "To : ",
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontFamily: 'RobotoSlab',
                                              fontSize: 10),
                                        ),
                                        Text(
                                          stuone["End Date"],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'RobotoSlab',
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      const Icon(
                                        Icons.hotel_outlined,
                                        color: Colors.white70,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        "Room Number :  ",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontFamily: 'RobotoSlab',
                                            fontSize: 8),
                                      ),
                                      FutureBuilder<DocumentSnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('Rooms')
                                              .doc(stuone["Room id"])
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text('Loading...');
                                            }
                                            return Text(
                                              snapshot.data!['Room Number'],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'RobotoSlab',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            );
                                          }),
                                    ]),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .person_outline_rounded,
                                                    color: Colors.white70,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    "Booked By :  ",
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontFamily:
                                                            'RobotoSlab',
                                                        fontSize: 8),
                                                  ),
                                                  FutureBuilder<
                                                          DocumentSnapshot>(
                                                      future: FirebaseFirestore
                                                          .instance
                                                          .collection('Users')
                                                          .doc(
                                                              stuone["User id"])
                                                          .get(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Text(
                                                              'Loading...');
                                                        }
                                                        return Text(
                                                          snapshot.data![
                                                              'Full Name'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'RobotoSlab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        );
                                                      }),
                                                ],
                                              ),
                                              Row(children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.phone,
                                                      color: Colors.white70,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        'Booking Contact: ',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'RobotoSlab',
                                                            color:
                                                                Colors.white70,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                45),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    TextButton(
                                                        onPressed: () =>
                                                            _launchCaller(stuone[
                                                                "Payment Number"]),
                                                        child: Text(
                                                          "(+88) ${stuone['Payment Number']}",
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'RobotoSlab',
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        )),
                                                  ],
                                                ),
                                              ]),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                      child: SizedBox(
                                                    width: 1,
                                                  )),
                                                  const Icon(
                                                    Icons.money,
                                                    color: Colors.white70,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    "Total Paid Amount : ",
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontFamily:
                                                            'RobotoSlab',
                                                        fontSize: 10),
                                                  ),
                                                  Text(
                                                    '৳ ${stuone["Total"]}',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Text("");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
