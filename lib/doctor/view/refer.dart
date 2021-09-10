import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/doctor/model/names.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/controller/patient_controller.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:fyp_secure_com/patient/view/patient_home.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'doctor_home.dart';

class Refer extends StatefulWidget {
  final pNumber;
  final name;

  const Refer({this.pNumber, this.name});

  @override
  State<Refer> createState() => _ReferState();
}

class _ReferState extends State<Refer> {
  FriendsModel selectedDoctor = FriendsModel("", "", "", "", false);
  List<CcdNames> ccdTitles = [];
  List<FriendsModel> doc = [];
  @override
  void initState() {
    super.initState();
    atStart();
  }

  atStart() async {
    doc = Get.find<FriendController>().doctorLists;
    selectedDoctor = doc.first;
    setState(() {});

    getCheckBoxOpt(context);
  }

  bool stayInGroup = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //print(doc.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer The Patient !"),
      ),
      body: Column(
        children: [
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: white,
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/demo.png"),
                ),
                SizedBox(width: 30),
                Text(
                  "${widget.name} \n" + widget.pNumber,
                  style: TextStyle(fontSize: 20, color: blue),
                ),
              ],
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Select Doctor "),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: blue,
                ),
                child: DropdownButton<FriendsModel>(
                  value: selectedDoctor,
                  items: doc.map((FriendsModel value) {
                    return DropdownMenuItem<FriendsModel>(
                      value: value,
                      child: Container(
                        width: 150,
                        child: ListTile(
                          title: Text(value.name.toString().toUpperCase()),
                          subtitle: Text(value.phone),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (_) {
                    selectedDoctor = _;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 17),
          Container(
            child: Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 5 / 1,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: ccdTitles.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      child: Row(
                        children: [
                          Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.blue,
                              value: ccdTitles[index].isCheck,
                              onChanged: (t) {
                                ccdTitles[index].isCheck = t;

                                setState(() {});
                                print(t);
                              }),
                          Text(
                            "medications" == ccdTitles[index].name
                                ? "RX"
                                : ccdTitles[index].name,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          SizedBox(height: 17),
          Row(
            children: [
              Text("Do You  Want To Stay In Communication? "),
              Checkbox(
                  activeColor: blue,
                  value: stayInGroup,
                  onChanged: (newV) {
                    stayInGroup = newV;
                    setState(() {});
                  }),
            ],
          ),
          TextButton(
            onPressed: () {
              List<String> names = [];

              ccdTitles.forEach((element) {
                if (element.isCheck) names.add(element.name);
              });
              var jsonDe = jsonEncode(names);
              uploadRefer(
                selectedDoctor.phone,
                context,
                jsonDe,
                widget.pNumber,
                Get.find<ChatController>().currNumber.value,
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 30, bottom: 30),
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Refer",
                style: TextStyle(color: white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
      // body: Container(
      //   margin: EdgeInsets.only(top: 20),
      //   child: ListView.builder(
      //     itemCount: doc.length,
      //     itemBuilder: (ctx, index) {
      //       return Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(30),
      //           boxShadow: [
      //             BoxShadow(
      //               blurRadius: 0.0,
      //               color: blue,
      //             ),
      //           ],
      //         ),
      //         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      //         child: ListTile(
      //           onTap: () {
      //             //print(widget.pNumber);
      //             getCheckBoxOpt(context);
      //             //  uploadRefer(doc[index].phone, context);
      //           },
      //           leading: CircleAvatar(
      //             backgroundImage: NetworkImage(FILES_IMG + doc[index].status),
      //           ),
      //           title: Text(doc[index].name),
      //           subtitle: Text(doc[index].phone),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }

  uploadRefer(docPhone, context, jsonname, pnumber, from) async {
    var json = await http.post(
      Uri.parse(APIHOST + refer),
      body: {
        "allowTitles": jsonname,
        "doctorRefer": docPhone,
        "referFrom": from.toString(),
        "p_number": pnumber,
      },
    );
    if (json.statusCode == 300) {
      AwesomeDialog(
        context: context,
        animType: AnimType.RIGHSLIDE,
        dialogType: DialogType.SUCCES,
        body: Container(),
        buttonsTextStyle: TextStyle(fontSize: 25),
        btnOkText: "Already Referred  ! ",
        btnOkOnPress: () {},
      )..show();
    } else if (json.statusCode == 200) {
      print(json.body);
      //creation of Group
      createRefferedGroup();
      //
      AwesomeDialog(
        context: context,
        animType: AnimType.RIGHSLIDE,
        dialogType: DialogType.SUCCES,
        body: Container(),
        buttonsTextStyle: TextStyle(fontSize: 25),
        btnOkText: "Referred SuccessFully  ! ",
        btnOkOnPress: () {},
      )..show();
      print("Refered !");
    } else {
      print(json.body);
    }
  }

  createRefferedGroup() async {
    try {
      List<String> selectedMembers = [];

      FriendsModel mem = FriendsModel(
        "name",
        Get.find<ChatController>().currNumber.value,
        "",
        "",
        true,
      );
      selectedMembers.add(mem.toJson());
      mem = FriendsModel(
        "name",
        widget.pNumber,
        "",
        "",
        true,
      );
      selectedMembers.add(mem.toJson());
      mem = FriendsModel(
        "name",
        selectedDoctor.phone,
        "",
        "patient",
        true,
      );
      selectedMembers.add(mem.toJson());

      String groupName =
          selectedDoctor.name + " , " + widget.name + "_" + widget.pNumber;

      if (selectedMembers.length >= 2) {
        var res = await http.post(
          Uri.parse(APIHOST + 'addGroup.php'),
          body: {
            "createdBy": Get.find<ChatController>().currNumber.value,
            "date": DateTime.now().toString(),
            "title": groupName,
            "listOfMem": jsonEncode(selectedMembers),
          },
        );
        print(res.body);
        if (res.statusCode == 200) {
          // print(res.body);
          List str = res.body.toString().split('_').toList();
          addGroupInHive(str.first, str.last, groupName);
          selectedMembers.clear();
          gotoHomeScreen();
        } else {
          Get.snackbar("Alert ", "Error");
        }
      } else {
        Get.snackbar("Alert", "At least Two Member in Group");
      }
    } catch (e) {
      print(e);
    }
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

  addGroupInHive(gid, img, name) async {
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    await Hive.openBox<RoomList>(mainDBNAme).then((value) {
      var roomData = RoomList(
        id: "-1",
        lastMsg: "",
        lastMsgTime: DateTime.now().toString(),
        name: name,
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

  getCheckBoxOpt(context) async {
    //SharedPreferences pref = await SharedPreferences.getInstance();
    //var json = pref.getString("titles");
    List names = ["allergies", "medications", "procedures", "immunizations"];
    print(names);
    names.forEach((element) {
      ccdTitles.add(CcdNames(isCheck: false, name: element));
    });
    setState(() {});
    // Get.to(SelectTitleCcd(
    //   ccdTitles: ccdTitles,
    //   pNumber: widget.pNumber,
    // ));
  }
}
