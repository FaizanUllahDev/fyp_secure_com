import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';

import '../commonAtStart/index.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final Widget icon;
  final bool isPassword;
  final crontroller;
  final keyboard;
  final error;
  final foucus;
  final onCaretMoved;
  final onTextChanged;
  final fieldKey;

  const CustomTextField(
      {this.error,
      this.label = "",
      this.onCaretMoved,
      this.onTextChanged,
      this.fieldKey,
      this.icon = const Icon(Icons.ac_unit),
      this.isPassword = false,
      this.crontroller,
      this.foucus,
      this.keyboard});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (txt) {
        if (widget.label == "Phone") {
          if (txt.length < 10) {
            return widget.error;
          } else {
            SignUpController.number = txt;
            return null;
          }
        } else if (widget.label == "Name") {
          if (txt.length < 1) {
            return widget.error;
          } else {
            SignUpController.name = txt;
            return null;
          }
        } else if (widget.label == "OTP") {
          if (txt.length < 1 || LoginController.otp != int.parse(txt)) {
            return widget.error;
          } else {
            LoginController.otp = int.parse(txt);
            return null;
          } //Invitation Code
        } else if (widget.label == "Invitation Code") {
          if (txt.length < 1) {
            return widget.error;
          } else {
            SignUpController.licence = txt;
            return null;
          }
        } else if (widget.label == "Enter Group Name") {
          return txt.length == 0 ? widget.error : null;
        } else {
          if (txt.length < 9) {
            return widget.error;
          } else {
            SignUpController.licence = txt;
            return null;
          }
        }
      },
      controller: this.widget.crontroller,
      focusNode: widget.foucus,
      style: TextStyle(color: blue, fontWeight: FontWeight.bold),
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: blue, width: 1.0)),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: blue, width: 1.0)),
        labelText: widget.label,
        labelStyle: TextStyle(color: blue, fontWeight: FontWeight.bold),
        suffixIcon: widget.icon,
      ),
      keyboardType: this.widget.keyboard,
    );
  }
}
