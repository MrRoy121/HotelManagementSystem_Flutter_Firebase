import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/aboutScreen/about.screen.dart';
import 'package:hotels_syl/screens/feedbackScreen/feedback.screen.dart';
import 'package:hotels_syl/screens/loginScreen/login.screen.dart';
import 'package:hotels_syl/screens/profileScreen/profile.screen.dart';
import 'package:hotels_syl/screens/settingScreen/widgets/icon.style.dart';
import 'package:hotels_syl/screens/settingScreen/widgets/setting.appbar.dart';
import 'package:hotels_syl/screens/settingScreen/widgets/setting.item.dart';
import 'package:hotels_syl/screens/settingScreen/widgets/setting.user.card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../prevBookingScreen/prev.booking.screen.dart';

class SettingScreen extends StatefulWidget {

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool url = false;
  String uid = "", name = "", imgurl = "", email = "";
  var prefs;

  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid")!;
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      checkimg();
    });
  }

  checkimg() {
    setState(() {
      storage
          .ref("Users/$uid.jpeg")
          .getDownloadURL()
          .then((value) {
        setState((){
          imgurl = value.toString();
          url = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: settingAppBar(),
      backgroundColor: AppColors.mirage,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            UserCard(
              cardColor: AppColors.rawSienna,
              userName: name,
              userProfileUrl: imgurl,
              onTap: () {

              },
              url: url,
              useremail: email,
            ),
            const SizedBox(
              height: 10,
            ),
            SettingsItem(
              onTap: () {

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()));
              },
              icons: CupertinoIcons.profile_circled,
              iconStyle: IconStyle(),
              title: 'Profile',
              subtitle: "Modify Your Data",
            ),
            SettingsItem(
              onTap: () {

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => const PreviousBookingScreen()));
              },
              icons: CupertinoIcons.bookmark_fill,
              iconStyle: IconStyle(
                backgroundColor: Colors.brown,
              ),
              title: 'Bookings',
              subtitle: "Check Old Bookings!",
            ),
            SettingsItem(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => const AboutScreen()));
              },
              icons: Icons.info_rounded,
              iconStyle: IconStyle(
                backgroundColor: Colors.purple,
              ),
              title: 'About',
              subtitle: "Learn more about Sylhet Nature App",
            ),
            SettingsItem(
              onTap: () {

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => FeedbackScreen()));

              },
              icons: CupertinoIcons.chat_bubble,
              iconStyle: IconStyle(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              title: 'Send Feedback',
              subtitle: "We Listen To Our Customer's",
            ),
            SettingsItem(
              onTap: () {
                showAlertDialog(ctx: context);
              },
              icons: Icons.logout,
              iconStyle: IconStyle(
                backgroundColor: Colors.red,
              ),
              subtitle: "Bye Bye",
              title: "Sign Out",
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog({
    required BuildContext ctx
  }) {


    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text(
            "Are You Sure You Want To Logout ?",
            style: TextStyle(
              color: AppColors.creamColor,
              fontSize: 18,
            ),
          ),
          content: Text(
            "You Will Regret About It!",
            style: TextStyle(
              color: AppColors.creamColor,
              fontSize: 16,
            ),
          ),
          backgroundColor: AppColors.mirage,
          actions: [
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                prefs.setBool('user', false);
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                        (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
