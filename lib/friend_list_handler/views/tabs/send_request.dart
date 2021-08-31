import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/doctor/view/search_doctor.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Sendingrequest extends StatefulWidget {
  @override
  State<Sendingrequest> createState() => _SendingrequestState();
}

class _SendingrequestState extends State<Sendingrequest> {
  String CurStatus = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LiquidPullToRefresh(
      backgroundColor: white,
      color: Colors.blue,
      borderWidth: 1.0,
      height: 50,
      showChildOpacityTransition: true,
      onRefresh: () async {
        FriendController().onInit();
      },
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(SearchDoctor());
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
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
            child: Obx(() {
              List<FriendsModel> send_list =
                  Get.find<FriendController>().doctorLists;
              return send_list.length > 0
                  ? Container(
                      color: white,
                      child: ListView.builder(
                        itemCount: send_list.length,
                        itemBuilder: (ctx, index) {
                          FriendsModel model = send_list[index];
                          FriendsModel found = send_list.firstWhere(
                              (ele) => ele.phone == model.phone,
                              orElse: () =>
                                  FriendsModel("", "", '', "", false));
                          FriendsModel foundAtRequest =
                              Get.find<FriendController>()
                                  .request_of_Friend
                                  .firstWhere((ele) => ele.phone == model.phone,
                                      orElse: () =>
                                          FriendsModel("", "", '', "", false));

                          if (foundAtRequest.phone != "" &&
                              model.status != "Accept")
                            return Container();
                          else if (found.phone != "" &&
                              model.status != "Accept") {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  padding: EdgeInsets.only(top: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "${model.name}".toUpperCase(),
                                      style: CustomStyles.bgclr
                                          .copyWith(color: blue),
                                    ),
                                    subtitle: Text(
                                      model.phone,
                                      style: CustomStyles.bgclr
                                          .copyWith(color: blue),
                                    ),
                                    //   trailing: Text("Joined"),
                                    trailing: FloatingActionButton.extended(
                                      onPressed: () async {
                                        model.status == "Accept"
                                            ? model
                                                    .status =
                                                await FriendController()
                                                    .updateFriendReq(
                                                        model.phone,
                                                        Get.find<ChatController>()
                                                            .currNumber
                                                            .value,
                                                        'UnFriend',
                                                        index)
                                            : model.status == "Request"
                                                ? model.status = await FriendController()
                                                    .updateFriendReq(
                                                        Get.find<ChatController>()
                                                            .currNumber
                                                            .value,
                                                        model.phone,
                                                        'UnFriend',
                                                        index)
                                                : model
                                                        .status =
                                                    await FriendController()
                                                        .updateFriendReq(
                                                            Get.find<ChatController>()
                                                                .currNumber
                                                                .value,
                                                            model.phone,
                                                            'Request',
                                                            index);
                                        setState(() {});
                                        //setState(() {
                                        // model.status == "Accept"
                                        //     ? model.status = "UnJoin"
                                        //     : model.status == "Request"
                                        //         ? model.status = "Cancel"
                                        //         : model.status = "Join";
                                        // });
                                        print("......." + model.status);
                                      },
                                      label: model.status == "Accept"
                                          ? Text("Joined")
                                          : model.status == "Request"
                                              ? Text("Cancel")
                                              : Text("Join"),
                                      icon: model.status == "Accept"
                                          ? Icon(Icons
                                              .person_remove_alt_1_outlined)
                                          : model.status == "Request"
                                              ? Icon(Icons
                                                  .person_remove_alt_1_outlined)
                                              : Icon(Icons.person_add_alt),
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
                          } else if (model.status != "Accept")
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  padding: EdgeInsets.only(top: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "${model.name}".toUpperCase(),
                                      style: CustomStyles.bgclr
                                          .copyWith(color: blue),
                                    ),
                                    subtitle: Text(
                                      model.phone,
                                      style: CustomStyles.bgclr
                                          .copyWith(color: blue),
                                    ),
                                    trailing: FloatingActionButton.extended(
                                      onPressed: () async {
                                        model.status == "Accept"
                                            ? model
                                                    .status =
                                                await FriendController()
                                                    .updateFriendReq(
                                                        model.phone,
                                                        Get.find<ChatController>()
                                                            .currNumber
                                                            .value,
                                                        'UnFriend',
                                                        index)
                                            : model.status == "Request"
                                                ? model.status = await FriendController()
                                                    .updateFriendReq(
                                                        Get.find<ChatController>()
                                                            .currNumber
                                                            .value,
                                                        model.phone,
                                                        'UnFriend',
                                                        index)
                                                : model
                                                        .status =
                                                    await FriendController()
                                                        .updateFriendReq(
                                                            Get.find<ChatController>()
                                                                .currNumber
                                                                .value,
                                                            model.phone,
                                                            'Request',
                                                            index);
                                        setState(() {});
                                        //setState(() {
                                        // model.status == "Accept"
                                        //     ? model.status = "UnJoin"
                                        //     : model.status == "Request"
                                        //         ? model.status = "Cancel"
                                        //         : model.status = "Join";
                                        // });
                                        print("......." + model.status);
                                      },
                                      label: model.status == "Accept"
                                          ? Text("UnJoin")
                                          : model.status == "Request"
                                              ? Text("Cancel")
                                              : Text("Join"),
                                      icon: model.status == "Accept"
                                          ? Icon(Icons
                                              .person_remove_alt_1_outlined)
                                          : model.status == "Request"
                                              ? Icon(Icons
                                                  .person_remove_alt_1_outlined)
                                              : Icon(Icons.person_add_alt),
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
                          else
                            return Container();
                        },
                      ))
                  : Container(
                      color: white,
                      child: Center(
                        child: Text(
                          'Empty ',
                          style: CustomStyles.foreclr.copyWith(color: blue),
                        ),
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
