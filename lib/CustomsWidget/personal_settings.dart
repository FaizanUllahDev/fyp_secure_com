import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:get/get.dart';

class PersonalSettings extends StatelessWidget {
  final RoomList roomData;

  const PersonalSettings({Key key, this.roomData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: blue,
          icon: Icon(
            Icons.person_remove_outlined,
            color: white,
          ),
          onPressed: () async {
            await FriendController().removeContact(
              roomData.phone,
            );
          },
          label: Text(
            "Remove Conatct",
            style: TextStyle(
              color: white,
            ),
          )),
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 100,
                      backgroundColor: white,
                      child: Center(
                        child: CircleAvatar(
                          maxRadius: 100,
                          backgroundImage: roomData.pic == ""
                              ? AssetImage("assets/images/demo.png")
                              : NetworkImage('$FILES_IMG${roomData.pic}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: blue,
                ),
                title: Text(
                  roomData.name.toUpperCase(),
                  style: TextStyle(fontSize: 25, color: blue),
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone, color: blue),
                title: Text(
                  roomData.phone.toUpperCase(),
                  style: TextStyle(fontSize: 18, color: blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
