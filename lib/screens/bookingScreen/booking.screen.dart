import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotels_syl/models/dateModel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.button.dart';
import '../../widgets/custom.snackbar.dart';
import 'checkout.dart';

class BookingScreen extends StatefulWidget {
  String roomid, roomnumber, price, quantity, service, packagename;
  bool package;

  BookingScreen(
      {super.key,
      required this.roomid,
      required this.roomnumber,
      required this.price,
      required this.quantity,
      required this.service,
      required this.package,
      required this.packagename});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

CollectionReference Bookings =
    FirebaseFirestore.instance.collection('Bookings');

class _BookingScreenState extends State<BookingScreen> {
  bool check = false, disc = false, book = false;
  final DateRangePickerController _datePickerController =
      DateRangePickerController();

  var daterr = [];
  String name = "", email = "", phone = "", userid = "";
  String? startdate, enddate, fors, discunt = "00", total;

  @override
  void initState() {
    check = false;
    getbookings();
    sharedPref();
    super.initState();
  }

  bookroom() {
    if (startdate == null || enddate == null) {
      SnackUtil.showSnackBar(
        context: context,
        text: 'Pick Two Dates Before Booking',
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CheckOut(
                enddate: enddate!,
                roomid: widget.roomid,
                startdate: startdate!,
                total: total!,
                userid: userid,
              )));
    }
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      phone = prefs.getString("phone")!;
      userid = prefs.getString("uid")!;
    });
  }

  getbookings() async {
    Bookings
        .where("Room id", isEqualTo: widget.roomid)
        .where("booking", isEqualTo: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        daterr.add(DateModel(
            start: DateTime.parse(doc["Start Date"]!),
            end: DateTime.parse(doc["End Date"]!),
            uid: doc.id));
      }
      setState(() {});
    });
  }

  void daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    int fff = ((to.difference(from).inHours / 24).round() + 1);
    setState(() {
      fors = fff.toString();
      total = (fff * int.parse(widget.price)).toString();
    });
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    if (dateRangePickerSelectionChangedArgs.value.toString() != null) {
      var str = dateRangePickerSelectionChangedArgs.value.toString();
      setState(() {
        if (str.length > 80) {
          startdate = str.substring(33, 43);
          enddate = str.substring(67, 77);
        } else {
          startdate = str.substring(33, 43);
          enddate = str.substring(33, 43);
        }
        daysBetween(DateTime.parse(startdate!), DateTime.parse(enddate!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController couponText = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.mirage,
      appBar: AppBar(
        backgroundColor: AppColors.mirage,
        title: Text(
          'Booking Room',
          style: TextStyle(
            color: AppColors.creamColor,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Details',
                style: TextStyle(
                  color: AppColors.yellowish,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
              Divider(color: AppColors.creamColor),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'User Name : ',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'User Email :',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'User Phone : ',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      phone,
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColors.creamColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confirm Booking Dates',
                    style: TextStyle(
                      color: AppColors.yellowish,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  IconButton(
                    splashColor: AppColors.creamColor,
                    icon: Icon(
                      Icons.edit_calendar,
                      size: 20,
                      color: AppColors.creamColor,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Pick The Dates'),
                              content: Container(
                                height: 300,
                                width: MediaQuery.of(context).size.width - 130,
                                alignment: Alignment.center,
                                child: SfDateRangePicker(
                                  view: DateRangePickerView.month,
                                  monthViewSettings:
                                      const DateRangePickerMonthViewSettings(
                                          firstDayOfWeek: 6),
                                  onSelectionChanged: _onSelectionChanged,
                                  selectionMode:
                                      DateRangePickerSelectionMode.range,
                                  selectableDayPredicate: (DateTime dateTime) {
                                    for (var iss = 0; iss < daterr.length; iss++){
                                      if (dateTime == daterr[iss].start || dateTime == daterr[iss].end ) {
                                        return false;
                                      }
                                      for (int i = 0; i <= daterr[iss].end.difference(daterr[iss].start).inDays; i++) {
                                        if (dateTime == daterr[iss].start.add(Duration(days: i)) ) {
                                          return false;
                                        }
                                      }
                                    }
                                    return true;
                                  },
                                  enablePastDates: false,
                                  showActionButtons: true,
                                  controller: _datePickerController,
                                  onSubmit: (_) {
                                    setState(() {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  onCancel: () {
                                    _datePickerController.selectedRanges = null;
                                    setState(() {
                                      startdate = " ";
                                      enddate = " ";
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
              Divider(color: AppColors.creamColor),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start Date : ',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      startdate != null ? "$startdate" : "",
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'End Date : ',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      enddate != null ? "$enddate" : "",
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: const Icon(Icons.card_giftcard,
                              color: Color(0xfff5f5ff))),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          constraints: const BoxConstraints(maxWidth: 210),
                          child: TextFormField(
                            controller: couponText,
                            style: TextStyle(
                              color: AppColors.creamColor,
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Coupon Code',
                              hintStyle: TextStyle(
                                color: AppColors.creamColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    child: const Text('Apply'),
                    onPressed: () {
                      if (couponText.text.isNotEmpty) {
                        if (true
                            //AppDiscount.couponCode.contains(couponText.text)
                            ) {
                          if (check == false) {
                            SnackUtil.showSnackBar(
                              context: context,
                              text: 'Ohh Yeah Coupon Applied',
                              textColor: AppColors.creamColor,
                              backgroundColor: Colors.red.shade200,
                            );
                            setState(() {
                              check = true;
                            });
                          } else if (check == true) {
                            SnackUtil.showSnackBar(
                              context: context,
                              text: 'Coupon Already Applied',
                              textColor: AppColors.creamColor,
                              backgroundColor: Colors.red.shade200,
                            );
                          }
                        } else {
                          SnackUtil.showSnackBar(
                            context: context,
                            text: 'Oops Wrong Coupon Code',
                            textColor: AppColors.creamColor,
                            backgroundColor: Colors.red.shade200,
                          );
                        }
                      } else {
                        SnackUtil.showSnackBar(
                          context: context,
                          text: "Ehh Atleast Enter A Coupon!",
                          textColor: AppColors.creamColor,
                          backgroundColor: Colors.red.shade200,
                        );
                      }
                    },
                  )
                ],
              ),
              Divider(color: AppColors.creamColor),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: Text(
                  'Room Details',
                  style: TextStyle(
                    color: AppColors.yellowish,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Divider(color: AppColors.creamColor),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Room Number : ',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      widget.roomnumber,
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Room Quantity : ',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.quantity,
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Room Type : ',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      widget.service,
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Room Price : ',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      widget.price,
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Divider(
                color: AppColors.creamColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  'Total',
                  style: TextStyle(
                    color: AppColors.yellowish,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Divider(color: AppColors.creamColor),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'For Nights:',
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      fors != null ? "X $fors" : "",
                      style: TextStyle(
                        color: AppColors.creamColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              disc
                  ? Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount :',
                            style: TextStyle(
                              color: AppColors.creamColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            "-  $discunt",
                            style: TextStyle(
                              color: AppColors.creamColor,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      width: 1,
                    ),
              Divider(color: AppColors.creamColor),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sub Total :',
                      style: TextStyle(
                          color: AppColors.creamColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      total != null ? "৳  $total" : "",
                      style: TextStyle(
                          color: AppColors.creamColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton.customBtnLogin(
                buttonName: 'Book Room',
                onTap: () async {
                  bookroom();
                },
                bgColor: AppColors.creamColor,
                textColor: AppColors.mirage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
