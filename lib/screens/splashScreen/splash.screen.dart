import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../admin/adminMain.dart';
import '../navigationScreen/navigation.screen.dart';
import '../onBoardingScreen/on.boarding.screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _initiateCache() async {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => OnBoardingScreen()),
            (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getBool('user') ?? false;
    final admin = prefs.getBool('admin') ?? false;
    if (user) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => NavigationScreen()),
              (Route<dynamic> route) => false);
    }else if (admin) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => AdminMainScreen()),
              (Route<dynamic> route) => false);
    }else{
      Timer(const Duration(seconds: 1), _initiateCache);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mirage,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sylhet Nature',
              style: TextStyle(
                color: AppColors.creamColor ,
                fontSize: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
