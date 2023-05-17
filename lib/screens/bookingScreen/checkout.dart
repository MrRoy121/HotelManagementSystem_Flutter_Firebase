import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.button.dart';
import '../../widgets/custom.snackbar.dart';
import '../navigationScreen/navigation.screen.dart';

class CheckOut extends StatefulWidget {
  String startdate, enddate, roomid, userid, total;
  CheckOut(
      {Key? key,
      required this.startdate,
      required this.enddate,
      required this.roomid,
      required this.userid,
      required this.total})
      : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final _con = TextEditingController();
  int _sts = 1;
  bool progress = false;

  void conbook() {
    if (_con.text.length != 11) {
      SnackUtil.showSnackBar(
        context: context,
        text: 'Provide A Valid Phone Number',
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else {
      setState(() {
        progress = true;
      });
      FirebaseFirestore.instance.collection('Bookings').add({
        'Room id': widget.roomid,
        'User id': widget.userid,
        'Total': widget.total,
        'booking':false,
        'Payment Number': _con.text,
        'Start Date': widget.startdate,
        'End Date': widget.enddate,
      }).then((value) async {
        setState(() {
          progress = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(const Duration(seconds: 5), () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => NavigationScreen()),
                        (Route<dynamic> route) => false);
              });
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                  color: AppColors.creamColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network("https://e7.pngegg.com/pngimages/605/284/png-clipart-check-mark-computer-icons-green-tick-miscellaneous-angle-thumbnail.png"),
                      const Text(
                        'Room Booking Successful!!',
                        style: TextStyle(
                            color: Color(0xff1d273b),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "From ${widget.startdate} To ${widget.enddate} Payment From ${_con.text}",
                        style: const TextStyle(
                          color: Color(0xff1d273b),
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "To ${widget.enddate}",
                        style: const TextStyle(
                          color: Color(0xff1d273b),
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Payment From ${_con.text}",
                        style: const TextStyle(
                          color: Color(0xff1d273b),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });

      }).catchError((error) => print("Failed to add user: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(25),
      color: AppColors.mirage,
      child: progress
          ? Center(
              child: Column(
                children: [
                  Expanded(child: SizedBox()),
                  const CircularProgressIndicator(),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Payment is Processing!!',
                    style: TextStyle(
                      color: AppColors.creamColor,
                      fontSize: 18,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Confirm Booking and Payment',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.creamColor,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.yellowish,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text(
                          "Bkash",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Image.network(
                            'https://logos-download.com/wp-content/uploads/2022/01/BKash_Logo_icon-700x662.png'),
                        leading: Radio(
                          value: 1,
                          groupValue: _sts,
                          onChanged: (value) {
                            setState(() {
                              _sts = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: const Text(
                          "Rocket",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Image.network(
                            'https://seeklogo.com/images/D/dutch-bangla-rocket-logo-B4D1CC458D-seeklogo.com.png'),
                        leading: Radio(
                          value: 2,
                          groupValue: _sts,
                          onChanged: (value) {
                            setState(() {
                              _sts = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: const Text(
                          "Nogod",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Image.network(
                            'https://play-lh.googleusercontent.com/Iks014Ul-atatMhWs8rLbtG7cIZLPfpeMDdkLtmq5o7D5_MlFNu5mmIqRHAY45aOhapp'),
                        leading: Radio(
                          value: 3,
                          groupValue: _sts,
                          onChanged: (value) {
                            setState(() {
                              _sts = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Provide Payment Number',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.creamColor,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 5.0),
                  child: TextFormField(
                    controller: _con,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Color(0xffE7B975)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Color(0xff1d273b)),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                      hintText: "Mobile Number",
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton.customBtnLogin(
                  buttonName: 'Confirm Booking',
                  onTap: () async {
                    conbook();
                  },
                  bgColor: AppColors.creamColor,
                  textColor: AppColors.mirage,
                ),
              ],
            ),
    ));
  }
}
