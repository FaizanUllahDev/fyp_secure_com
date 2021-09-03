import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/chats/all_accepted_friends.dart';
import 'package:fyp_secure_com/chats/conversation.dart';
import 'package:fyp_secure_com/chats/group/group_conversation.dart';
import 'package:fyp_secure_com/chats/search_chat.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ChatAllRoomPage extends StatefulWidget {
  final currNumber;

  ChatAllRoomPage({Key key, this.currNumber}) : super(key: key);

  @override
  _ChatAllRoomPageState createState() => _ChatAllRoomPageState();
}

class _ChatAllRoomPageState extends State<ChatAllRoomPage> {
  List<RoomList> selectedItems = [];
  List<RoomList> items = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: white,
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(SearchChat());
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            child: FutureBuilder(
                future: Hive.openBox<RoomList>(mainDBNAme),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else
                    return ValueListenableBuilder(
                      valueListenable:
                          Hive.box<RoomList>(mainDBNAme).listenable(),
                      builder: (context, Box<RoomList> box, _) {
                        // setItems(box.values.toList());

                        if (box.values.isEmpty) {
                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.hourglass_empty,
                                color: blue,
                                size: 30,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'No Chat ',
                                style: TextStyle(color: blue, fontSize: 20),
                              ),
                            ],
                          ));
                        } else {
                          int length = box.values.length + 1;
                          List<RoomList> newList = box.values.toList();

                          newList = newList.reversed.toList();
                          newList.sort((a, b) => DateTime.parse(b.lastMsgTime)
                              .compareTo(DateTime.parse(a.lastMsgTime)));
                          // RxList it = RxList.from(box.values);
                          Get.find<ChatController>()
                              .updateSearchList(box.values.toList());
                          // setState(() {
                          //   items = box.values.toList();
                          // });
                          //print("=>>>>>>>> $length");
                          return ListView.builder(
                            itemCount: length,
                            itemBuilder: (context, index) {
                              //print(index);

                              if (index < length - 1) {
                                var chatHeaders = newList[index];
                                var time = '';
                                if (chatHeaders.lastMsgTime != "") {
                                  var timeList = chatHeaders.lastMsgTime
                                      .toString()
                                      .split(' ')[1]
                                      .split('.')[0]
                                      .split(":")
                                      .toList();

                                  time = timeList.first + ":" + timeList[1];
                                }
                                print(chatHeaders.pic);
                                //  print(DateTime.parse(chatHeaders.lastMsgTime));
                                if (!chatHeaders.isArchive) {
                                  return Column(
                                    children: [
                                      Slidable(
                                        actionPane: SlidableDrawerActionPane(),
                                        actionExtentRatio: 0.25,
                                        showAllActionsThreshold: 0.8,
                                        closeOnScroll: true,
                                        secondaryActions: [
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.green.shade100,
                                              ),
                                              child: InkWell(
                                                onTap: () async {
                                                  String mainDBNAme =
                                                      Get.find<ChatController>()
                                                              .currNumber
                                                              .value +
                                                          ROOMLIST;
                                                  await Hive.openBox<RoomList>(
                                                          mainDBNAme)
                                                      .then(
                                                    (value) {
                                                      RoomList room = value
                                                          .values
                                                          .firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .phone ==
                                                                  chatHeaders
                                                                      .phone,
                                                              orElse: () {
                                                        return RoomList(
                                                            phone: "");
                                                      });

                                                      ///
                                                      if (room.phone != "") {
                                                        room.isArchive = true;
                                                        bool found = false;
                                                        // print(recData[1]);
                                                        int index = -1;
                                                        RoomList pre;

                                                        for (int i = 0;
                                                            i <
                                                                value.values
                                                                    .length;
                                                            ++i) {
                                                          RoomList element =
                                                              value.values
                                                                  .elementAt(i);
                                                          if (element.phone ==
                                                              chatHeaders
                                                                  .phone) {
                                                            //print("ID ==> ${i}");
                                                            index = i;
                                                            found = true;
                                                            pre = element;
                                                          }
                                                          // if (found) return;
                                                        }
                                                        value.putAt(
                                                            index, room);
                                                      }
                                                    },
                                                  );
                                                },
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons
                                                          .archive_outlined),
                                                      Text("Archive"),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                        ],
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 0),
                                          child: ListTile(
                                            // onLongPress: () async {
                                            //   ///open botton sheet
                                            //   SharedPreferences pref =
                                            //       await SharedPreferences
                                            //           .getInstance();
                                            //   String role =
                                            //       pref.getString("role");
                                            //   print(role);

                                            //   if (role.toLowerCase() ==
                                            //       "doctor")
                                            //     AwesomeDialog(
                                            //       context: context,
                                            //       body: Center(
                                            //         child: Container(
                                            //           width: size.width,
                                            //           child: Text(
                                            //             '',
                                            //             style: TextStyle(
                                            //                 fontStyle: FontStyle
                                            //                     .italic,
                                            //                 fontSize: 25),
                                            //           ),
                                            //         ),
                                            //       ),
                                            //       buttonsTextStyle: TextStyle(
                                            //           fontStyle:
                                            //               FontStyle.italic,
                                            //           fontSize: 25),
                                            //       btnOkText:
                                            //           "Refer This Person ! -->",
                                            //       btnOkOnPress: () {
                                            //         print(chatHeaders.phone);
                                            //         Get.to(Refer(
                                            //             name: chatHeaders.name,
                                            //             pNumber:
                                            //                 chatHeaders.phone));
                                            //       },
                                            //     )..show();
                                            // },

                                            onTap: () async {
                                              if (chatHeaders.isGroup) {
                                                //print(chatHeaders.phone);
                                                SharedPreferences pref =
                                                    await SharedPreferences
                                                        .getInstance();
                                                pref.setString(
                                                    "gid", chatHeaders.phone);
                                                print(chatHeaders.name);
                                                Get.to(() => GroupConversation(
                                                      roomList: RoomList(
                                                          name:
                                                              chatHeaders.name,
                                                          phone: chatHeaders
                                                              .name
                                                              .split('_')[1],
                                                          pic: chatHeaders.pic),
                                                    ));
                                              } else
                                                Get.to(() => ConversationPage(
                                                      roomList: RoomList(
                                                          name:
                                                              chatHeaders.name,
                                                          phone:
                                                              chatHeaders.phone,
                                                          pic: chatHeaders.pic),
                                                    ));
                                            },
                                            // selected: selected,
                                            leading:
                                                chatHeaders.pic != null &&
                                                        chatHeaders.pic != ""
                                                    ? CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                FILES_IMG +
                                                                    chatHeaders
                                                                        .pic),
                                                      )
                                                    : chatHeaders.isGroup
                                                        ? CircleAvatar(
                                                            child: Icon(Icons
                                                                .group_rounded),
                                                          )
                                                        : Container(
                                                            width: 35,
                                                            child: Stack(
                                                              children: [
                                                                Hero(
                                                                  tag:
                                                                      chatHeaders
                                                                          .name,
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 30,
                                                                    child:
                                                                        Center(
                                                                      child: Text(
                                                                          chatHeaders.name.isEmpty
                                                                              ? chatHeaders.phone[
                                                                                  0]
                                                                              : chatHeaders.name[0]
                                                                                  .toUpperCase(),
                                                                          style: CustomStyles
                                                                              .foreclr
                                                                              .copyWith(color: white)
                                                                              .copyWith(fontSize: 25)),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Obx(() {
                                                                  bool
                                                                      isOnline =
                                                                      false;
                                                                  Get.find<
                                                                          SocketController>()
                                                                      .onlineFriends
                                                                      .forEach(
                                                                          (element) {
                                                                    if (element ==
                                                                        chatHeaders
                                                                            .phone)
                                                                      isOnline =
                                                                          true;
                                                                  });
                                                                  return isOnline
                                                                      ? Align(
                                                                          alignment:
                                                                              Alignment.topRight,
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            radius:
                                                                                10,
                                                                          ),
                                                                        )
                                                                      : Align(
                                                                          alignment:
                                                                              Alignment.topRight,
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundColor:
                                                                                Colors.transparent,
                                                                            radius:
                                                                                10,
                                                                          ),
                                                                        );
                                                                }),
                                                              ],
                                                            ),
                                                          ),

                                            title: Text(
                                              chatHeaders.name.isEmpty
                                                  ? chatHeaders.phone
                                                  : chatHeaders.name
                                                      .split('_')[0],
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomStyles.foreclr
                                                  .copyWith(
                                                      color: blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    chatHeaders.lastMsg
                                                        .toString(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CustomStyles.foreclr
                                                        .copyWith(
                                                      color: blue,
                                                    )),
                                              ],
                                            ),
                                            trailing: chatHeaders.isGroup
                                                ? Icon(Icons.group_rounded)
                                                : Text(time,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: CustomStyles.foreclr
                                                        .copyWith(color: blue)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Divider(
                                          color: blue,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container(
                                    height: 0,
                                  );
                                }
                              } else
                                return Container(
                                  height: 60,
                                );
                            },
                          );
                        }
                      },
                    );
                }),
          ),
        ],
      ),
      //floatingActionButton: customeFloatBtn,
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        child: Icon(
          Icons.chat,
          color: white,
        ),
        onPressed: () {
          Get.to(() => AllAcceptedFriend());
        },
      ),
    );
  }

  setItems(t) {
    setState(() {
      items = t;
    });
  }
}
