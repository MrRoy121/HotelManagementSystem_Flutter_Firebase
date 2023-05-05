import 'package:flutter/material.dart';

import '../../../constants/colors.dart';


AppBar aboutAppBar() {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.mirage,
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "About App",
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
