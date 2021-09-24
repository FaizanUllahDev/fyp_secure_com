import 'dart:convert';
import 'dart:math';
import 'package:fyp_secure_com/admin/model/doctor_model.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/doctor/model/invitaton.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DoctorHomeController extends GetxController {
  var chatHeaders = <RoomList>[].obs;
  var invitationList = <InvitationModel>[].obs;
  var invitationAcceptedList = <InvitationModel>[].obs;

  ////friend
  ///
  ///
  var friendsList = <FriendsModel>[].obs;
  var pendingList = <FriendsModel>[].obs;
  var sending_Friend_list = <FriendsModel>[].obs;

  var isLoading = false.obs;
  static String imgName = "";
  var number = ''.obs;
  var status = ''.obs;
  var inviationCode = ''.obs;
  var name = ''.obs;
  var doctor_list = <FriendsModel>[].obs;

  getDoctorsList() async {
    String url = APIHOST + GET_DOCTOR_LIST;
    var json = await http.post(Uri.parse(url), body: {"getlist": "true"});
    //print(json.body);
    if (json.body.contains('Failed')) {
      print("http Error");
    } else {
      List list = jsonDecode(json.body);
      list.forEach((data) {
        //print(data['status']);
        FriendsModel model = FriendsModel(
            data['name'], data['number'], data['status'], "Doctor", false);
        if (data['status'] == "Accepted" && data['number'] != number.value) {
          doctor_list.add(model);
        }
      });
    }
  }

  init_inviteList() async {
    //start
    SharedPreferences pref = await SharedPreferences.getInstance();
    var DocNum = '';
    DocNum = pref.get("number").toString();
    LoginController.number = DocNum;
    var role = pref.get("role");
    if (role == "pa") DocNum = pref.get("paData").toString();

    // print(number);
    String url = APIHOST + GET_ALL_INVITATIONS;

    var json = await http.post(Uri.parse(url), body: {"phone": "$DocNum"});
    // if (json.statusCode != 200) {
    //   Get.snackbar("Error", "Network Error");
    // } else
    {
      // print("===> ${json.body}");
      if (!json.body.toString().contains("Failed")) {
        List data = jsonDecode(json.body);

        data.forEach((element) {
          // print(element);
          if (element['status'] == "waiting")
            updateListOfInvits(InvitationModel(
                "${element['to_Patient']}", '', "${element['status']}"));
          else
            updateAcceptedListOfInvits(InvitationModel(
                "${element['to_Patient']}", '', "${element['status']}"));
        });
      }
    }

    //end
  }

  updateListOfInvits(InvitationModel item) {
    invitationList.add(item);
  }

  updateAcceptedListOfInvits(InvitationModel item) {
    invitationAcceptedList.add(item);
  }

  init() async {
    isLoading(true);
    Get.find<SocketController>().socket.on(EVENT_DOCTOR_STATUS, (data) async {
      print(data.toString().split('_')[0]);
      if (data.toString().split('_')[0] == number.value) {
        status(data.toString().split('_')[1]);
        SharedPreferences pref = await SharedPreferences.getInstance();

        //if (data.toString().split('_')[1] == "Accepted")
        await pref.setString("status", "${data.toString().split('_')[1]}");
        // else if (data.toString().split('_')[1] == "Rejected")
        //   await pref.setString("status", "Rejected");
        // else if (data.toString().split('_')[1] == "Block")
        //   await pref.setString("status", "Block");
        print(data.toString().split('_')[1]);
      }
      //update
    });

    ////check online status

    SharedPreferences pref = await SharedPreferences.getInstance();
    number(pref.get("number").toString());
    //print("indise ==> ${pref.getString("status")}");
    status(pref.getString("status").toString());
    name(pref.getString("name").toString());
    Get.find<ChatController>().updateCurrNumber(number.value);
    // checkDoctorStatus();
    isLoading(false);
    // print(number);
  }

  // checkDoctorStatus() async {
  //   try {
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     String url = APIHOST + CHECK_STATUS_DOCTOR;
  //     var status_res =
  //         await http.post(Uri.parse(url), body: {"phone": "$number"});
  //     if (status_res.body.toString().contains('Failed')) {
  //       //  print("Error satyts");
  //     } else {
  //       var json = jsonDecode(status_res.body);
  //       // print(json['status']);
  //       pref.setString("status", "${json['status']}");
  //       status(json['status']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  getProfile() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      Get.find<DoctorHomeController>().number(pref.get("number").toString());
      Get.find<SocketController>().onCOnnected(number.value);
      print("................................." +
          pref.getString("name").toString());
      // print(".................................");
      if (pref.getString("name") == null) {
        String url = APIHOST + ASSETS;

        var res = await http.post(Uri.parse(url),
            body: {"phone": "${number.value}", "table": "doctor"});
        // print(res.body);
        var json;
        if (res.body.toString().contains('Error') ||
            res.body.toString().contains('Failed')) {
        }
        //  print("    ==== > ${res.body}");
        else {
          // print('===> doc ==   ${jsonDecode(res.body)}');
          json = jsonDecode(res.body);

          imgName = json['img'];
          pref.setString("img", imgName);
          pref.setString("name", json['name']);
          if (imgName != '') {
            //var imgRes = http.post(Uri.parse("${FILES_IMG} $imgName"));
          }

          // print(imgName);

        }
      }

      name(pref.getString("name"));

      Get.find<ChatController>().updateCurrName(pref.getString("name"));
      Get.find<ChatController>().updateCurrNumber(pref.getString("number"));
      Get.find<ChatController>().updateImg(pref.getString("img"));
      Get.find<ChatController>().updateCurrName(name.value);
      //print(Get.find<ChatController>().curImg.value);
      Get.find<ChatController>().getDataOnStartOfTheChat();
      // GroupMsg().getDataOnStartOfTheChat();
      // GroupMsg().getGroupCreationDataIfCreated();
    } catch (e) {
      print("Error APi Profile");
      print(e.printError("API PROFILE"));
    }
  }

  @override
  void onInit() {
    super.onInit();
    //checkDoctorStatus();
    getProfile();
    init_inviteList();
    //getDoctorsList();
    init();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  getChatHeadersDB() {
    return chatHeaders;
  }

  updateChatHeader(item) {
    chatHeaders.add(item);
  }

  sendInvitation(toNumber) async {
    ////start
    try {
      String url = APIHOST + INVITE_PATIENT;
      SharedPreferences pref = await SharedPreferences.getInstance();
      var fromNum = pref.get("number").toString();
      var role = pref.get("role");
      if (role == "pa") fromNum = pref.get("paData").toString();

      // print(number);

      //
      int min = 10000; //min and max values act as your 6 digit range
      int max = 99999;
      var randomizer = new Random();
      var rNum = min + randomizer.nextInt(max - min);
      //
      var json = await http.post(Uri.parse(url), body: {
        "fromphone": "$fromNum",
        "tophone": "$toNumber",
        "inviationCode": "$rNum",
        "time": "${DateTime.now()}"
      });

      return json;
    } catch (e) {
      print(e);
    }

    ////end
  }

/////
}
