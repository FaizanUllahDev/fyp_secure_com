import 'package:flutter/material.dart';

import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllDoctorsList extends StatefulWidget {
  @override
  State<AllDoctorsList> createState() => _AllDoctorsListState();
}

class _AllDoctorsListState extends State<AllDoctorsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Dcotors "),
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    fillColor: white,
                    filled: true,
                    hintText: "Search .. ",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 70)),
      ),
      body: Obx(() {
        final _con = Get.find<DoctorHomeController>();
        return _con.doctor_list.length > 0
            ? ListView.builder(
                itemCount: _con.doctor_list.length,
                itemBuilder: (ctx, index) {
                  FriendsModel found = Get.find<FriendController>()
                      .accepted_Friend_List
                      .firstWhere(
                          (element) =>
                              element.phone == _con.doctor_list[index].phone,
                          orElse: () =>
                              FriendsModel("", '', "", "", false, ""));
                  if (found.name == "")
                    return InkWell(
                        // onTap: () {
                        //   Get.snackbar("InFo", "Pending Chats Screen",
                        //       backgroundColor: Colors.red);
                        // },
                        child: Column(
                      children: [
                        ListTile(
                          minVerticalPadding: 5,
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          leading: CircleAvatar(
                            child: Text(
                                _con.doctor_list[index].name[0].toUpperCase()),
                          ),
                          title: Text(
                            "${_con.doctor_list[index].name}".toUpperCase(),
                            style:
                                GoogleFonts.athiti(color: blue, fontSize: 20),
                          ),
                          subtitle: Text(
                            "${_con.doctor_list[index].phone}",
                            style:
                                GoogleFonts.athiti(color: blue, fontSize: 15),
                          ),
                          trailing: TextButton(
                              onPressed: () async {
                                _con.doctor_list[index].status == "Accept"
                                    ? _con.doctor_list[index].status =
                                        await FriendController().updateFriendReq(
                                            _con.doctor_list[index].phone,
                                            Get.find<ChatController>()
                                                .currNumber
                                                .value,
                                            'UnFriend',
                                            index)
                                    : _con.doctor_list[index].status ==
                                            "Request"
                                        ? _con.doctor_list[index].status =
                                            await FriendController().updateFriendReq(
                                                Get.find<ChatController>()
                                                    .currNumber
                                                    .value,
                                                _con.doctor_list[index].phone,
                                                'UnFriend',
                                                index)
                                        : _con.doctor_list[index].status =
                                            await FriendController()
                                                .updateFriendReq(
                                                    Get.find<ChatController>()
                                                        .currNumber
                                                        .value,
                                                    _con.doctor_list[index].phone,
                                                    'Request',
                                                    index);
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.blue,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        color: Colors.black38,
                                      )
                                    ]),
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _con.doctor_list[index].status == "Accept"
                                        ? Icon(
                                            Icons.person_remove_alt_1_outlined,
                                            color: white,
                                          )
                                        : _con.doctor_list[index].status ==
                                                "Request"
                                            ? Icon(
                                                Icons
                                                    .person_remove_alt_1_outlined,
                                                color: white,
                                              )
                                            : Icon(
                                                Icons.person_add_alt,
                                                color: white,
                                              ),
                                    _con.doctor_list[index].status == "Accept"
                                        ? Text(
                                            "Remove ",
                                            style: TextStyle(color: white),
                                          )
                                        : _con.doctor_list[index].status ==
                                                "Request"
                                            ? Text(
                                                "Cancel ",
                                                style: TextStyle(color: white),
                                              )
                                            : Text(
                                                "Add ",
                                                style: TextStyle(color: white),
                                              ),
                                  ],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ));
                  return Container();
                },
              )
            : Center(
                child: Text("Empty ..."),
              );
      }),
    );
  }
}
