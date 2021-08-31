import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/navbar.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/all_controller.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/chats/chats_all_room.dart';
import 'package:fyp_secure_com/doctor/view/drawer.dart';
import 'package:fyp_secure_com/friend_list_handler/views/tabs/recieve_requests.dart';
import 'package:fyp_secure_com/friend_list_handler/views/tabs/send_request.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class DoctorHome extends StatefulWidget {
  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    Get.put(DoctorHomeController(), permanent: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: LiquidPullToRefresh(
        onRefresh: () async {},
        child: Scaffold(
          bottomNavigationBar: getNavBar(0, context),
          appBar: AppBar(
            actionsIconTheme: IconThemeData(color: white),
            elevation: 0,
            title: TabBar(
              isScrollable: true,
              enableFeedback: true,
              automaticIndicatorColorAdjustment: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
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
      ),
    );
  }
}
