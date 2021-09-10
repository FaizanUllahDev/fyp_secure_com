import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';

class ReferListView extends StatefulWidget {
  @override
  State<ReferListView> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<ReferListView> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Get.find<FriendController>().getreferList.length > 0
          ? Container(
              color: white,
              padding: EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: Get.find<FriendController>().getreferList.length,
                itemBuilder: (ctx, index) {
                  FriendsModel model =
                      Get.find<FriendController>().getreferList[index];

                  return Container(
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      // secondaryActions: model.status == 'Request'
                      //     ? [
                      //         IconSlideAction(
                      //           caption: 'Accept',
                      //           color: Colors.green,
                      //           icon: Icons.person_pin,
                      //           onTap: () async {
                      //             model.status = await FriendController()
                      //                 .updateFriendReq(
                      //                     model.phone,
                      //                     Get.find<ChatController>()
                      //                         .currNumber
                      //                         .value,
                      //                     'Accept',
                      //                     index);
                      //             setState(() {});
                      //           },
                      //         ),
                      //         IconSlideAction(
                      //           caption: 'Reject',
                      //           color: Colors.red,
                      //           icon: Icons.person_add_disabled_outlined,
                      //           onTap: () async {
                      //             model.status = await FriendController()
                      //                 .updateFriendReq(
                      //                     model.phone,
                      //                     Get.find<ChatController>()
                      //                         .currNumber
                      //                         .value,
                      //                     'Reject',
                      //                     index);
                      //             setState(() {});
                      //           },
                      //         ),
                      //       ]
                      //     : [
                      //         IconSlideAction(
                      //           caption: 'UnJoin',
                      //           color: Colors.red,
                      //           icon: Icons.person_add_disabled_outlined,
                      //           onTap: () => FriendController().updateFriendReq(
                      //               model.phone,
                      //               Get.find<ChatController>().currNumber.value,
                      //               'Reject',
                      //               index),
                      //         ),
                      //       ],
                      child: ListTile(
                        leading: Icon(
                          Icons.person_pin_circle_rounded,
                          size: 45,
                          color: white,
                        ),
                        title: Text(
                          "${model.name}".toUpperCase(),
                          style: TextStyle(fontSize: 25, color: white),
                        ),
                        // trailing: model.status == 'Request'
                        //     ? Text("Pending",
                        //         style: TextStyle(fontSize: 17, color: white))
                        //     : Text("Accepted",
                        //         style: TextStyle(fontSize: 17, color: white)),
                        subtitle: Text(model.phone,
                            style: TextStyle(fontSize: 17, color: white)),
                      ),
                    ),
                  );
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
            ),
    );
  }
}
