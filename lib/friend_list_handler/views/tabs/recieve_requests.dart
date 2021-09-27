import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class FriendRequest extends StatefulWidget {
  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      backgroundColor: white,
      color: Colors.blue,
      borderWidth: 1.0,
      height: 50,
      showChildOpacityTransition: true,
      onRefresh: () async {
        FriendController().onInit();
      },
      child: Obx(() {
        List<FriendsModel> req_list =
            Get.find<FriendController>().request_of_Friend;
        return req_list.length > 0
            ? Container(
                color: white,
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: req_list.length,
                        itemBuilder: (ctx, index) {
                          FriendsModel model = req_list[index];
                          if (model.status != "Accept")
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(
                                    left: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    //color: blue,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    secondaryActions: model.status == 'Request'
                                        ? [
                                            IconSlideAction(
                                              caption: 'Confirm',
                                              color: Colors.green,
                                              icon: Icons.person_pin,
                                              onTap: () async {
                                                model.status =
                                                    await FriendController()
                                                        .updateFriendReq(
                                                            model.phone,
                                                            Get.find<
                                                                    ChatController>()
                                                                .currNumber
                                                                .value,
                                                            'Accept',
                                                            index);
                                                setState(() {});
                                              },
                                            ),
                                            IconSlideAction(
                                              caption: 'Reject',
                                              color: Colors.red,
                                              icon: Icons
                                                  .person_add_disabled_outlined,
                                              onTap: () async {
                                                model.status =
                                                    await FriendController()
                                                        .updateFriendReq(
                                                            model.phone,
                                                            Get.find<
                                                                    ChatController>()
                                                                .currNumber
                                                                .value,
                                                            'Reject',
                                                            index);
                                                setState(() {});
                                              },
                                            ),
                                          ]
                                        : [
                                            IconSlideAction(
                                              caption: 'UnJoin',
                                              color: Colors.red,
                                              icon: Icons
                                                  .person_add_disabled_outlined,
                                              onTap: () => FriendController()
                                                  .updateFriendReq(
                                                      model.phone,
                                                      Get.find<ChatController>()
                                                          .currNumber
                                                          .value,
                                                      'Reject',
                                                      index),
                                            ),
                                          ],
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.person_pin_circle_rounded,
                                        size: 30,
                                        color: blue,
                                      ),
                                      title: Text(
                                        "${model.name}".toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: blue),
                                      ),
                                      // trailing: model.status == 'Request'
                                      //     ? Container(
                                      //         padding: EdgeInsets.symmetric(
                                      //             horizontal: 15, vertical: 8),
                                      //         decoration: BoxDecoration(
                                      //             color: blue,
                                      //             borderRadius:
                                      //                 BorderRadius.circular(
                                      //                     30)),
                                      //         child: Text("",
                                      //             style:
                                      //                 TextStyle(color: white)),
                                      //       )
                                      //     : Container(
                                      //         padding: EdgeInsets.symmetric(
                                      //             horizontal: 7, vertical: 7),
                                      //         decoration: BoxDecoration(
                                      //             color: blue,
                                      //             borderRadius:
                                      //                 BorderRadius.circular(
                                      //                     30)),
                                      //         child: Text("Confirmed",
                                      //             style:
                                      //                 TextStyle(color: white)),
                                      //       ),

                                      subtitle: Text(model.phone,
                                          style: TextStyle(
                                              fontSize: 17, color: blue)),
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
                      ),
                    ),
                  ],
                ))
            : Container(
                color: white,
                height: 40,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // CircularProgressIndicator(),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        ' \n \n\n Empty ',
                        style: CustomStyles.foreclr.copyWith(color: blue),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
