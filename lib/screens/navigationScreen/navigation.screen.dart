import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/navigationScreen/widgets/nav.bottomNav.dart';

import '../homeScreen/home.screen.dart';
import '../mapScreen/mapscreen.dart';
import '../searchScreen/search.screen.dart';
import '../settingScreen/setting.screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int pageIndex = 0;
  final PageController homePageController = PageController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        controller: homePageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
        children: [
          HomeScreen(),
          SearchScreen(),
          MapScreen(),
          SettingScreen()
        ],
      ),
      bottomNavigationBar: BottomNav(
        controller: homePageController,
        index: pageIndex,
      ),
    );
  }
}
