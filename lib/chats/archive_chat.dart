import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/CustomsWidget/navbar.dart';
import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ArchiveChat extends StatefulWidget {
  final currNumber;

  ArchiveChat({Key key, this.currNumber}) : super(key: key);

  @override
  _ChatAllRoomPageState createState() => _ChatAllRoomPageState();
}

class _ChatAllRoomPageState extends State<ArchiveChat> {
  List<RoomList> selectedItems = [];

  List<RoomList> items = [];
  var role = 'Patient';
  String subtitle = "chat";
  atStart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    subtitle =
        pref.containsKey("subtitle") ? pref.getString("subtitle") : subtitle;
    setState(() {});
  }

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      role = preferences.get("role");
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    return Scaffold(
      bottomNavigationBar: role == 'Doctor'
          ? getNavBar(2, context)
          : Container(
              height: 1,
            ),
      appBar: role == 'Doctor'
          ? AppBar(
              title: Text("Archived Chat "),
            )
          : PreferredSize(child: Container(), preferredSize: Size(0, 0)),
      backgroundColor: white,
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(SearchChat());
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
            child: FutureBuilder(
                future: Hive.isBoxOpen(mainDBNAme)
                    ? null
                    : Hive.openBox<RoomList>(mainDBNAme),
                builder: (context, snapshot) {
                  return ValueListenableBuilder(
                    valueListenable:
                        Hive.box<RoomList>(mainDBNAme).listenable(),
                    builder: (context, Box<RoomList> box, _) {
                      Get.find<ChatController>()
                          .updateSearchList(box.values.toList());

                      if (box.values.isEmpty) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sms_failed_sharp,
                              color: blue,
                              size: 40,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'No Chat ',
                              style: TextStyle(color: blue, fontSize: 30),
                            ),
                          ],
                        ));
                      } else {
                        int length = box.values.length + 1;
                        //   RxList it = RxList.from(box.values);
                        Get.find<ChatManager>()
                            .updateSearchLst(box.values.toList());
                        // setState(() {
                        //   items = box.values.toList();
                        // });
                        //print("=>>>>>>>> $length");
                        return ListView.builder(
                          itemCount: length,
                          itemBuilder: (context, index) {
                            //print(index);

                            if (index < length - 1) {
                              var chatHeaders = box.getAt(index);
                              // var bgcolor = Colors.black12;
                              // // bool selected = false;
                              // // selectedItems.forEach((element) {
                              // //   if (element.phone == chatHeaders.phone) {
                              // //     selected = true;
                              // //     bgcolor = Colors.blue[500];
                              // //   }
                              // // });

                              print(chatHeaders.isArchive);
                              if (chatHeaders.isArchive) {
                                return Column(
                                  children: [
                                    Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.30,
                                      showAllActionsThreshold: 0.2,
                                      closeOnScroll: true,
                                      secondaryActions: [
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 0),
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
                                                    RoomList room = value.values
                                                        .firstWhere(
                                                            (element) =>
                                                                element.phone ==
                                                                chatHeaders
                                                                    .phone,
                                                            orElse: () {
                                                      return RoomList(
                                                          phone: "");
                                                    });

                                                    ///
                                                    if (room.phone != "") {
                                                      room.isArchive = false;
                                                      // print(recData[1]);
                                                      int index = -1;
                                                      //   RoomList pre;

                                                      for (int i = 0;
                                                          i <
                                                              value.values
                                                                  .length;
                                                          ++i) {
                                                        RoomList element = value
                                                            .values
                                                            .elementAt(i);
                                                        if (element.phone ==
                                                            chatHeaders.phone) {
                                                          //print("ID ==> ${i}");
                                                          index = i;
                                                          //pre = element;
                                                        }
                                                        // if (found) return;
                                                      }
                                                      value.putAt(index, room);
                                                    }
                                                  },
                                                );
                                              },
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        Icons.archive_outlined),
                                                    Text("Undo Archive"),
                                                  ],
                                                ),
                                              ),
                                            )),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.red,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                /// delete
                                                String dbNAme =
                                                    '${Get.find<ChatController>().currNumber.value}_${chatHeaders.phone}';
                                                print(
                                                    "click dlete ===> $dbNAme");
                                                Hive.deleteBoxFromDisk(dbNAme);
                                                Hive.openBox<RoomList>(
                                                        mainDBNAme)
                                                    .then((value) {
                                                  value.deleteAt(index);
                                                });
                                              },
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: white,
                                                    ),
                                                    Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ],
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        child: ListTile(
                                          onLongPress: () {},
                                          onTap: () {
                                            //Hive.openBox<ChatRoom>(SINGLECHAT);
                                            Get.to(ConversationPage(
                                              roomList: RoomList(
                                                  name: chatHeaders.name,
                                                  phone: chatHeaders.phone,
                                                  pic: chatHeaders.pic),
                                            ));
                                          },
                                          // selected: selected,
                                          leading: Container(
                                            width: 50,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Hero(
                                                  tag: chatHeaders.name,
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    child: Text(
                                                        chatHeaders.name.isEmpty
                                                            ? chatHeaders
                                                                .phone[0]
                                                            : chatHeaders
                                                                .name[0],
                                                        style: CustomStyles
                                                            .foreclr
                                                            .copyWith(
                                                                color: white)
                                                            .copyWith(
                                                                fontSize: 25)),
                                                  ),
                                                ),
                                                Obx(() {
                                                  bool isOnline = false;
                                                  Get.find<SocketController>()
                                                      .onlineFriends
                                                      .forEach((element) {
                                                    if (element ==
                                                        chatHeaders.phone)
                                                      isOnline = true;
                                                  });
                                                  return isOnline
                                                      ? Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.green,
                                                            radius: 10,
                                                          ),
                                                        )
                                                      : Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            radius: 10,
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
                                                    .split("_")[0],
                                            style: CustomStyles.foreclr
                                                .copyWith(color: blue),
                                          ),
                                          subtitle: Text(
                                              subtitle == "chat"
                                                  ? chatHeaders.lastMsg
                                                      .toString()
                                                  : subtitle == "number"
                                                      ? chatHeaders.phone
                                                          .toString()
                                                      : subtitle == "pro"
                                                          ? ""
                                                          : subtitle == "mr"
                                                              ? ""
                                                              : "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomStyles.foreclr
                                                  .copyWith(color: blue)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      color: blue,
                                      width: MediaQuery.of(context).size.width,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 30),
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
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: blue,
      //   onPressed: () {
      //     Get.to(AllAcceptedFriend());
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: white,
      //   ),
      // ),
    );
  }

  setItems(t) {
    setState(() {
      items = t;
    });
  }
}
