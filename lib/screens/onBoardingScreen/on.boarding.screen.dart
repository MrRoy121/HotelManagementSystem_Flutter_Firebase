import 'package:concentric_transition/page_view.dart';
import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/onBoardingScreen/widget/on.boarding.card.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../models/boardingModel.dart';
import '../loginScreen/login.screen.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  final List<OnBoardingModel> cards = [
    OnBoardingModel(
      image: AppAssets.onBoardingOne,
      title: "The best holidays start here!",
      bgColor: AppColors.mirage,
      textColor: AppColors.yellowish,
    ),
    OnBoardingModel(
      image: AppAssets.onBoardingThree,
      title: "Feel the real experience.",
      bgColor: AppColors.rawSienna,
    ),
    OnBoardingModel(
      image: AppAssets.onBoardingTwo,
      title: "Stay once, carry memories forever",
      bgColor: AppColors.creamColor,
      textColor: AppColors.mirage,
    ),
  ];

  List<Color> get colors => cards.map((p) => p.bgColor).toList();

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ConcentricPageView(
        colors: widget.colors,
        curve: Curves.ease,
        nextButtonBuilder: (context) => Container(
          padding: const EdgeInsets.only(left: 3),
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),

        radius: 30,
        itemCount: 3,
        duration: const Duration(seconds: 2),
        itemBuilder: (index) {
          OnBoardingModel card = widget.cards[index % widget.cards.length];
          return PageCard(card: card);
        },
        onFinish: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                  (Route<dynamic> route) => false);
        },
      ),
    );
  }
}
