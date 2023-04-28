import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LoadingDialog {
  static showLoaderDialog(
      {required BuildContext context}) {
    AlertDialog alert = AlertDialog(
      backgroundColor: AppColors.mirage,
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            width: 5,
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              "Loading...",
              style: TextStyle(
                color: AppColors.creamColor,
              ),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
