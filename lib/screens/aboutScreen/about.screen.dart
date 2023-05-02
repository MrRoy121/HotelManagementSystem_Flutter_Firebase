import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/aboutScreen/widgets/about.appbar.dart';

import '../../constants/assets.dart';
import '../../constants/colors.dart';
import '../../widgets/custom.styles.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQueryHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: aboutAppBar(
      ),
      backgroundColor: AppColors.mirage,
      body: Column(mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: mediaQueryHeight / 8,
          ),
          Center(
            child: Image.asset(
              AppAssets.logo,
              height: 140,
              width: 140,
            ),
          ),
          SizedBox(
            height: mediaQueryHeight / 20,
          ),
          Text(
            'Hotel Nature',
            textAlign: TextAlign.left,
            style: kBodyText.copyWith(
              fontSize: 25,
              color: AppColors.creamColor,
            ),
          ),
          SizedBox(
            height: mediaQueryHeight / 50,
          ),
          Text(
            'Package Name : com.dev.hn',
            textAlign: TextAlign.left,
            style: kBodyText.copyWith(
              fontSize: 16,
              color: AppColors.creamColor,
            ),
          ),
          Text(
            'Build Number : 1',
            textAlign: TextAlign.left,
            style: kBodyText.copyWith(
              fontSize: 16,
              color: AppColors.creamColor,
            ),
          ),
          Text(
            'Version : 1.0.0',
            textAlign: TextAlign.left,
            style: kBodyText.copyWith(
              fontSize: 16,
              color: AppColors.creamColor,
            ),
          ),
          SizedBox(
            height: mediaQueryHeight / 40,
          ),
          Text(
            'For Any Queries ,\n Contact : dev.hn@gmail.com',
            textAlign: TextAlign.center,
            style: kBodyText.copyWith(
              fontSize: 16,
              color: AppColors.creamColor,
            ),
          )
        ],
      ),
    );
  }
}
