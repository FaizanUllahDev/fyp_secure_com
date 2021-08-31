import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/profile.dart';
import 'package:fyp_secure_com/chats/archive_chat.dart';
import 'package:fyp_secure_com/chats/chats_all_room.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/all_controller.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/friend_list_handler/views/tabs/recieve_requests.dart';
import 'package:fyp_secure_com/patient/controller/patient_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientHome extends StatefulWidget {
  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  var img = '';
  atStart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    img = pref.getString("img");
    setState(() {});
    print(img);
  }

  @override
  void initState() {
    super.initState();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PatientController());
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: white),
          backgroundColor: blue,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            enableFeedback: true,
            automaticIndicatorColorAdjustment: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.chat,
                    ),
                    Text("  Chat")
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add_alt_1_outlined,
                    ),
                    Text(" Request")
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.archive_outlined,
                    ),
                    Text(" Archive")
                  ],
                ),
              ),
            ],
          ),
          title: Obx(() => InkWell(
                onTap: () {
                  print(Get.find<ChatController>().curImg.value);
                  Get.to(Profile());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Get.find<ChatController>().curImg.value == ''
                        ? CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/demo.png'))
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                                '$FILES_IMG${Get.find<ChatController>().curImg.value}'),
                          ),
                    SizedBox(
                      width: 3,
                    ),
                    //${Get.find<PatientController>().number.value}
                    Text(
                      "${Get.find<ChatController>().currName.value.toUpperCase()}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: white,
                      ),
                    ),
                  ],
                ),
              )),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () async {
                logout();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ChatAllRoomPage(),
            // Sendingrequest(),
            FriendRequest(),
            ArchiveChat(),
          ],
        ),
      ),
    );
  }
}
