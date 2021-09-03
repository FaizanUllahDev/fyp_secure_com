import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fyp_secure_com/admin/view/admin_home.dart';
import 'package:fyp_secure_com/animations/fadeAnimation.dart';
import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';
import 'package:fyp_secure_com/doctor/view/doctor_home.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/pa/view/pa_home.dart';
import 'package:fyp_secure_com/patient/view/patient_home.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CustomsWidget/customTextfield.dart';
import 'index.dart';

typedef void CaretMoved(Offset globalCaretPosition);
typedef void TextChanged(String text);

class OTPScreen extends StatefulWidget {
  final otp;

  const OTPScreen({Key key, this.otp}) : super(key: key);
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<OTPScreen> {
  final otp_c = TextEditingController();
  //List<String> _status = ["Doctor", "Patient"];
  String selectedRole = 'Patient';
  final formKey = GlobalKey<FormState>();
  bool isDoctor = false;

  String animationType = "idle";

  final passwordFocusNode = FocusNode();
  @override
  void initState() {
    LoginController.otp = widget.otp;
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        setState(() {
          animationType = "hands_up";
        });
      } else {
        setState(() {
          animationType = "hands_up";
        });
      }
    });
    super.initState();
    if (!Platform.isWindows)
      ChatController().sendnotify(LoginController.number,
          "OTP IS : " + LoginController.otp.toString(), 16);
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                    maxRadius: 80,
                    backgroundColor: Colors.transparent,
                    child:
                        Lottie.asset('assets/images/timmer.json', height: 150)),
                SizedBox(
                  height: 30,
                ),
                // Container(
                //     margin: EdgeInsets.only(top: 0),
                //     height: 300,
                //     width: 300,
                //     child: CircleAvatar(
                //       child: ClipOval(
                //         child: new FlareActor(
                //           "assets/images/teddy.flr",
                //           alignment: Alignment.center,
                //           antialias: true,
                //           fit: BoxFit.contain,
                //           animation: animationType,
                //         ),
                //       ),
                //       backgroundColor: Colors.transparent,
                //     )),
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                        "PLease Enter OTP \n That is Sending On Your Number 03**",
                        textStyle: TextStyle(fontSize: 20)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                FadeAnimation(
                  2.5,
                  CustomTextField(
                    error: 'Invalid OTP ',
                    crontroller: otp_c,
                    label: "OTP",
                    isPassword: true,
                    foucus: passwordFocusNode,
                    keyboard: TextInputType.phone,
                    icon: Icon(
                      Icons.phone,
                      size: 27,
                      color: blue,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                FadeAnimation(
                  1.5,
                  AnimatedButton(
                    color: blue,
                    text: "Verify",
                    // buttonTextStyle:
                    //     GoogleFonts.aladin(fontSize: 25, color: Colors.white),
                    pressEvent: () => btnPressed(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  btnPressed() async {
    print(otp);
    if (formKey.currentState.validate()) {
      setState(() {
        animationType = "success";
      });
      if (LoginController.whoLogin == "Patient")
        storeData("Patient", PatientHome());
      else if (LoginController.whoLogin.contains("Doctor"))
        storeData("Doctor", DoctorHome());
      else if (LoginController.whoLogin == "Admin")
        storeData("Admin", AdminHome());
      else if (LoginController.whoLogin.toLowerCase() == "pa")
        storeData("pa", PAHome());
    } else {
      setState(() {
        animationType = "fail";
      });
    }
  }

  storeData(role, page) async {
    setState(() {
      animationType = "success";
    });

    try {
      Get.find<ChatController>();
    } catch (e) {
      Get.put(ChatController(), permanent: true);
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("role", role);
    if (LoginController.whoLogin.toLowerCase() == "pa")
      pref.setString("paData", LoginController.status);

    pref.setString("number", LoginController.number);

    Get.find<ChatController>().updateCurrNumber(LoginController.number);

    //print("===> logi ? ${LoginController.status}");
    if (role == "Doctor")
      await pref.setString("status", LoginController.status);
    // print(await pref.get("status"));
    print("\n\n\n\n");
    //Get.forceAppUpdate();
    try {
      Get.find<ChatManager>();
      Get.find<FriendController>();
      FriendController().onInit();
    } catch (e) {
      Get.put(ChatManager(), permanent: true);
      Get.put(FriendController(), permanent: true);
    }
    Get.offAll(page);
  }
}
