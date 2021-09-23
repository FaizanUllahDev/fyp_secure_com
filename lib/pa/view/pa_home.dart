import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/all_controller.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/doctor/view/invitation_list_page.dart';
import 'package:fyp_secure_com/pa/view/patient_list.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PAHome extends StatefulWidget {
  @override
  _PAHomeState createState() => _PAHomeState();
}

class _PAHomeState extends State<PAHome> {
  var asgId = '';
  String name = '';
  atStart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    asgId = pref.getString("paData");
    LoginController.number = pref.get("number");
    print(LoginController.number);
    print("PA");
    print("ASG _ ID :  " + asgId);

    String url = APIHOST + ASSETS;
    var res = await http.post(Uri.parse(url),
        body: {"phone": "${LoginController.number}", "table": "pa"});
    if (res.statusCode == 200) {
      asgId = jsonDecode(res.body)['asgTo'];
      res = await http
          .post(Uri.parse(url), body: {"phone": "$asgId", "table": "doctor"});
      if (res.statusCode == 200) {
        name = jsonDecode(res.body)['name'];
      }
    }
    print(res.body);
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                logout();
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.blue,
              )),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "PA to $name",
                style: TextStyle(fontSize: 30, color: Colors.blue),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        //asgId
                        Get.to(AddRecord(number: asgId));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: blue,
                        ),
                        child: Center(
                          child: Text(
                            "Add Record",
                            style: TextStyle(color: white, fontSize: 24),
                          ),
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
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: blue,
                        ),
                        child: Center(
                          child: Text(
                            "Invite Patient",
                            style: TextStyle(color: white, fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
