import 'package:flutter/material.dart';
import 'package:fyp_secure_com/admin/view/admin_home.dart';
import 'package:fyp_secure_com/admin/view/doctor_accepted_list.dart';
import 'package:fyp_secure_com/admin/view/doctor_blocked.dart';
import 'package:fyp_secure_com/admin/view/doctor_rejected_list.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:get/get.dart';

class customDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Admin",
      elevation: 26.0,
      child: Container(
        color: blue,
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
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/demo.png"),
                    radius: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Admin"),
                ],
              ),
              curve: Curves.easeOutExpo,
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () => Get.offAll(AdminHome()),
                child: Text(
                  "Pending List",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () => Get.offAll(AdminRejectedList()),
                child: Text(
                  "Rejected List",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () => Get.offAll(AdminAcceptList()),
                child: Text(
                  "Accepted List",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () => Get.offAll(AdminBlockedList()),
                child: Text(
                  "Block List",
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
