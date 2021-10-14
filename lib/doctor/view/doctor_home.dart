import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/navbar.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/chats/chats_all_room.dart';
import 'package:fyp_secure_com/friend_list_handler/views/tabs/recieve_requests.dart';
import 'package:fyp_secure_com/friend_list_handler/views/tabs/send_request.dart';
import 'package:get/get.dart';

class DoctorHome extends StatefulWidget {
  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  void initState() {
    super.initState();

    Get.put(DoctorHomeController(), permanent: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: getNavBar(0, context),
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: white),
          elevation: 0,
          title: TabBar(
            isScrollable: true,
            enableFeedback: true,
            automaticIndicatorColorAdjustment: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black54,
            labelPadding: EdgeInsets.symmetric(horizontal: 30),
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
                      Icons.notifications_active_rounded,
                    ),
                    Text(" Request")
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add_sharp,
                    ),
                    Text(" Doctors")
                  ],
                ),
              ),
            ],
          ),
        ),
        //  drawer: DocDrawer(),
        body: TabBarView(
          children: [
            ChatAllRoomPage(),
            FriendRequest(),
            Sendingrequest(),
          ],
        ),
      ),
    );
  }
}
