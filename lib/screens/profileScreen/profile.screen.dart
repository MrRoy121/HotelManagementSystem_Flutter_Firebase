import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';
import '../../widgets/custom.button.dart';
import '../../widgets/custom.snackbar.dart';
import '../../widgets/loading.dialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _conuserEmail = TextEditingController();
  final _conuserName = TextEditingController();
  final _conuserPass = TextEditingController();
  final _conuserPhone = TextEditingController();
  String? email, phone, pass, name, uid, imgurl;
  FirebaseStorage storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  late File imageFile;
  late String fileName, imgFile = "";
  XFile? pickedImage;
  bool url = false, fille = false;

  @override
  void initState() {
    sharedPref();
    super.initState();
  }

  sharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid")!;
      name = prefs.getString("name")!;
      email = prefs.getString("email")!;
      phone = prefs.getString("phone")!;
      pass = prefs.getString("pass")!;
      _conuserPass.text = pass!;
      _conuserEmail.text = email!;
      _conuserPhone.text = phone!;
      _conuserName.text = name!;
      checkimg();
    });
  }

  checkimg() {
    setState(() {

      storage
          .ref("Users/${uid!}.jpeg")
          .getDownloadURL()
          .then((value) {
        setState((){
          imgurl = value.toString();
          url = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 815;

    Future<void> selectImage() async {
      try {
        pickedImage =
            await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
        fileName = path.basename(pickedImage!.path);
        setState(() {
          imageFile = File(pickedImage!.path);
          fille= true;
        });
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.mirage,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Profile",
                  style: TextStyle(
                    color: AppColors.creamColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 150.0,
                        height: 150.0,
                        child: url
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.network(
                                  imgurl!,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: fille
                                    ? Image.file(imageFile)
                                    : Image.asset(
                                        "assets/images/def_usr.png",
                                      ),
                              ),
                      ),
                      Positioned(
                        top: 115,
                        left: 110,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 18,
                            ),
                            onPressed: () {
                              selectImage();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
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
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: AppColors.creamColor),
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
                    SizedBox(
                      height: height * 165,
                    ),
                    CustomButton.customBtnLogin(
                      buttonName: 'Update Profile',
                      onTap: () async {
                        LoadingDialog.showLoaderDialog(context: context);

                        String email = _conuserEmail.text;
                        String name = _conuserName.text;
                        String pass = _conuserPass.text;
                        String phone = _conuserPhone.text;

                        if (imageFile != null) {
                          await storage
                              .ref("Users/${uid!}.jpeg")
                              .putFile(imageFile);
                          if (email.isNotEmpty &&
                              name.isNotEmpty &&
                              pass.isNotEmpty &&
                              phone.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection('Users')
                                .doc(uid)
                                .set({
                              'Full Name': name,
                              'E-mail': email,
                              'Phone': phone,
                              'Password': pass
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("User Profile Updated Successfully!"),
                            ));
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()),
                                    (Route<dynamic> route) => false);
                          }
                        }
                         else {
                          SnackUtil.showSnackBar(
                            context: context,
                            text: "ALL Fields Are Required",
                            textColor: AppColors.creamColor,
                            backgroundColor: Colors.red.shade200,
                          );
                        }
                      },
                      bgColor: AppColors.creamColor,
                      textColor: AppColors.mirage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
