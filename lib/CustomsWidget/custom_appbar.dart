import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:lottie/lottie.dart';

class CustomAppBar extends StatelessWidget {
  final profile;
  final name;
  final number;

  const CustomAppBar({this.profile, this.name, this.number});
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: Container(
          padding: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                child: Stack(
                  children: [
                    Lottie.asset("assets/images/profile.json"),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText("Welcome, $name \n     $number   "),
                ],
              ),
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height));
  }
}
