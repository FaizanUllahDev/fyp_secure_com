import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/custombutton.dart';
import 'package:fyp_secure_com/animations/fadeAnimation.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/index.dart';
import 'package:fyp_secure_com/commonAtStart/login.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class StartExploer extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StartExploer> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      2.4,
                      Text("Welcome To",
                          style: TextStyle(
                              color: blue, fontSize: 22, letterSpacing: 2))),
                  FadeAnimation(
                      2.6,
                      Text("Secure Communication",
                          style: TextStyle(
                              color: blue,
                              fontSize: 40,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Lottie.asset(
                      "assets/images/doctor_move.json",
                    ),
                    SizedBox(height: 50),
                    FadeAnimation(
                        1.5,
                        CustomButtom(
                          name: "Login",
                          bgcolor: blue,
                          forecolor: white,
                          onTap: () {
                            Get.to(LoginScreen());
                          },
                        )),
                    SizedBox(height: 10),
                    FadeAnimation(
                        2.0,
                        CustomButtom(
                          name: "Sign Up",
                          bgcolor: blue,
                          forecolor: white,
                          onTap: () {
                            Get.to(SignUp());
                          },
                        )),
                    SizedBox(height: 30),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
