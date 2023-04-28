import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'custom.styles.dart';

class CustomTextField {
  static customTextField2({
    required hintText,
    TextEditingController? textEditingController,
    TextInputType? inputType,
    bool? enabled,
    int? maxLength,
    int? minLines,
    int? maxLines,
    String? initialValue,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: enabled,
        onChanged: onChanged,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        controller: textEditingController,
        validator: validator,
        initialValue: initialValue,
        style: kBodyText.copyWith(
          color: AppColors.creamColor,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: kBodyText.copyWith(
            color: AppColors.creamColor ,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 0),
            child: Icon(
              Icons.search,
              color: AppColors.rawSienna,
            ),
          ),
        ),
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  static customTextField({
    required hintText,
    TextEditingController? textEditingController,
    TextInputType? inputType,
    bool? enabled,
    int? maxLength,
    int? minLines,
    int? maxLines,
    String? initialValue,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        enabled: enabled,
        onChanged: onChanged,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        controller: textEditingController,
        
        validator: validator,
        initialValue: initialValue,
        style: kBodyText.copyWith(
          color: AppColors.creamColor,
        ),
        keyboardType: inputType,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          hintText: hintText,
          hintStyle: kBodyText,
          counter: Offstage(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.creamColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.rawSienna,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  static customPasswordField({
    required BuildContext context,
    required onTap,
    required TextEditingController textEditingController,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: textEditingController,
        validator: validator,
        onChanged: onChanged,
        style: kBodyText.copyWith(
          color: AppColors.creamColor ,
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: onTap,
              icon: Icon( Icons.visibility,

                color: Colors.grey,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.all(20),
          hintText: 'Password',
          hintStyle: kBodyText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.creamColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.rawSienna,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
