import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllDoctorsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Stack(
        children: [
          ClipPath(
            child: Container(
              color: Colors.blue[400],
              height: 60,
              width: MediaQuery.of(context).size.width,
            ),
            clipper: WaveClipperOne(reverse: true),
          ),
          ClipPath(
            clipBehavior: Clip.hardEdge,
            child: Container(
              color: Colors.blue[600],
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
              ),
            ),
            clipper: WaveClipperTwo(reverse: true),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("All Dcotors "),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  child: Container(
                    color: Colors.blue[600],
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                  ),
                  clipper: WaveClipperOne(reverse: false),
                ),
                ClipPath(
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    color: Colors.blue,
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.center,
                    ),
                  ),
                  clipper: WaveClipperTwo(reverse: false),
                ),
              ],
            ),
            Obx(() {
              final _con = Get.find<DoctorHomeController>();
              return _con.doctor_list.length > 0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _con.doctor_list.length,
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () {
                              Get.snackbar("InFo", "Pending Chats Screen",
                                  backgroundColor: Colors.red);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: ListTile(
                                autofocus: true,
                                dense: true,
                                minVerticalPadding: 5,
                                visualDensity:
                                    VisualDensity.adaptivePlatformDensity,
                                leading: Text("${index + 1}",
                                    style: GoogleFonts.athiti(
                                        color: blue, fontSize: 20)),
                                title: Text(
                                  "${_con.doctor_list[index].name}"
                                      .toUpperCase(),
                                  style: GoogleFonts.athiti(
                                      color: blue, fontSize: 20),
                                ),
                                subtitle: Text(
                                  "${_con.doctor_list[index].number}",
                                  style: GoogleFonts.athiti(
                                      color: blue, fontSize: 20),
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.person_add,
                                    color: Colors.green[900],
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
