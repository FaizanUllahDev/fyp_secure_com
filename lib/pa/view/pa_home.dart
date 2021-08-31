import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/custombutton.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/all_controller.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/doctor/view/invitation_list_page.dart';
import 'package:fyp_secure_com/pa/view/patient_list.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PAHome extends StatefulWidget {
  @override
  _PAHomeState createState() => _PAHomeState();
}

class _PAHomeState extends State<PAHome> {
  var asgId = '';
  atStart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    asgId = pref.getString("paData");
    LoginController.number = pref.get("number");
    print("PA");
    print("ASG _ ID :  " + asgId);
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    Get.put(DoctorHomeController());
    super.initState();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PA of $asgId"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(Icons.logout_outlined)),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  //asgId
                  Get.to(AddRecord(number: asgId));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: blue,
                  ),
                  child: Text(
                    "Add New Record",
                    style: TextStyle(color: white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.to(InvitationListPage());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: blue,
                  ),
                  child: Text(
                    "Invite Patient",
                    style: TextStyle(color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
