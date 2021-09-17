import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AcceptedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patients "),
        elevation: 0,
      ),
      body: Obx(() {
        final _con = Get.find<DoctorHomeController>();
        return _con.invitationAcceptedList.length > 0
            ? Expanded(
                child: ListView.builder(
                  itemCount: _con.invitationAcceptedList.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        Get.snackbar("InFo", "Pending Chats Screen",
                            backgroundColor: Colors.red);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ListTile(
                          title: Text(
                            "${_con.invitationAcceptedList[index].number}",
                            style:
                                GoogleFonts.athiti(color: blue, fontSize: 20),
                          ),
                          trailing: Text(
                              "${_con.invitationAcceptedList[index].status}",
                              style: GoogleFonts.athiti(
                                  color: blue, fontSize: 20)),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Text("Empty ..."),
              );
      }),
    );
  }
}
