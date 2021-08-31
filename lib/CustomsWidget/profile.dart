import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fyp_secure_com/CustomsWidget/navbar.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/all_controller.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customColors.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controller =
      TextEditingController(text: Get.find<ChatController>().currName.value);
  bool isEdit = false;
  bool IsImagePick = false;
  File _image = File("");
  String role = " ", image = "";

  @override
  void initState() {
    super.initState();
    atStart();
    image = Get.find<ChatController>().curImg.value;
    print("$FILES_IMG$image");
  }

  atStart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString("role");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () async {
              logout();
            },
          ),
        ],
      ),
      bottomNavigationBar: role == "Doctor"
          ? getNavBar(3, context)
          : Container(
              height: 1,
            ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Obx(
              () => Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: 100,
                        backgroundColor: white,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            _image.path == ""
                                ? image == "" || image.isEmpty
                                    ? CircleAvatar(
                                        maxRadius: 100,
                                        backgroundImage: AssetImage(
                                            "assets/images/demo.png"))
                                    : CircleAvatar(
                                        maxRadius: 100,
                                        backgroundImage: NetworkImage(
                                            '$FILES_IMG${Get.find<ChatController>().curImg.value}'),
                                      )
                                : Center(
                                    child: CircleAvatar(
                                      maxRadius: 100,
                                      backgroundImage:
                                          FileImage(_image, scale: 0.6),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                onPressed: () {
                                  chooseDialog(context);
                                },
                                icon: Icon(
                                  Icons.camera,
                                  size: 40,
                                  color: blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  !isEdit
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${Get.find<ChatController>().currName.value}"
                                  .toUpperCase(),
                              style: TextStyle(fontSize: 30),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isEdit = true;
                                });
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.edit),
                              border: OutlineInputBorder(
                                // borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            controller: controller,
                            style: TextStyle(),
                          ),
                        ),
                  Text(
                    "${Get.find<ChatController>().currNumber.value}"
                        .toUpperCase(),
                    style: TextStyle(fontSize: 15),
                  ),
                  // isEdit
                  //     ?
                  TextButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      var role = pref.getString("role");
                      var res = await updateProfile(
                        phone: Get.find<ChatController>().currNumber.value,
                        name: controller.text,
                        role: role,
                        preimg: Get.find<ChatController>().curImg.value,
                        img: _image == null ? "" : _image,
                      );
                      if (res.statusCode == 200) {
                        Get.snackbar("Alert", "Saved ...");
                        _image != null
                            ? print(res.reasonPhrase)
                            : print(res.body);
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setString("name", controller.text);
                        _image == null
                            ? null
                            : pref.setString("img", basename(_image.path));
                        Get.find<ChatController>()
                            .updateCurrName(controller.text);
                        print(_image.toString());
                        _image == null
                            ? null
                            : Get.find<ChatController>()
                                .updateImg(basename(_image.path));

                        if (_image != null) {
                          Get.find<ChatController>()
                              .updateImg(basename(_image.path));
                        }
                      } else {
                        print("Error" + res.body.toString());
                      }
                      setState(() {
                        isEdit = false;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 30,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 30, color: white),
                      ),
                    ),
                  )
                  //: Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
        print('No image selected.');
      }
    });
  }
}
