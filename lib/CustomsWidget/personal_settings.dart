import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:get/get.dart';

class PersonalSettings extends StatelessWidget {
  final roomData;

  const PersonalSettings({Key key, this.roomData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: blue,
          icon: Icon(
            Icons.edit,
            color: white,
          ),
          onPressed: null,
          label: Text(
            "Edit Conatct",
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
          child: Obx(
            () => Column(
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
                            backgroundImage: NetworkImage(
                                '$FILES_IMG${Get.find<ChatController>().curImg.value}'),
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
                    "${Get.find<ChatController>().currName.value}"
                        .toUpperCase(),
                    style: TextStyle(fontSize: 25, color: blue),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: blue),
                  title: Text(
                    "${Get.find<ChatController>().currNumber.value}"
                        .toUpperCase(),
                    style: TextStyle(fontSize: 18, color: blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
