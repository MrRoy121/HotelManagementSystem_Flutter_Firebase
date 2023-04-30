import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../constants/colors.dart';


Widget BottomNav(
    {required int index,
    required PageController controller}) {
  return Container(
    decoration: BoxDecoration(
      color:  AppColors.mirage,
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: SalomonBottomBar(
        currentIndex: index,
        onTap: (val) {
          index = val;
          controller.jumpToPage(val);
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            unselectedColor:
                 AppColors.creamColor,
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.search),
            title: Text("Search"),
            unselectedColor:
                 AppColors.creamColor,
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.map_rounded),
            title: Text("Location"),
            unselectedColor:
                 AppColors.creamColor ,
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.settings),
            title: Text("Setting"),
            unselectedColor:
                 AppColors.creamColor ,
            selectedColor: Colors.teal,
          ),
        ],
      ),
    ),
  );
}
