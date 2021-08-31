import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final name, onTap, bgcolor, forecolor;

  const CustomButtom({this.bgcolor, this.forecolor, this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "$name",
            style: TextStyle(
                fontSize: 30, color: forecolor, fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }
}
