import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomsWidget/customTextfield.dart';
import 'index.dart';
import 'loginController.dart';
import 'otpscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final number = TextEditingController();

  //List<String> _status = ["Doctor", "Patient"];

  String animationType = "idle";

  final passwordFocusNode = FocusNode();

  String selectedRole = 'Patient';

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isDoctor = false;
  final controller = Get.put(LoginController());

  @override
  void initState() {
    Get.put(LoginController());
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        setState(() {
          animationType = "idle";
        });
      } else {
        setState(() {
          animationType = "idle";
        });
      }
    });
    super.initState();
  }

  // Container(
  //           height: MediaQuery.of(context).size.height,
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //               image: DecorationImage(
  //                   image: AssetImage("assets/images/login.jpg"),
  //                   fit: BoxFit.contain,
  //                   alignment: Alignment.topCenter)),
  //           child:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                    maxRadius: 100,
                    child: Center(
                        child: Lottie.asset('assets/images/chat.json',
                            height: 250))),
                SizedBox(
                  height: 20,
                ),
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText("Welcome",
                        textStyle: TextStyle(fontSize: 40, color: blue)),
                  ],
                ),
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText("Please Enter Mobile Number",
                        textStyle: TextStyle(fontSize: 20, color: blue)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
                        CustomTextField(
                          error: 'Enter Valid Phone Number ',
                          crontroller: number,
                          label: "Phone",
                          foucus: passwordFocusNode,
                          keyboard: TextInputType.phone,
                          icon: Icon(Icons.phone, size: 27, color: blue),
                        ),
                        SizedBox(height: 40),
                        AnimatedButton(
                          color: blue,
                          pressEvent: () {
                            btnPress();
                          },
                          text: "Login",
                          buttonTextStyle: GoogleFonts.abhayaLibre(
                              color: white, fontSize: 25),
                          isFixedHeight: true,
                        ),
                        isLoading
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.yellow,
                              )
                            : Container(
                                child: Text(""),
                              ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.back,
                          size: 30,
                          color: blue,
                        ),
                        Text(
                          "Back",
                          style: CustomStyles.foreclr.copyWith(color: blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginConditions(role, token) async {
    if (role == 'Doctor' ||
        role == "Patient" ||
        role == "Admin" ||
        role == "PA") {
      LoginController.whoLogin = role;
      int min = 10000; //min and max values act as your 6 digit range
      int max = 99999;
      var randomizer = new Random();
      var rNum = min + randomizer.nextInt(max - min);
      LoginController.otp = rNum;
      otp = rNum;
      if (role != null) {
        LoginController.status = "Accepted";
        status = "Accepted";
      }

      // print(res);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("number", "${LoginController.number}");
      pref.setString("token", token);

      SocketController().sendOTP(LoginController.number, rNum);
      LoginController.otp = rNum;
      print(LoginController.otp);
      setState(() {
        animationType = "success";
        isLoading = false;
      });

      Get.to(OTPScreen(otp: rNum));
    } else {
      toast("Invalid Phone Number", Colors.red);
      setState(() {
        animationType = "fail";
        isLoading = false;
      });
    }
  }

  btnPress() async {
    try {
      if (formKey.currentState.validate()) {
        LoginController.number = number.text;
        bool isDoctorAccept = false, isOtherAccept = false;
        bool doctorStatus = false;
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> res = await LoginController().login();

        //String name = '';
        if (res['role'].toString().toLowerCase() == "doctor") {
          if (res['status'] == "Accepted")
            isDoctorAccept = true;
          else
            doctorStatus = false;
          setState(() {});
        } else if (res['role'] == "PA" ||
            res['role'] == "Admin" ||
            res['role'] == "Patient") {
          isOtherAccept = true;
        }
        if (isDoctorAccept) {
          isOtherAccept = false;
          setState(() {});
          loginConditions(res['role'], res['token']);
        } else if (doctorStatus) {
          toast("Approval Is ${res['Status']}", Colors.red);
          setState(() {
            isLoading = false;
          });
        }

        print("Enter Admin 333");
        if (isOtherAccept) {
          print("PA");
          loginConditions(res['role'], res['token']);
        } else if (!doctorStatus) {
          toast(" Failed", Colors.red);
          setState(() {
            isLoading = false;
          });
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      toast("Something Wrong \n $e", Colors.red);
      setState(() {
        animationType = "fail";
        isLoading = false;
      });
    }
    setState(() {
      animationType = "fail";
      isLoading = false;
    });
  }

  toast(msg, bgcolor) {
    return Get.snackbar(
      "Inf0 ",
      "$msg ...  ",
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgcolor.withOpacity(0.6),
      colorText: Colors.white,
    );
  }
}
