import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../constants/colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String first, second;
  bool hiddenText = true;
  double textHeight = 100;

  @override
  void initState() {
    super.initState();
    if (widget.text.length >= textHeight) {
      first = widget.text.substring(0, textHeight.toInt());
      second =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      first = widget.text;
      second = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: second.isEmpty
          ? Text(first,
              style: TextStyle(
                color: AppColors.yellowish,
                fontSize: 12,
                fontFamily: 'RobotoSlab',
              ))
          : Column(
              children: [
                Text(
                  hiddenText ? ("$first.....") : (first + second),
                  style: TextStyle(
                    color: AppColors.yellowish,
                    fontSize: 12,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        hiddenText = !hiddenText;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Show More..",
                          style: TextStyle(
                            color: AppColors.rawSienna,
                            fontSize: 12,
                            fontFamily: 'RobotoSlab',
                          ),
                        ),
                        Icon(
                          hiddenText
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          color: AppColors.rawSienna,
                        )
                      ],
                    ))
              ],
            ),
    );
  }
}
