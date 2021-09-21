import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/search_contacts.dart';
import 'package:fyp_secure_com/chats/conversation.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllAcceptedFriend extends StatefulWidget {
  @override
  State<AllAcceptedFriend> createState() => _AllAcceptedFriendState();
}

class _AllAcceptedFriendState extends State<AllAcceptedFriend> {
  String role = "Doctor";
  atStart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString("role");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: role == "Doctor" ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Contacts "),
          bottom: role == "Doctor"
              ? TabBar(
                  tabs: [
                    Tab(
                      text: "Doctors",
                    ),
                    Tab(
                      text: "Patients",
                    ),
                  ],
                )
              : TabBar(
                  tabs: [
                    Tab(
                      text: "Doctors",
                    ),
                  ],
                ),
        ),
        body: role == "Doctor"
            ? TabBarView(
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
                      () => Get.find<FriendController>()
                                  .accepted_Friend_List
                                  .length >
                              0
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(SearchContect(
                                      lst: Get.find<FriendController>()
                                          .accepted_Friend_List
                                          .where((p0) =>
                                              p0.role.toLowerCase() == "doctor")
                                          .toList(),
                                    ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    width: MediaQuery.of(context).size.width,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Search",
                                        style: TextStyle(color: white),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          top: 20,
                                          left: 10,
                                          right: 10,
                                          bottom: 20),
                                      child: ListView.builder(
                                        itemCount: Get.find<FriendController>()
                                            .accepted_Friend_List
                                            .length,
                                        itemBuilder: (ctx, index) {
                                          FriendsModel model =
                                              Get.find<FriendController>()
                                                  .accepted_Friend_List[index];
                                          if (model.role.toLowerCase() ==
                                              "doctor")
                                            return Column(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  padding: EdgeInsets.only(
                                                    left: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    // color: blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35),
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
                                                      Icons
                                                          .person_pin_circle_rounded,
                                                      size: 35,
                                                      color: blue,
                                                    ),
                                                    title: Text(
                                                      "${model.name}"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          color: blue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Text(model.phone,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: blue)),
                                                  ),
                                                ),
                                                Container(
                                                  height: 1,
                                                  color: blue,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 30),
                                                ),
                                              ],
                                            );
                                          else
                                            return Container();
                                        },
                                      )),
                                ),
                              ],
                            )
                          : Container(
                              color: white,
                              child: Center(
                                child: Text(
                                  'Empty \n No  Found',
                                  style: CustomStyles.foreclr
                                      .copyWith(color: blue),
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
                      () => Get.find<FriendController>()
                                  .accepted_Friend_List
                                  .length >
                              0
                          ? Expanded(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(SearchContect(
                                        lst: Get.find<FriendController>()
                                            .accepted_Friend_List
                                            .where((p0) =>
                                                p0.role.toLowerCase() !=
                                                "doctor")
                                            .toList(),
                                      ));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Search",
                                          style: TextStyle(color: white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        padding: EdgeInsets.only(
                                            top: 20,
                                            left: 10,
                                            right: 10,
                                            bottom: 20),
                                        child: ListView.builder(
                                          itemCount:
                                              Get.find<FriendController>()
                                                  .accepted_Friend_List
                                                  .length,
                                          itemBuilder: (ctx, index) {
                                            FriendsModel model = Get.find<
                                                    FriendController>()
                                                .accepted_Friend_List[index];
                                            if (model.role.toLowerCase() ==
                                                "patient")
                                              return Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    padding: EdgeInsets.only(
                                                      left: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      // color: blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              35),
                                                    ),
                                                    child: ListTile(
                                                      onTap: () {
                                                        Get.to(ConversationPage(
                                                          roomList: RoomList(
                                                              phone:
                                                                  model.phone,
                                                              name: model.name,
                                                              pic: ''),
                                                        ));
                                                      },
                                                      leading: Icon(
                                                        Icons
                                                            .person_pin_circle_rounded,
                                                        size: 35,
                                                        color: blue,
                                                      ),
                                                      title: Text(
                                                        "${model.name}"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            color: blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                          model.phone,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color: blue)),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    color: blue,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 30),
                                                  ),
                                                ],
                                              );
                                            else
                                              return Container();
                                          },
                                        )),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              color: white,
                              child: Center(
                                child: Text(
                                  'Empty \n No  Found',
                                  style: CustomStyles.foreclr
                                      .copyWith(color: blue),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              )
            : TabBarView(
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
                      () => Get.find<FriendController>()
                                  .accepted_Friend_List
                                  .length >
                              0
                          ? Container(
                              padding: EdgeInsets.only(
                                  top: 20, left: 10, right: 10, bottom: 20),
                              child: ListView.builder(
                                itemCount: Get.find<FriendController>()
                                    .accepted_Friend_List
                                    .length,
                                itemBuilder: (ctx, index) {
                                  FriendsModel model =
                                      Get.find<FriendController>()
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
                                            borderRadius:
                                                BorderRadius.circular(35),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 30),
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
                                  style: CustomStyles.foreclr
                                      .copyWith(color: blue),
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
