import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fyp_secure_com/CustomsWidget/custombutton.dart';
import 'package:fyp_secure_com/animations/fadeAnimation.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/login.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../CustomsWidget/customTextfield.dart';
import 'index.dart';

class SignUp extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUp> {
  bool IsImagePick = false;
  File _image = File("");
  final name = TextEditingController();
  final number = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final licence = TextEditingController();

  bool isLoading = false;
  bool isDoctor = true;
  List<String> _status = ["Doctor", "Patient"];
  String selectedRole = 'Patient';

  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          selectedRole = 'Doctor';
          break;
        case 1:
          selectedRole = 'Patient';
          break;
      }

      SignUpController.role = selectedRole;
      selectedRole == 'Patient' ? isDoctor = false : isDoctor = true;
    });
  }

  @override
  void initState() {
    Get.put(SignUpController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      bottomNavigationBar: Stack(
        children: [
          ClipPath(
            child: Container(
              color: Colors.blue[400],
              height: 60,
              width: MediaQuery.of(context).size.width,
            ),
            clipper: WaveClipperOne(reverse: true),
          ),
          ClipPath(
            clipBehavior: Clip.hardEdge,
            child: Container(
              color: Colors.blue[600],
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
              ),
            ),
            clipper: WaveClipperTwo(reverse: true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: true,
                      child: FadeAnimation(
                        2.5,
                        IsImagePick
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: FileImage(_image),
                                    radius: 80,
                                  ),
                                  InkWell(
                                    child: Icon(Icons.camera_alt_sharp,
                                        color: white, size: 40),
                                    onTap: () {
                                      chooseDialog();
                                    },
                                  ),
                                ],
                              )
                            : CircleAvatar(
                                radius: 80,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset('assets/images/demo.png'),
                                    InkWell(
                                      child: Icon(Icons.camera_alt_sharp,
                                          color: white, size: 40),
                                      onTap: () {
                                        chooseDialog();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 5),
                    FadeAnimation(
                      2.5,
                      CustomTextField(
                        crontroller: name,
                        error: "Enter Name",
                        label: "Name",
                        keyboard: TextInputType.name,
                        icon: Icon(
                          Icons.person,
                          size: 27,
                          color: blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    FadeAnimation(
                      2.5,
                      CustomTextField(
                        error: 'Enter Valid Phone Number ',
                        crontroller: number,
                        label: "Phone",
                        keyboard: TextInputType.phone,
                        icon: Icon(
                          Icons.phone,
                          size: 27,
                          color: blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select Role ",
                          style: TextStyle(
                              fontSize: 20,
                              color: blue,
                              fontWeight: FontWeight.bold),
                        ),
                        FadeAnimation(
                          1.3,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  new Radio(
                                    fillColor: MaterialStateProperty.all(blue),
                                    value: 0,
                                    hoverColor: Colors.white,
                                    groupValue: _radioValue,
                                    onChanged: (v) =>
                                        _handleRadioValueChange(v),
                                  ),
                                  new Text(
                                    'Doctor',
                                    style: new TextStyle(
                                        fontSize: 16.0, color: blue),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  new Radio(
                                    activeColor: blue,
                                    fillColor: MaterialStateProperty.all(blue),
                                    value: 1,
                                    hoverColor: Colors.white,
                                    groupValue: _radioValue,
                                    onChanged: (v) =>
                                        _handleRadioValueChange(v),
                                  ),
                                  new Text(
                                    'Patient',
                                    style: new TextStyle(
                                        fontSize: 16.0, color: blue),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: true,
                      child: FadeAnimation(
                        0.5,
                        CustomTextField(
                          error: isDoctor
                              ? 'Enter Licence Digits '
                              : "Enter Invitation Code",
                          crontroller: licence,
                          label: isDoctor ? "Licence" : "Invitation Code",
                          keyboard: TextInputType.phone,
                          icon: Icon(
                            Icons.local_activity,
                            size: 27,
                            color: blue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return Get.find<SignUpController>().isLoading.value
                          ? Container(child: CircularProgressIndicator())
                          : CustomButtom(
                              name: "SignUp",
                              bgcolor: blue,
                              forecolor: white,
                              onTap: () async {
                                try {
                                  if (formKey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    var res = await SignUpController().signup();
                                    print(res);
                                    if (res == "ok") {
                                      Get.snackbar(
                                        "Info",
                                        "Sign Up Successfully ...  ",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor:
                                            Colors.green.withOpacity(0.6),
                                        colorText: Colors.white,
                                      );
                                      Get.to(LoginScreen());
                                    } else
                                      Get.snackbar(
                                        "Error",
                                        "$res ...  ",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor:
                                            Colors.red.withOpacity(0.6),
                                        colorText: Colors.white,
                                      );
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    "$e   ",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor:
                                        Colors.red.withOpacity(0.6),
                                    colorText: Colors.white,
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            );
                    }),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              tooltip: "Back",
                              icon: Icon(
                                CupertinoIcons.back,
                                color: blue,
                              )),
                          Text(
                            "Back",
                            style: TextStyle(color: blue),
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? CircularProgressIndicator(
                            backgroundColor: blue,
                          )
                        : Container(
                            child: Text(""),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  chooseDialog() {
    return YYDialog().build(context)
      ..width = 120
      ..height = 110
      ..backgroundColor = Colors.white.withOpacity(1)
      ..borderRadius = 10.0
      ..showCallBack = () {
        print("showCallBack invoke");
      }
      ..gravityAnimationEnable = true
      ..dismissCallBack = () {
        print("dismissCallBack invoke");
      }
      ..widget(Padding(
        padding: EdgeInsets.only(top: 21),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(
                  Icons.camera,
                  color: CustomColor.borderColor,
                ),
                onPressed: () {
                  picker(ImageSource.camera);

                  Navigator.pop(context);
                }),
            IconButton(
                icon: Icon(
                  Icons.photo,
                  color: CustomColor.borderColor,
                ),
                onPressed: () {
                  picker(ImageSource.gallery);
                  Navigator.pop(context);
                }),
          ],
        ),
      ))
      ..widget(Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "Choose One",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ))
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          child: child,
          scale: Tween(begin: 0.0, end: 2.0).animate(animation),
        );
      }
      ..show();
  }

  picker(source) async {
    var permitted = await Permission.camera.request().isGranted;
    if (!permitted) return;
    permitted = await Permission.storage.request().isGranted;
    if (!permitted) return;
    final pickedFile = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        this.IsImagePick = true;

        _image = File(pickedFile.path);
        SignUpController.dp = _image;
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }
}
