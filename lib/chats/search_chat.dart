import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:get/get.dart';

import 'conversation.dart';

class SearchChat extends StatefulWidget {
  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  List<RoomList> list = [], searchlist = [];
  bool isSearch = false;
  TextEditingController cont = TextEditingController();

  init() async {
    list = Get.find<ChatController>().searchList;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Chat "),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
              controller: cont,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              autofillHints: ["03", "031", "033"],
              onChanged: (txt) {
                setState(() {});
              },
              onTap: () {
                searchlist = Get.find<ChatController>().searchList;
                isSearch = true;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: ListView.builder(
                itemCount: Get.find<ChatController>().searchList.length,
                itemBuilder: (ctx, index) {
                  RoomList d = list[index];
                  if (cont.text.isEmpty) {
                    return Column(
                      children: [
                        Container(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: ListTile(
                              onLongPress: () {},
                              onTap: () {
                                //Hive.openBox<ChatRoom>(SINGLECHAT);
                                Get.to(ConversationPage(
                                  roomList: RoomList(
                                      name: d.name, phone: d.phone, pic: d.pic),
                                ));
                              },
                              // selected: selected,
                              leading: Container(
                                width: 50,
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: d.name,
                                      child: CircleAvatar(
                                        radius: 30,
                                        child: Text(
                                            d.name.isEmpty
                                                ? d.phone[0]
                                                : d.name[0],
                                            style: CustomStyles.foreclr
                                                .copyWith(color: white)
                                                .copyWith(fontSize: 25)),
                                      ),
                                    ),
                                    Obx(() {
                                      bool isOnline = false;
                                      Get.find<SocketController>()
                                          .onlineFriends
                                          .forEach((element) {
                                        if (element == d.phone) isOnline = true;
                                      });
                                      return isOnline
                                          ? Align(
                                              alignment: Alignment.topRight,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.green,
                                                radius: 10,
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.topRight,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                radius: 10,
                                              ),
                                            );
                                    }),
                                  ],
                                ),
                              ),
                              title: Text(
                                d.name.isEmpty ? d.phone : d.name,
                                style:
                                    CustomStyles.foreclr.copyWith(color: blue),
                              ),
                              subtitle: Text(d.lastMsg.toString(),
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
                          margin: EdgeInsets.symmetric(horizontal: 30),
                        ),
                      ],
                    );
                  } else if (d.phone.contains(cont.text) ||
                      d.name
                          .toString()
                          .toLowerCase()
                          .contains(cont.text.toLowerCase())) {
                    return Column(
                      children: [
                        Container(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            child: Column(
                              children: [
                                Flexible(
                                  child: ListTile(
                                    onLongPress: () {},
                                    onTap: () {
                                      //Hive.openBox<ChatRoom>(SINGLECHAT);
                                      Get.to(ConversationPage(
                                        roomList: RoomList(
                                            name: d.name,
                                            phone: d.phone,
                                            pic: d.pic),
                                      ));
                                    },
                                    // selected: selected,
                                    leading: Container(
                                      width: 50,
                                      child: Stack(
                                        children: [
                                          Hero(
                                            tag: d.name,
                                            child: CircleAvatar(
                                              radius: 30,
                                              child: Text(
                                                  d.name.isEmpty
                                                      ? d.phone[0]
                                                      : d.name[0],
                                                  style: CustomStyles.foreclr
                                                      .copyWith(color: blue)
                                                      .copyWith(fontSize: 25)),
                                            ),
                                          ),
                                          Obx(() {
                                            bool isOnline = false;
                                            Get.find<SocketController>()
                                                .onlineFriends
                                                .forEach((element) {
                                              if (element == d.phone)
                                                isOnline = true;
                                            });
                                            return isOnline
                                                ? Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      radius: 10,
                                                    ),
                                                  )
                                                : Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 10,
                                                    ),
                                                  );
                                          }),
                                        ],
                                      ),
                                    ),
                                    title: Text(
                                      d.name.isEmpty ? d.phone : d.name,
                                      style: CustomStyles.foreclr
                                          .copyWith(color: blue),
                                    ),
                                    subtitle: Text(d.lastMsg.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomStyles.foreclr
                                            .copyWith(color: blue)),
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
                  } else {
                    return Center();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
