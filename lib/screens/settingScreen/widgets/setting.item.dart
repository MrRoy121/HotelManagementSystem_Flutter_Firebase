import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'icon.style.dart';


class SettingsItem extends StatelessWidget {
  final IconData icons;
  final IconStyle? iconStyle;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final double? size;
  final VoidCallback onTap;

  SettingsItem({
    required this.icons,
    this.iconStyle,
    required this.title,
    this.subtitle = "",
    this.trailing,
    required this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: (iconStyle != null && iconStyle!.withBackground!)
          ? Container(
              decoration: BoxDecoration(
                color: iconStyle!.backgroundColor,
                borderRadius: BorderRadius.circular(iconStyle!.borderRadius!),
              ),
              padding: EdgeInsets.all(5),
              child: Icon(
                icons,
                size: size,
                color: iconStyle!.iconsColor,
              ),
            )
          : Icon(
              icons,
              size: size,
            ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.creamColor,
        ),
        maxLines: 1,
      ),
      subtitle: Text(
        subtitle!,
        style: TextStyle(
          color: AppColors.rawSienna,
        ),
        maxLines: 1,
      ),
      trailing:
          (trailing != null) ? trailing : Icon(Icons.arrow_forward_ios_rounded),
    );
  }
}
