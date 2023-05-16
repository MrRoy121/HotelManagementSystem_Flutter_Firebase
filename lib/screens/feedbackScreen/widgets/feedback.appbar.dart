import 'package:flutter/material.dart';

import '../../../constants/colors.dart';


AppBar feedbackAppBar() {
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
            "Feedback",
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
