import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.button.dart';
import '../../widgets/custom.snackbar.dart';
import '../../widgets/custom.styles.dart';
import 'login.screen.dart';

class AdminSignUpScreen extends StatefulWidget {
  AdminSignUpScreen({super.key});

  @override
  State<AdminSignUpScreen> createState() => _AdminSignUpScreenState();
}

class _AdminSignUpScreenState extends State<AdminSignUpScreen> {
  final TextEditingController _conuserEmail = TextEditingController();
  final TextEditingController _conuserName = TextEditingController();
  final TextEditingController _conuserPass = TextEditingController();
  final TextEditingController _conuserPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepsea,
      appBar: AppBar(
        backgroundColor: AppColors.deepsea,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 24,
            color: AppColors.creamColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Admin Register",
                      style: kHeadline.copyWith(
                        color: AppColors.creamColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Create new Admin account to get started.",
                      style: kBodyText2.copyWith(
                        color: AppColors.creamColor,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          margin: const EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: _conuserName,
                            keyboardType: TextInputType.name,
                            style: TextStyle(color: AppColors.creamColor),
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
                                Icons.person,
                                color: AppColors.creamColor,
                              ),
                              hintText: "Full Name",
                              fillColor: AppColors.mirage,
                              hintStyle: TextStyle(color: AppColors.creamColor),
                              filled: true,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          margin: const EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: _conuserEmail,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: AppColors.creamColor),
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
                                Icons.mail,
                                color: AppColors.creamColor,
                              ),
                              hintText: "E-Mail",
                              fillColor: AppColors.mirage,
                              hintStyle: TextStyle(color: AppColors.creamColor),
                              filled: true,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 7),
                          decoration: BoxDecoration(
                              color: AppColors.mirage,
                              border: Border.all(
                                width: 1,
                                color: AppColors.creamColor,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            children: [
                              Text(
                                "+880",
                                style: TextStyle(color: AppColors.creamColor),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                    fontSize: 26, color: AppColors.creamColor),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: _conuserPhone,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: AppColors.creamColor),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: AppColors.creamColor),
                                    hintText: 'Phone Number'),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              hintStyle: TextStyle(color: AppColors.creamColor),
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: MediaQuery.of(context).size.height/7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: kBodyText.copyWith(
                        color: AppColors.creamColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (BuildContext context) => AdminLoginScreen()),
                                (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Sign In',
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
                  buttonName: 'Register',
                  onTap: () {
                    signUp(context: context);
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
      ),
    );
  }

  signUp({required BuildContext context}) async {
    String email = _conuserEmail.text;
    String name = _conuserName.text;
    String pass = _conuserPass.text;
    String phone = _conuserPhone.text;


    if (email.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Email is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (name.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Name Is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (pass.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Password is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    } else if (phone.isEmpty) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Phone Number is Required",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    }else if (pass.length<6) {
      SnackUtil.showSnackBar(
        context: context,
        text: "Password Must Be 6 Digit or Character.",
        textColor: AppColors.creamColor,
        backgroundColor: Colors.red.shade200,
      );
    }
    // else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(email)) {
    //   SnackUtil.showSnackBar(
    //     context: context,
    //     text: "InValid Email Format.",
    //     textColor: AppColors.creamColor,
    //     backgroundColor: Colors.red.shade200,
    //   );
    // }
    else {
      final prefs = await SharedPreferences.getInstance();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((onValue) {
        String? user = onValue.user?.uid;
        FirebaseFirestore.instance.collection('Admin').doc(user).set({
          'Full Name': name,
          'Email': email,
          'Phone': phone,
          'Password': pass
        }).then((value) {  Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => AdminLoginScreen()),
                (Route<dynamic> route) => false);
          prefs.setBool('admin', true);
          SnackUtil.showSnackBar(
            context: context,
            text: "Signup Successfully",
            textColor: AppColors.creamColor,
            backgroundColor: Colors.green,
          );
        })
            //     .catchError((error) => SnackUtil.showSnackBar(
            //   context: context,
            //   text: "Failed to add user: $error",
            //   textColor: AppColors.creamColor,
            //   backgroundColor: Colors.red,
            // ))
            ;
      });
    }
  }
}
