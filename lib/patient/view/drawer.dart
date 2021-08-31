import 'package:flutter/material.dart';
import 'package:fyp_secure_com/admin/view/admin_home.dart';
import 'package:fyp_secure_com/admin/view/doctor_accepted_list.dart';
import 'package:fyp_secure_com/admin/view/doctor_blocked.dart';
import 'package:fyp_secure_com/admin/view/doctor_rejected_list.dart';
import 'package:get/get.dart';

class customDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Pateint",
      elevation: 26.0,
      child: Container(
        padding: EdgeInsets.only(left: 30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            DrawerHeader(
              //margin: EdgeInsets.only(left: 20),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/login.jpg"),
                radius: 50,
              ),
              curve: Curves.easeOutExpo,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(30),
              //   gradient: LinearGradient(
              //     colors: [Colors.black12, Colors.white10],
              //   ),
              // ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: () => Get.offAll(AdminHome()),
                child: Text(
                  "",
                  style: TextStyle(fontSize: 30),
                )),
            SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: () => Get.offAll(AdminRejectedList()),
                child: Text(
                  "Rejected List",
                  style: TextStyle(fontSize: 30),
                )),
            SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: () => Get.offAll(AdminAcceptList()),
                child: Text(
                  "Accepted List",
                  style: TextStyle(fontSize: 30),
                )),
            SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: () => Get.offAll(AdminBlockedList()),
                child: Text(
                  "Block List",
                  style: TextStyle(fontSize: 30),
                )),
          ],
        ),
      ),
    );
  }
}
