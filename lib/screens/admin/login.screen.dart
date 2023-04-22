import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotels_syl/screens/admin/adminMain.dart';
import 'package:hotels_syl/screens/admin/signup.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.button.dart';
import '../../widgets/custom.snackbar.dart';
import '../../widgets/custom.styles.dart';
import '../loginScreen/login.screen.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _conuserEmail = TextEditingController();
  final _conuserPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepsea,
      appBar: AppBar(
        backgroundColor: AppColors.deepsea,
        elevation: 0,
        automaticallyImplyLeading: false,

      ),
      body: SafeArea(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Admin Login",
                          style: TextStyle(
                            color: AppColors.creamColor,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                                    (Route<dynamic> route) => false);
                          },
                          child: Text(
                            "User",
                            style: TextStyle(color: AppColors.creamColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You've been missed!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: AppColors.creamColor,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Form(
                      child: Column(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: _conuserEmail,
                              style: TextStyle(color: AppColors.creamColor),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide:
                                      BorderSide(color: AppColors.creamColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide:
                                      BorderSide(color: AppColors.creamColor),
                                ),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: AppColors.creamColor,
                                ),
                                hintText: "E-Mail",
                                fillColor: AppColors.mirage,
                                hintStyle:
                                    TextStyle(color: AppColors.creamColor),
                                filled: true,
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: const EdgeInsets.only(top: 10.0),
                            child: TextFormField(
                              controller: _conuserPass,
                              obscureText: true,
                              style: TextStyle(color: AppColors.creamColor),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0)),
                                  borderSide:
                                      BorderSide(color: AppColors.creamColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0)),
                                  borderSide:
                                      BorderSide(color: AppColors.creamColor),
                                ),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: AppColors.creamColor,
                                ),
                                hintText: "Password",
                                fillColor: AppColors.mirage,
                                hintStyle:
                                    TextStyle(color: AppColors.creamColor),
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont't have an account? ",
                    style: TextStyle(
                      color: AppColors.creamColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => AdminSignUpScreen()),);
                    },
                    child: Text(
                      'Register',
                      style: kBodyText.copyWith(
                        color: AppColors.creamColor,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton.customBtnLogin(
                buttonName: 'Sign In',
                onTap: () {
                  login(context: context);
                },
                bgColor: AppColors.creamColor,
                textColor: AppColors.mirage,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  login({required BuildContext context}) async {
    String email = _conuserEmail.text;
    String pass = _conuserPass.text;

    final prefs = await SharedPreferences.getInstance();

    if (email.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Email is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (pass.length < 6) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Password Must Be 6 Digit or Character.",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      SnackUtil.showSnackBar(
        context: context,
        text: "InValid Email Format.",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else {
      final newUser = FirebaseAuth.instance
        ..signInWithEmailAndPassword(email: email, password: pass);
      String? user = newUser.currentUser?.uid;
      FirebaseFirestore.instance
          .collection('Admin')
          .doc(user)
          .get()
          .then((DocumentSnapshot docResults) {
        if (docResults.exists) {  Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => const AdminMainScreen()),
                (Route<dynamic> route) => false);
          prefs.setBool('admin', true);
          SnackUtil.showSnackBar(
            context: context,
            text: "Login Successfully",
            textColor: AppColors.creamColor,
            backgroundColor: Colors.green,
          );
        }
      }).catchError((error) => SnackUtil.showSnackBar(
                context: context,
                text: "Failed to add user: $error",
                textColor: AppColors.creamColor,
                backgroundColor: Colors.red,
              ));
    }
  }
}
