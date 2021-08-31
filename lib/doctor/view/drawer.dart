import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/profile.dart';
import 'package:fyp_secure_com/chats/archive_chat.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/doctor/view/doctor_home.dart';
import 'package:fyp_secure_com/doctor/view/invitation_list_page.dart';
import 'package:get/get.dart';

class DocDrawer extends StatefulWidget {
  @override
  State<DocDrawer> createState() => _DocDrawerState();
}

class _DocDrawerState extends State<DocDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 8.0,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            arrowColor: Colors.green,
            currentAccountPicture:
                Get.find<ChatController>().curImg.value.isEmpty
                    ? CircleAvatar(
                        backgroundImage: AssetImage("assets/images/demo.png"))
                    : CircleAvatar(
                        backgroundImage: NetworkImage(
                            '$FILES_IMG${Get.find<ChatController>().curImg.value}'),
                      ),
            onDetailsPressed: () {
              Get.to(Profile());
            },
            accountName: Text(Get.find<ChatController>().currName.value),
            accountEmail: Text(Get.find<ChatController>().currNumber.value),
          ),
          TextButton(
            onPressed: () {
              Get.to(DoctorHome());
            },
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.home_filled,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Home",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              Get.to(InvitationListPage());
            },
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.person_add_alt_1,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Invite",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              Get.to(ArchiveChat());
            },
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.archive_sharp,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Archive",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
