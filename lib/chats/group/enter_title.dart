import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fyp_secure_com/CustomsWidget/customColors.dart';
import 'package:fyp_secure_com/chats/chats_all_room.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/doctor/view/doctor_home.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/controller/patient_controller.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:fyp_secure_com/patient/view/patient_home.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class GetGroupDetails extends StatefulWidget {
  @override
  _GetGroupDetailsState createState() => _GetGroupDetailsState();
}

class _GetGroupDetailsState extends State<GetGroupDetails> {
  bool IsImagePick = false;
  File _image;
  final gName = TextEditingController();
  final fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            IsImagePick
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: FileImage(_image),
                        radius: 80,
                      ),
                      InkWell(
                        child: Icon(Icons.camera_alt_sharp,
                            color: white, size: 40),
                        onTap: () {
                          chooseDialog(context);
                        },
                      ),
                    ],
                  )
                : CircleAvatar(
                    radius: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/demo.png'),
                        InkWell(
                          child: Icon(Icons.camera_alt_sharp,
                              color: white, size: 40),
                          onTap: () {
                            chooseDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
            Form(
              key: fKey,
              child: Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                child: TextFormField(
                  validator: (txt) =>
                      txt.length == 0 ? "Enter Group Name" : null,
                  controller: gName,
                  decoration: InputDecoration(
                    labelText: "Group Name",
                    labelStyle: TextStyle(fontSize: 15),
                  ),
                  keyboardType: TextInputType.name,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: blue,
              ),
              child: TextButton(
                  onPressed: () {
                    if (fKey.currentState.validate()) createGroup();
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(color: white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  createGroup() async {
    List<String> selectedMembers = [];
    Get.find<FriendController>().accepted_Friend_List.forEach((element) {
      if (element.isSelected) {
        print(element.role);
        selectedMembers.add(element.toJson());
      }
    });

    if (selectedMembers.length >= 2) {
      if (!IsImagePick) {
        var res = await http.post(
          Uri.parse(APIHOST + 'addGroup.php'),
          body: {
            "createdBy": Get.find<ChatController>().currNumber.value,
            "date": DateTime.now().toString(),
            "title": gName.text.toString(),
            "listOfMem": jsonEncode(selectedMembers),
          },
        );
        if (res.statusCode == 200) {
          // print(res.body);
          List str = res.body.toString().split('_').toList();
          addGroupInHive(str.first, str.last);
          selectedMembers.clear();
          gotoHomeScreen();
        } else {
          Get.snackbar("Alert ", "Error");
        }
      } else {
        var stream, len;
        stream = http.ByteStream(DelegatingStream.typed(_image.openRead()));
        len = await _image.length();

        var req =
            http.MultipartRequest("POST", Uri.parse(APIHOST + 'addGroup.php'));
        var multi = new http.MultipartFile(
          "img",
          stream,
          len,
          filename: basename(_image.path),
        );
        req.files.add(multi);
        req.fields['createdBy'] = Get.find<ChatController>().currNumber.value;
        req.fields['date'] = DateTime.now().toString();
        req.fields['title'] = gName.text.toString();
        req.fields['listOfMem'] = jsonEncode(selectedMembers);

        var respose = await req.send();
        if (respose.statusCode == 200) {
          // Get.offAll(ChatAllRoomPage());
          //msg = respose.reasonPhrase.toUpperCase();
          await http.Response.fromStream(respose).then((value) {
            print(value.body);
            selectedMembers.clear();
            gotoHomeScreen();
          });
        } else {
          Get.snackbar("Alert ", "Error");
        }
      }
    } else {
      Get.snackbar("Alert", "At least Two Member in Group");
    }

    //end
  }

  gotoHomeScreen() {
    for (int i = 0;
        i < Get.find<FriendController>().accepted_Friend_List.length;
        ++i) {
      Get.find<FriendController>().updateSelected(i);
    }

    try {
      //unDoList();
      Get.find<DoctorHomeController>();

      Get.offAll(DoctorHome());
      //print("Good");
    } catch (e) {
      print(e);
    }
    try {
      // unDoList();
      Get.find<PatientController>();
      Get.offAll(PatientHome());
      //print("Good");
    } catch (e) {
      print("patient Not FOund");
      print(e);
    }
  }

  addGroupInHive(gid, img) async {
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    await Hive.openBox<RoomList>(mainDBNAme).then((value) {
      var roomData = RoomList(
        id: "-1",
        lastMsg: "",
        lastMsgTime: DateTime.now().toString(),
        name: gName.text,
        phone: gid,
        isArchive: false,
        isGroup: true,
        isPin: false,
        userRole: "",
        pic: img,
      );

      value.add(roomData);
    });
  }

  chooseDialog(context) {
    return YYDialog().build(context)
      ..width = 120
      ..height = 110
      ..backgroundColor = Colors.white.withOpacity(1)
      ..borderRadius = 10.0
      ..showCallBack = () {
        print("showCallBack invoke");
      }
      ..gravityAnimationEnable = true
      ..dismissCallBack = () {
        print("dismissCallBack invoke");
      }
      ..widget(Padding(
        padding: EdgeInsets.only(top: 21),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(
                  Icons.camera,
                  color: CustomColor.borderColor,
                ),
                onPressed: () {
                  picker(ImageSource.camera);

                  Navigator.pop(context);
                }),
            IconButton(
                icon: Icon(
                  Icons.photo,
                  color: CustomColor.borderColor,
                ),
                onPressed: () {
                  picker(ImageSource.gallery);
                  Navigator.pop(context);
                }),
          ],
        ),
      ))
      ..widget(Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "Choose One",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ))
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          child: child,
          scale: Tween(begin: 0.0, end: 2.0).animate(animation),
        );
      }
      ..show();
  }

  picker(source) async {
    var permitted = await Permission.camera.request().isGranted;
    if (!permitted) return;
    permitted = await Permission.storage.request().isGranted;
    if (!permitted) return;
    final pickedFile = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        this.IsImagePick = true;

        _image = File(pickedFile.path);

        print(_image);
      } else {
        _image = null;
        print('No image selected.');
      }
    });
  }
}
