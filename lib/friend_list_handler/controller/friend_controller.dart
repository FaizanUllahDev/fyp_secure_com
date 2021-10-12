import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FriendController extends GetxController {
  var request_of_Friend = <FriendsModel>[].obs;
  var sending_Friend_list = <FriendsModel>[].obs;
  var accepted_Friend_List = <FriendsModel>[].obs;
  var doctorLists = <FriendsModel>[].obs;
  var getreferList = <FriendsModel>[].obs;

  var patientsAcceptList = <FriendsModel>[].obs;

  var selectedGroups = [];

  var number = ''.obs;

  updateSelected(ind) {
    accepted_Friend_List[ind].isSelected =
        !accepted_Friend_List[ind].isSelected;
    // print(accepted_Friend_List[ind].isSelected);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    clearAll();
    getFriendList();
    //getAllUsers();
    //getReferListFun();

    getSendingFriendList();
    getPatientFriendList();

    getAllDoctorsList();
  }

  clearAll() {
    print("Clear All");

    request_of_Friend.clear();
    sending_Friend_list.clear();
    accepted_Friend_List.clear();
    doctorLists.clear();
    getreferList.clear();
  }

  removeContact(phone) async {
    String url = APIHOST + rejectRequest;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var json = await http.post(
      Uri.parse(url),
      body: {
        "tonum": "$phone",
        "from": "${Get.find<ChatController>().currNumber.value}",
        "status": ""
      },
      headers: {
        "authorization": pref.containsKey("token") ? pref.get("token") : ""
      },
    );
    json = await http.post(
      Uri.parse(url),
      body: {
        "from": "$phone",
        "tonum": "${Get.find<ChatController>().currNumber.value}",
        "status": ""
      },
      headers: {
        "authorization": pref.containsKey("token") ? pref.get("token") : ""
      },
    );
    print(json.body);
  }

  ///get all registered patients and doctors
  // getReferListFun() async {
  //   var json;
  //   try {
  //     String url = APIHOST + referList;
  //     print(Get.find<ChatController>().currNumber.value);
  //     json = await http.post(Uri.parse(url),
  //         body: {"num": Get.find<ChatController>().currNumber.value});
  //     if (json.statusCode == 200) {
  //       //

  //       List data = jsonDecode(json.body);
  //       data.forEach((element) {
  //         getreferList.add(FriendsModel(element['name'], element['number'], "p",
  //             element['allowTitles'], false));

  //         // FriendsModel modelFound =
  //         //     Get.find<FriendController>().accepted_Friend_List.firstWhere(
  //         //           (element) => element.phone == num,
  //         //           orElse: () =>
  //         //               FriendsModel("name", "", "_status", "role", false),
  //         //         );
  //         // if (modelFound.phone != "")
  //         updateAcceptedList(FriendsModel(
  //             element['name'], element['number'], 'Accept', "p", false));
  //       });
  //     } else {}
  //   } catch (e) {
  //     // print(json.body.toString());
  //     print(e.toString());
  //   }
  // }

  // getReferGroupListFun(num) async {
  //   var json;
  //   try {
  //     String url = APIHOST + "forgroup.php";
  //     print(Get.find<ChatController>().currNumber.value);
  //     json = await http.post(Uri.parse(url), body: {"num": "$num"});
  //     if (json.statusCode == 200) {
  //       //
  //       print(json.body);
  //       List data = jsonDecode(json.body);
  //       data.forEach((element) {
  //         getreferList.add(FriendsModel(element['name'], element['number'], "p",
  //             element['allowTitles'], false));
  //         // var num = element['number'];

  //         // updateAcceptedList(FriendsModel(
  //         //     element['name'], element['number'], 'Accept', "p", false));
  //       });
  //     } else {}
  //   } catch (e) {
  //     // print(json.body.toString());
  //     print(e.toString());
  //   }
  // }

  ///all
  updateAcceptedList(FriendsModel model) {
    FriendsModel modelFound = Get.find<FriendController>()
        .accepted_Friend_List
        .firstWhere(
          (element) => element.phone == model.phone,
          orElse: () => FriendsModel("name", "", "_status", "role", false, ""),
        );
    if (modelFound.phone == "") accepted_Friend_List.add(model);
  }

  getAllDoctorsList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      LoginController.number = pref.get("number");
      String url = APIHOST + getAllDoctors;
      var json = await http.post(
        Uri.parse(url),
        body: {"num": LoginController.number},
        headers: {
          "authorization": pref.containsKey("token") ? pref.get("token") : ""
        },
      );
      if (json.statusCode == 200 && json.body != "") {
        // print(json.body);
        List dd = jsonDecode(json.body);
        dd.forEach((d) {
          // print(Get.find<ChatController>().currNumber.value);
          var found = sending_Friend_list.firstWhere(
            (p0) => p0.phone == d['number'],
            orElse: () {
              return FriendsModel("", "", "", "", false, d['img']);
            },
          );
          if (found.phone != "") d['status'] = found.status;
          if (d['number'] != Get.find<ChatController>().currNumber.value)
            doctorLists.add(FriendsModel(d["name"], d["number"], d["status"],
                'doctor', false, d['img']));
        });
      }
    } catch (e) {
      print("getalldoc");
      print(e.toString());
    }
  }

  ///get all registered patients and doctors
  ///
  // getAllUsers() async {
  //   try {
  //     //print(sending_Friend_list.last.phone);
  //     String url = APIHOST + GetAllUsers;
  //     var json = await http.post(Uri.parse(url));
  //     if (json.statusCode == 200) {
  //       if (json.body.toString().contains('Error') ||
  //           json.body.toString().contains('Failed')) {
  //         //Get.snackbar("Error", "${json.body}");
  //       } else {
  //         //print("Get All Users");
  //         // print(json.body);
  //         List res = jsonDecode(json.body);
  //         res.forEach((data) {
  //           var d = FriendsModel(
  //               data['name'], data['number'], data['status'], "", false);
  //           bool IsNew = true;
  //           Get.find<FriendController>().sending_Friend_list.forEach((element) {
  //             if (element.phone == d.phone) IsNew = false;
  //           });
  //           FriendsModel checkFromRequest = Get.find<FriendController>()
  //               .request_of_Friend
  //               .firstWhere(
  //                 (element) => element.phone == d.phone,
  //                 orElse: () =>
  //                     FriendsModel("name", "phone", "_status", "role", false),
  //               );
  //           if (IsNew &&
  //               checkFromRequest.status == "_status" &&
  //               d.phone != number.value) {
  //             Get.find<FriendController>().sending_Friend_list.add(d);
  //             //print(Get.find<FriendController>().sending_Friend_list.last.name);
  //           }
  //         });
  //       }
  //     } else {
  //       print("Something Wrong");
  //     }
  //   } catch (e) {
  //     print("alll=>> $e");
  //   }
  // }

  getSendingFriendList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      number(pref.get("number").toString());
      String isDoctor = pref.getString("status");

      if (isDoctor == null) {
        isDoctor = "Patient";
      } else
        isDoctor = "Doctor";

      ///Doctor Error
      String url = APIHOST + get_person_Sending_list;
      var json = await http.post(
        Uri.parse(url),
        body: {"number": "${number.value}", "role": "$isDoctor"},
        headers: {
          "authorization": pref.containsKey("token") ? pref.get("token") : ""
        },
      );
      if (json.body.contains('Error') ||
          json.body.toString().contains('Failed')) {
        print("Error");

        //getAllUsers();
        //Get.snackbar("Error", "${json.body}");
      } else {
        List res = jsonDecode(json.body);
        // print(res);

        res.forEach((data) {
          var d = FriendsModel(data['name'], data['number'], data['status'],
              "doctor", false, data['img']);
          // print(d);

          // var found = doctorLists.firstWhere(
          //     (element) => element.phone == d.phone,
          //     orElse: () => FriendsModel("", "", "", "", false));

          if (data['from_num'] == LoginController.number &&
              data['status'] != 'Accept')
            sending_Friend_list.add(d);
          else if (data['status'] == 'Request' &&
              data['from_num'] != LoginController.number)
            request_of_Friend.add(d);
          if (data['status'] == 'Accept') {
            updateAcceptedList(d);
          }
        });
      }
    } catch (e) {
      print("Error FInd");
      print(e);
    }
  }

  getFriendList() async {
    try {
      //clearAll();

      print("getFriendList");
      SharedPreferences pref = await SharedPreferences.getInstance();
      number(pref.get("number").toString());
      String isDoctor = pref.getString("status");

      if (isDoctor == null) {
        isDoctor = "Patient";
      } else
        isDoctor = "Doctor";
      //print("FriendL:isy NUmber checker => $number");
      String url = APIHOST + Patient_DOCTOR_FRIENDS_LIST;
      var json = await http.post(
        Uri.parse(url),
        body: {"number": "${number.value}", "role": "$isDoctor"},
        headers: {
          "authorization": pref.containsKey("token") ? pref.get("token") : ""
        },
      );
      if (json.statusCode != 200) {
        // Get.snackbar("Error", "${number.value} . . " + isDoctor);
      } else {
        List res = jsonDecode(json.body);

        res.forEach((data) {
          var d = FriendsModel(data['name'], data['number'], data['status'],
              "doctor", false, data['img']);
          if (data['status'] != 'Reject')
            Get.find<FriendController>().request_of_Friend.add(d);
          if (data['status'] == 'Accept') {
            updateAcceptedList(d);
            //print(accepted_Friend_List.length);
          }
        });
      }
    } catch (e) {
      print("getFriendList");
      print(e);
    }

    //} else
    //  pendingList.add(d);
  }

  /// patinet List
  getPatientFriendList() async {
    try {
      // clearAll();
      SharedPreferences pref = await SharedPreferences.getInstance();
      number(pref.get("number").toString());
      String isDoctor = pref.getString("status");

      if (isDoctor == "Accepted") {
        print("Token: " + pref.get("token"));
        //print("FriendL:isy NUmber checker => $number");
        String url = APIHOST + getpatientFriend;
        var json = await http.post(
          Uri.parse(url),
          body: {"num": "${number.value}"},
          headers: {
            HttpHeaders.authorizationHeader:
                pref.containsKey("token") ? pref.get("token") : ""
          },
        );
        print(json.body);
        if (json.statusCode != 200) {
          print(json.body);
          // Get.snackbar("Error", "${number.value} . . " + isDoctor);
        } else {
          List res = jsonDecode(json.body);

          res.forEach((data) {
            var d = FriendsModel(data['name'], data['number'], 'Accept',
                "patient", false, data['img']);
            // if (data['status'] != 'Reject')
            //   Get.find<FriendController>().request_of_Friend.add(d);

            //  print("patient==> getfriendlist ==> ");
            //  print(d);
            updateAcceptedList(d);
          });
        }
      }
    } catch (e) {
      print("getFriendList");
      print(e);
    }

    // getReferListFun();
    //} else
    //  pendingList.add(d);
  }

  Future<String> updateFriendReq(numberFrom, toNum, status, int index) async {
    String url = APIHOST + updateFriendRequest;
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (status == "Request") {
      url = APIHOST + addFriend;
    }
    //print(index);

    if (status == "Reject" || status == "Cancel") {
      status = 'NotFriend';
      url = APIHOST + rejectRequest;
      await http.post(
        Uri.parse(url),
        body: {"from": "$numberFrom", "tonum": "$toNum", "status": "$status"},
        headers: {
          "authorization": pref.containsKey("token") ? pref.get("token") : ""
        },
      );

      changesInList(index, status);
    } else {
      var json = await http.post(
        Uri.parse(url),
        body: {"from": "$numberFrom", "tonum": "$toNum", "status": "$status"},
        headers: {
          "authorization": pref.containsKey("token") ? pref.get("token") : ""
        },
      );

      if (json.body.toString().contains('Error')) {
        //Get.snackbar("Error", "${json.body}");
        Get.snackbar("Error", "Failed");
      } else {
        changesInList(index, status);
      }
    }
    return await status;
  }

  changesInList(index, status) {
    if (status == 'Request') {
      FriendsModel friendmodel =
          Get.find<FriendController>().doctorLists.removeAt(index);
      friendmodel.status = "Request";
      Get.find<FriendController>().doctorLists.add(friendmodel);
      print(Get.find<FriendController>().doctorLists.last.status);
    } else if (status == 'NotFriend') {
      FriendsModel friendmodel =
          Get.find<FriendController>().request_of_Friend.removeAt(index);
      friendmodel.status = "NotFriend";
      Get.find<FriendController>().doctorLists.add(friendmodel);
    } else if (status == "UnFriend") {
      FriendsModel friendmodel =
          Get.find<FriendController>().doctorLists.removeAt(index);
      friendmodel.status = "NotFriend";
      Get.find<FriendController>().doctorLists.add(friendmodel);
    }
    //dv. =  "NotFriend";
    else if (status == "Cancel") {
      FriendsModel friendmodel =
          Get.find<FriendController>().doctorLists.removeAt(index);
      friendmodel.status = "NotFriend";
      Get.find<FriendController>().doctorLists.add(friendmodel);
      FriendsModel modelFound =
          Get.find<FriendController>().accepted_Friend_List.firstWhere(
                (element) => element.phone == friendmodel.phone,
                orElse: () =>
                    FriendsModel("name", "", "_status", "role", false, ''),
              );
      if (modelFound.phone != "")
        Get.find<FriendController>().accepted_Friend_List.remove(friendmodel);
    } else if (status == 'Accept') {
      print("Accept");

      var a = Get.find<FriendController>().request_of_Friend.removeAt(index);
      a.status = "Accept";
      Get.find<FriendController>().request_of_Friend.add(a);
      FriendsModel modelFound =
          Get.find<FriendController>().accepted_Friend_List.firstWhere(
                (element) => element.phone == a.phone,
                orElse: () =>
                    FriendsModel("name", "", "_status", "role", false, ''),
              );
      if (modelFound.phone == "")
        Get.find<FriendController>().accepted_Friend_List.add(a);
    }
  }
}
