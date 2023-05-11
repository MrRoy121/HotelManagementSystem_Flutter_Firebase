import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hotels_syl/screens/feedbackScreen/widgets/feedback.appbar.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.button.dart';
import '../../widgets/custom.snackbar.dart';
import '../../widgets/custom.text.field.dart';


class FeedbackScreen extends StatelessWidget {
  final TextEditingController ftitleController = TextEditingController();
  final TextEditingController fdescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double Userating = 1;
  FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double _height = MediaQuery.of(context).size.height / 815;

    return Scaffold(
      backgroundColor: AppColors.mirage,
      appBar: feedbackAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "We all need people who will give us feedback.\nThat's how we improve.!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color:
                               AppColors.creamColor
                              ,
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField.customTextField(
                              hintText: 'Title',
                              inputType: TextInputType.text,
                              textEditingController: ftitleController,
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter Title' : null,

                            ),
                            CustomTextField.customTextField(
                              hintText: 'Description',
                              inputType: TextInputType.multiline,
                              textEditingController: fdescController,
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter Description' : null,

                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rating :",
                            style: TextStyle(
                              color:  AppColors.creamColor
                                  ,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              Userating = rating;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _height * 80,
                ),
                CustomButton.customBtnLogin(
                  buttonName: 'Send Feedback',
                  onTap: () {

                  },
                  bgColor:  AppColors.creamColor ,
                  textColor:
                      AppColors.mirage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submitFeedback({required BuildContext context}) async {
    String createdAt = DateFormat("dd-MMMM-yyyy").format(
      DateTime.now(),
    );



    if (true) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Thanks For Submitting Feedback,We Have A Gift For You ",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.green,
      );
    } else {
      SnackUtil.showSnackBar(
        context: context,
        text:" errorType!",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    }
  }
}

