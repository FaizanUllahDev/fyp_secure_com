import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/personal_settings.dart';
import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/hiveBox/chat_room.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_list.dart';

class ConversationPage extends StatefulWidget {
  final RoomList roomList;

  final int index;

  ConversationPage({this.roomList, this.index});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  ////
  int flex = 1;
  int increment = 2;
  String role = '';

  @override
  void initState() {
    super.initState();
    init();
    //flutterSound = new FlutterSoundRecorder();
  }

  init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      role = pref.getString("role");
    });

    //String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;

    // Box<RoomList> boxOFparent = Hive.box<RoomList>(mainDBNAme);
    // boxOFparent.values.forEach((element) {
    //   if (element.phone == widget.roomList.phone) {
    //     widget.roomList.unread = 0;
    //     boxOFparent.putAt(widget.index, widget.roomList);
    //     print(boxOFparent.getAt(widget.index).name);
    //   }
    // });
  }

  List<String> choices = <String>[
    "Impoert CCD File",
  ];
  @override
  void dispose() {
    Get.find<ChatManager>().forwardIndexesSelected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, 50),
        child: AppBar(
          iconTheme: IconThemeData(color: white),
          actions: [
            InkWell(
              onTap: () {
                Get.to(PersonalSettings(
                  roomData: widget.roomList,
                ));
              },
              child: GetBuilder<ChatManager>(
                init: ChatManager(),
                initState: (_) {},
                builder: (_) {
                  return _.forwardIndexesSelected.length > 0
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _.forwardIndexesSelected.forEach((element) {
                                  print(element.roomData.msg);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.screen_share_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Hero(
                                tag: widget.roomList.name,
                                child: CircleAvatar(
                                  backgroundImage: widget.roomList.pic != ""
                                      ? NetworkImage(
                                          FILES_IMG + widget.roomList.pic)
                                      : AssetImage("assets/images/demo.png"),
                                ),
                                //   child: CircleAvatar(
                                //     radius: 25,
                                //     backgroundColor: white,
                                //     child: Text(
                                //       widget.roomList.name.isEmpty
                                //           ? '0'
                                //           : "${widget.roomList.name[0]}"
                                //               .toUpperCase(),
                                //       style: TextStyle(fontSize: 20, color: blue),
                                //     ),
                                //   ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Obx(() {
                                bool isOnline = false;
                                Get.find<SocketController>()
                                    .onlineFriends
                                    .forEach((element) {
                                  //  print(" online phone => ");
                                  element == widget.roomList.phone
                                      ? isOnline = true
                                      : null;
                                });
                                return isOnline
                                    ? CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 8,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 8,
                                      );
                              }),
                            ),
                          ],
                        );
                },
              ),
            ),
          ],
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${widget.roomList.name}".toUpperCase(),
                style: TextStyle(fontSize: 17),
              ),
              // Text(
              //   "${widget.roomList.phone}",
              //   style: TextStyle(fontSize: 15),
              // ),
            ],
          ),
        ),
      ),
      body: ChatListPage(
        name: widget.roomList.name,
        roomList: widget.roomList,
        chatRoom: ChatRoom(
          fromPhone: Get.find<ChatController>().currNumber.value,
          toPhone: widget.roomList.phone,
        ),
      ),
    );
  }
}
