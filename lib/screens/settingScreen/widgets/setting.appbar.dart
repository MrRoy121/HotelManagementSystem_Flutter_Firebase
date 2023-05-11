import 'package:flutter/material.dart';

import '../../../constants/colors.dart';


AppBar settingAppBar() {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.mirage,
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Settings",
            style: TextStyle(
              color: AppColors.creamColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
