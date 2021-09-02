import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/chats/conversation.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class AllAcceptedFriend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Conatcts "),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Doctors",
              ),
              Tab(
                text: "Patients",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LiquidPullToRefresh(
              backgroundColor: white,
              color: Colors.blue,
              borderWidth: 1.0,
              height: 50,
              showChildOpacityTransition: true,
              onRefresh: () async {
                FriendController().onInit();
              },
              child: Obx(
                () => Get.find<FriendController>().accepted_Friend_List.length >
                        0
                    ? Container(
                        padding: EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 20),
                        child: ListView.builder(
                          itemCount: Get.find<FriendController>()
                              .accepted_Friend_List
                              .length,
                          itemBuilder: (ctx, index) {
                            FriendsModel model = Get.find<FriendController>()
                                .accepted_Friend_List[index];
                            if (model.role.toLowerCase() == "doctor")
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      // color: blue,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(ConversationPage(
                                          roomList: RoomList(
                                              phone: model.phone,
                                              name: model.name,
                                              pic: ''),
                                        ));
                                      },
                                      leading: Icon(
                                        Icons.person_pin_circle_rounded,
                                        size: 35,
                                        color: blue,
                                      ),
                                      title: Text(
                                        "${model.name}".toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(model.phone,
                                          style: TextStyle(
                                              fontSize: 17, color: blue)),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: blue,
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                  ),
                                ],
                              );
                            else
                              return Container();
                          },
                        ))
                    : Container(
                        color: white,
                        child: Center(
                          child: Text(
                            'Empty \n No  Found',
                            style: CustomStyles.foreclr.copyWith(color: blue),
                          ),
                        ),
                      ),
              ),
            ),
            LiquidPullToRefresh(
              backgroundColor: white,
              color: Colors.blue,
              borderWidth: 1.0,
              height: 50,
              showChildOpacityTransition: true,
              onRefresh: () async {
                FriendController().onInit();
              },
              child: Obx(
                () => Get.find<FriendController>().accepted_Friend_List.length >
                        0
                    ? Container(
                        padding: EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 20),
                        child: ListView.builder(
                          itemCount: Get.find<FriendController>()
                              .accepted_Friend_List
                              .length,
                          itemBuilder: (ctx, index) {
                            FriendsModel model = Get.find<FriendController>()
                                .accepted_Friend_List[index];
                            if (model.role.toLowerCase() == "patient")
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.only(
                                      left: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      // color: blue,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Get.to(ConversationPage(
                                          roomList: RoomList(
                                              phone: model.phone,
                                              name: model.name,
                                              pic: ''),
                                        ));
                                      },
                                      leading: Icon(
                                        Icons.person_pin_circle_rounded,
                                        size: 35,
                                        color: blue,
                                      ),
                                      title: Text(
                                        "${model.name}".toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(model.phone,
                                          style: TextStyle(
                                              fontSize: 17, color: blue)),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: blue,
                                    width: MediaQuery.of(context).size.width,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30),
                                  ),
                                ],
                              );
                            else
                              return Container();
                          },
                        ))
                    : Container(
                        color: white,
                        child: Center(
                          child: Text(
                            'Empty \n No  Found',
                            style: CustomStyles.foreclr.copyWith(color: blue),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
