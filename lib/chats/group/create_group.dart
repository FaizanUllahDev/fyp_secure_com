import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fyp_secure_com/chats/conversation.dart';
import 'package:fyp_secure_com/chats/group/enter_title.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/index.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Group "),
      ),
      body: Obx(
        () => Get.find<FriendController>().accepted_Friend_List.length > 0
            ? Container(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: ListView.builder(
                  itemCount:
                      Get.find<FriendController>().accepted_Friend_List.length,
                  itemBuilder: (ctx, index) {
                    FriendsModel model = Get.find<FriendController>()
                        .accepted_Friend_List[index];

                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(3, 6),
                            color: Colors.blue[100],
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          Get.to(ConversationPage(
                            roomList: RoomList(
                                phone: model.phone, name: model.name, pic: ''),
                          ));
                        },
                        leading: Icon(
                          Icons.person_pin_circle_rounded,
                          size: 45,
                          color: white,
                        ),
                        title: Text(
                          "${model.name}".toUpperCase(),
                          style: TextStyle(fontSize: 20, color: white),
                        ),
                        trailing: GetBuilder<FriendController>(
                          init: FriendController(),
                          initState: (_) {},
                          builder: (_) {
                            return IconButton(
                                onPressed: () {
                                  print("object");
                                  Get.find<FriendController>()
                                      .updateSelected(index);
                                },
                                icon: Icon(!model.isSelected
                                    ? Icons.add
                                    : Icons.done));
                          },
                        ),
                        subtitle: Text(model.phone,
                            style: TextStyle(fontSize: 15, color: white)),
                      ),
                    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showDialog(
          //     context: context,
          //     builder: (ctx) {
          //       return AlertDialog(
          //         //content: Text("data"),
          //         actions: [],
          //       );
          //     });
          Get.to(() => GetGroupDetails());
          //chooseDialog(context);
        },
        child: Icon(
          Icons.arrow_forward,
          color: blue,
        ),
      ),
    );
  }
}
