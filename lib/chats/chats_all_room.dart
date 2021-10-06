import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/chats/all_accepted_friends.dart';
import 'package:fyp_secure_com/chats/conversation.dart';
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
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  String subtitle = "Chat";
  String role = "doctor";
  atStart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    subtitle =
        pref.containsKey("subtitle") ? pref.getString("subtitle") : subtitle;
    setState(() {});
  }

  saveSubTitleKey(keyValue) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("subtitle", keyValue);
    subtitle = keyValue;
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
    final size = MediaQuery.of(context).size;
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    return LiquidPullToRefresh(
      onRefresh: () async {},
      child: Scaffold(
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
            role.toLowerCase() == "patinet"
                ? Center()
                : ListTile(
                    title: Text(
                      "View By $subtitle",
                      style: TextStyle(color: blue),
                    ),
                    tileColor: Colors.black12,
                    trailing: PopupMenuButton(
                        icon: Container(
                          child: Icon(
                            Icons.arrow_downward,
                            color: blue,
                          ),
                        ),
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text("Chat Last Message"),
                                value: 1,
                                onTap: () => saveSubTitleKey("Chat"),
                              ),
                              PopupMenuItem(
                                child: Text("MR No ."),
                                value: 2,
                                onTap: () => saveSubTitleKey("Mr.No"),
                              ),
                              PopupMenuItem(
                                child: Text("Procedure"),
                                value: 3,
                                onTap: () => saveSubTitleKey("Procedure"),
                              ),
                              PopupMenuItem(
                                child: Text("Phone Number"),
                                value: 4,
                                onTap: () => saveSubTitleKey("Number"),
                              ),
                            ]),
                  ),
            Expanded(
              child: FutureBuilder(
                  future: Hive.isBoxOpen(mainDBNAme)
                      ? null
                      : Hive.openBox<RoomList>(mainDBNAme),
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
                                  String proc = "Procedure: ";

                                  //  print(DateTime.parse(chatHeaders.lastMsgTime));
                                  if (!chatHeaders.isArchive) {
                                    return FutureBuilder(
                                        future: http.post(
                                            Uri.parse(APIHOST + "getProc.php"),
                                            body: {
                                              "number": chatHeaders.phone,
                                            }),
                                        builder: (context, snapshot) {
                                          if (snapshot.data == null) {
                                            proc = '';
                                          } else {
                                            print(snapshot.data.toString());
                                            try {
                                              proc =
                                                  snapshot.data.body.toString();
                                            } catch (e) {}
                                          }

                                          print(chatHeaders.phone +
                                              ".... " +
                                              chatHeaders.pic);
                                          return Column(
                                            children: [
                                              Slidable(
                                                actionPane:
                                                    SlidableDrawerActionPane(),
                                                actionExtentRatio: 0.25,
                                                showAllActionsThreshold: 0.8,
                                                closeOnScroll: true,
                                                secondaryActions: [
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 2),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors
                                                            .green.shade100,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          String mainDBNAme =
                                                              Get.find<ChatController>()
                                                                      .currNumber
                                                                      .value +
                                                                  ROOMLIST;
                                                          await Hive.openBox<
                                                                      RoomList>(
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
                                                                      orElse:
                                                                          () {
                                                                return RoomList(
                                                                    phone: "");
                                                              });

                                                              ///
                                                              if (room.phone !=
                                                                  "") {
                                                                room.isArchive =
                                                                    true;
                                                                // print(recData[1]);
                                                                int index = -1;

                                                                for (int i = 0;
                                                                    i <
                                                                        value
                                                                            .values
                                                                            .length;
                                                                    ++i) {
                                                                  RoomList
                                                                      element =
                                                                      value
                                                                          .values
                                                                          .elementAt(
                                                                              i);
                                                                  if (element
                                                                          .phone ==
                                                                      chatHeaders
                                                                          .phone) {
                                                                    //print("ID ==> ${i}");
                                                                    index = i;
                                                                  }
                                                                  // if (found) return;
                                                                }
                                                                value.putAt(
                                                                    index,
                                                                    room);
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
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.red,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          /// delete
                                                          String dbNAme =
                                                              '${Get.find<ChatController>().currNumber.value}_${chatHeaders.phone}';
                                                          print(
                                                              "click dlete ===> $dbNAme");
                                                          Hive.deleteBoxFromDisk(
                                                              dbNAme);

                                                          int counter = 0;
                                                          box.values.forEach(
                                                              (element) {
                                                            if (element.phone ==
                                                                chatHeaders
                                                                    .phone) {
                                                              element.unread =
                                                                  0;
                                                              box.deleteAt(
                                                                  counter);
                                                            }
                                                            counter++;
                                                          });
                                                        },
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.delete,
                                                                color: white,
                                                              ),
                                                              Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color:
                                                                        white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0),
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
                                                        pref.setString("gid",
                                                            chatHeaders.phone);
                                                      } else {
                                                        int counter = 0;
                                                        box.values
                                                            .forEach((element) {
                                                          if (element.phone ==
                                                              chatHeaders
                                                                  .phone) {
                                                            element.unread = 0;
                                                            box.putAt(counter,
                                                                element);
                                                          }
                                                          counter++;
                                                        });

                                                        Get.to(
                                                          () =>
                                                              ConversationPage(
                                                            index: index,
                                                            roomList:
                                                                chatHeaders,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    // selected: selected,
                                                    leading: Container(
                                                      width: 55,
                                                      child: Stack(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        children: [
                                                          chatHeaders.pic !=
                                                                      null &&
                                                                  chatHeaders
                                                                          .pic !=
                                                                      ""
                                                              ? CircleAvatar(
                                                                  maxRadius: 55,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          FILES_IMG +
                                                                              chatHeaders.pic),
                                                                )
                                                              : chatHeaders
                                                                      .isGroup
                                                                  ? CircleAvatar(
                                                                      child: Icon(
                                                                          Icons
                                                                              .group_rounded),
                                                                    )
                                                                  : CircleAvatar(
                                                                      maxRadius:
                                                                          55,
                                                                      backgroundImage:
                                                                          AssetImage(
                                                                              "assets/images/demo.png"),
                                                                    ),
                                                          Obx(() {
                                                            bool isOnline =
                                                                false;
                                                            Get.find<
                                                                    SocketController>()
                                                                .onlineFriends
                                                                .forEach(
                                                                    (element) {
                                                              if (element ==
                                                                  chatHeaders
                                                                      .phone)
                                                                isOnline = true;
                                                            });
                                                            return isOnline
                                                                ? Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .green,
                                                                      radius:
                                                                          10,
                                                                    ),
                                                                  )
                                                                : Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      radius: 7,
                                                                    ),
                                                                  );
                                                          }),
                                                        ],
                                                      ),
                                                    ),

                                                    title: Text(
                                                        chatHeaders.name.isEmpty
                                                            ? "(" +
                                                                chatHeaders
                                                                    .userRole[0]
                                                                    .toUpperCase() +
                                                                ") " +
                                                                chatHeaders
                                                                    .phone
                                                            : "(" +
                                                                chatHeaders
                                                                    .userRole[0]
                                                                    .toUpperCase() +
                                                                ") " +
                                                                chatHeaders.name
                                                                    .split(
                                                                        '_')[0],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: CustomStyles
                                                            .foreclr
                                                            .copyWith(
                                                                color: blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    subtitle: Text(
                                                        subtitle == "Chat"
                                                            ? chatHeaders
                                                                .lastMsg
                                                                .toString()
                                                            : subtitle ==
                                                                    "Number"
                                                                ? chatHeaders
                                                                    .phone
                                                                    .toString()
                                                                : subtitle ==
                                                                        "Procedure"
                                                                    ? proc
                                                                    : subtitle ==
                                                                            "Mr.No"
                                                                        ? proc ==
                                                                                ""
                                                                            ? ""
                                                                            : chatHeaders
                                                                                .id
                                                                        : "",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: CustomStyles
                                                            .foreclr
                                                            .copyWith(
                                                          color: blue,
                                                        )),
                                                    trailing:
                                                        chatHeaders.isGroup
                                                            ? Icon(Icons
                                                                .group_rounded)
                                                            : Container(
                                                                height: 50,
                                                                width: 50,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    (chatHeaders.unread
                                                                                is int &&
                                                                            chatHeaders.unread !=
                                                                                0)
                                                                        ? CircleAvatar(
                                                                            maxRadius:
                                                                                10,
                                                                            backgroundColor:
                                                                                Colors.green,
                                                                            child:
                                                                                Text(
                                                                              chatHeaders.unread.toString(),
                                                                              style: TextStyle(color: Colors.black),
                                                                            ),
                                                                          )
                                                                        : Container(),
                                                                    Text(time,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: CustomStyles
                                                                            .foreclr
                                                                            .copyWith(color: blue)),
                                                                  ],
                                                                ),
                                                              ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                child: Divider(
                                                  color: blue,
                                                ),
                                              ),
                                            ],
                                          );
                                        });
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
      ),
    );
  }

  setItems(t) {
    setState(() {
      items = t;
    });
  }
}
