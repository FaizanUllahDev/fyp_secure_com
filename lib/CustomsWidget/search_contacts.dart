import 'package:flutter/material.dart';
import 'package:fyp_secure_com/chats/conversation.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';

class SearchContect extends StatefulWidget {
  SearchContect({Key key, this.lst}) : super(key: key);
  final List<FriendsModel> lst;

  @override
  _SearchContectState createState() => _SearchContectState();
}

class _SearchContectState extends State<SearchContect> {
  final controller = TextEditingController();
  List<FriendsModel> searchedData;
  @override
  void initState() {
    super.initState();
    setState(() {
      searchedData = widget.lst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: FloatingActionButton.extended(
              label: Text("Search"),
              onPressed: () {
                setState(() {
                  searchedData = searchedData
                      .where(
                        (element) =>
                            element.phone.contains(controller.text) &&
                            element.name.contains(controller.text),
                      )
                      .toList();
                });
              },
              icon: Icon(Icons.search),
            ),
            border: OutlineInputBorder(),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: searchedData.length,
          itemBuilder: (ctx, index) {
            FriendsModel model = searchedData[index];
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                    // color: blue,
                    borderRadius: BorderRadius.circular(35),
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
                      size: 35,
                      color: blue,
                    ),
                    title: Text(
                      "${model.name}".toUpperCase(),
                      style: TextStyle(
                          fontSize: 19,
                          color: blue,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(model.phone,
                        style: TextStyle(fontSize: 17, color: blue)),
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
          }),
    );
  }
}
