import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/CustomsWidget/navbar.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/doctor/view/patient_invitation.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvitationListPage extends StatefulWidget {
  @override
  State<InvitationListPage> createState() => _InvitationListPageState();
}

class _InvitationListPageState extends State<InvitationListPage> {
  var role = '';
  atStart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString('role');
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pending Invitations ",
          style: TextStyle(color: white),
        ),
        elevation: 0,
      ),
      bottomNavigationBar: role == 'Doctor'
          ? getNavBar(1, context)
          : Container(
              height: 0,
            ),
      body: Obx(() {
        final _con = Get.find<DoctorHomeController>();
        return _con.invitationList.length > 0
            ? ListView.builder(
                itemCount: _con.invitationList.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.5,
                          secondaryActions: [
                            IconSlideAction(
                              caption: 'Cencel',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => print("object"),
                            ),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(
                                Icons.person_pin,
                                color: blue,
                              ),
                              title: Text(
                                "${_con.invitationList[index].number}",
                                style: GoogleFonts.athiti(color: blue),
                              ),
                              trailing: Text(
                                  "${_con.invitationList[index].status}"
                                      .toUpperCase(),
                                  style: GoogleFonts.athiti(color: blue)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: blue,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                      ),
                    ],
                  );
                },
              )
            : Center(
                child: Text("Empty ..."),
              );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          Get.to(InvitePatient());
        },
        child: Icon(
          Icons.add,
          color: white,
        ),
      ),
    );
  }
}
