import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';

class SearchDoctor extends StatefulWidget {
  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchDoctor> {
  List<FriendsModel> list = [], searchlist = [];
  bool isSearch = false;
  TextEditingController cont = TextEditingController();

  init() async {
    list = Get.find<FriendController>().doctorLists;
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
        title: Text("Search Doctor "),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              autofillHints: ["03", "031", "033"],
              onChanged: (txt) {
                setState(() {});
              },
              onTap: () {
                searchlist = Get.find<FriendController>().doctorLists;
                isSearch = true;
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: ListView.builder(
                itemCount: Get.find<FriendController>().doctorLists.length,
                itemBuilder: (ctx, index) {
                  FriendsModel d = list[index];
                  FriendsModel foundAtRequest = Get.find<FriendController>()
                      .request_of_Friend
                      .firstWhere((ele) => ele.phone == d.phone,
                          orElse: () => FriendsModel("", "", '', "", false));
                  FriendsModel found = Get.find<FriendController>()
                      .accepted_Friend_List
                      .firstWhere((ele) => ele.phone == d.phone,
                          orElse: () => FriendsModel("", "", '', "", false));

                  if (found.phone != '') return Container();

                  if (cont.text.isEmpty && foundAtRequest.phone == "") {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: Column(
                        children: [
                          ListTile(
                            onLongPress: () {},
                            onTap: () {
                              //Hive.openBox<ChatRoom>(SINGLECHAT);
                            },
                            trailing: FloatingActionButton.extended(
                              onPressed: () async {
                                d.status == "Accept"
                                    ? d.status = await FriendController()
                                        .updateFriendReq(
                                            d.phone,
                                            Get.find<ChatController>()
                                                .currNumber
                                                .value,
                                            'UnFriend',
                                            index)
                                    : d.status == "Request"
                                        ? d.status = await FriendController()
                                            .updateFriendReq(
                                                Get.find<ChatController>()
                                                    .currNumber
                                                    .value,
                                                d.phone,
                                                'UnFriend',
                                                index)
                                        : d.status = await FriendController()
                                            .updateFriendReq(
                                                Get.find<ChatController>()
                                                    .currNumber
                                                    .value,
                                                d.phone,
                                                'Request',
                                                index);
                                setState(() {});
                              },
                              label: d.status == "Accept"
                                  ? Text("UnJoin")
                                  : d.status == "Request"
                                      ? Text("Cancel")
                                      : Text("Join"),
                              icon: d.status == "Accept"
                                  ? Icon(Icons.person_remove_alt_1_outlined)
                                  : d.status == "Request"
                                      ? Icon(Icons.person_remove_alt_1_outlined)
                                      : Icon(Icons.person_add_alt),
                            ),
                            leading: Container(
                              width: 50,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    child: Text(
                                        d.name.isEmpty ? d.phone[0] : d.name[0],
                                        style: CustomStyles.foreclr
                                            .copyWith(color: white)
                                            .copyWith(fontSize: 25)),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                              d.name.isEmpty ? d.phone : d.name,
                              style: CustomStyles.foreclr.copyWith(color: blue),
                            ),
                            subtitle: Text(d.phone.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    CustomStyles.foreclr.copyWith(color: blue)),
                          ),
                          Container(
                            height: 1,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    );
                  } else if (d.phone.contains(cont.text) ||
                      d.name
                          .toString()
                          .toLowerCase()
                          .contains(cont.text.toLowerCase())) {
                    return Container(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        child: Column(
                          children: [
                            ListTile(
                              onLongPress: () {},
                              onTap: () {
                                //Hive.openBox<ChatRoom>(SINGLECHAT);
                                // Get.to(ConversationPage(
                                //   roomList: RoomList(
                                //       name: d.name, phone: d.phone, pic: d.pic),
                                // ));
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
                              subtitle: Text(d.phone.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomStyles.foreclr
                                      .copyWith(color: blue)),
                            ),
                            Container(
                              height: 1,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
