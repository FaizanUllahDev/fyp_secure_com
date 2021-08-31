import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp_secure_com/admin/model/doctor_model.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/commonAtStart/start_explore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminController extends GetxController {
  var isLoading = false.obs;
  var pendingLists = <DoctorModel>[].obs;
  var acceptedList = <DoctorModel>[].obs;
  var rejectedList = <DoctorModel>[].obs;
  var blockedList = <DoctorModel>[].obs;

  var number = "".obs;
  var currentBody;
  RxBool isInternet = true.obs;

  RxBool checkInternet() {
    return isInternet;
  }

  updateCurrentBody(newBody) {
    currentBody = newBody;
    update();
  }

  init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    number(pref.getString("number"));
    print(number);
    Get.find<ChatController>().updateCurrNumber(number.value);
    SocketController().onCOnnected(await pref.getString("number"));

    String url = APIHOST + GET_DOCTOR_LIST;
    var json = await http.post(Uri.parse(url), body: {"getlist": "true"});
    //print(json.body);
    if (json.body.contains('Failed')) {
      print("http Error");
    } else {
      List list = jsonDecode(json.body);
      list.forEach((data) {
        print(data['status']);
        DoctorModel model = DoctorModel(
            data['name'], data['number'], data['status'], false, false);
        if (data['status'] == "Pending") {
          pendingLists.add(model);
        } else if (data['status'] == "Rejected") {
          rejectedList.add(model);
        } else if (data['status'] == "Accepted") {
          acceptedList.add(model);
        } else if (data['status'] == "Blocked") {
          blockedList.add(model);
        }
      });
    }
  }

  updateNetStatus(status) {
    isInternet.value = status;
  }

  @override
  void onInit() {
    super.onInit();
    init();
    Get.find<SocketController>().onCOnnected(number.value);
    Get.find<SocketController>().socket.on(EVENT_ADD_NUMBER,
        (data) => SocketController().onCOnnected(number.value));

    Get.find<SocketController>()
        .socket
        .on(EVENT_MSG, (data) => print("Admin MSG ==> $data"));
  }

  @override
  void onClose() {
    super.onClose();
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Get.find<SocketController>()
        .socketlogout(Get.find<ChatController>().currNumber.value);
    await preferences.remove('phone');
    await preferences.remove('name');
    await preferences.clear();

    Get.offAll(() => StartExploer());
  }

  updateDoctorStatus(number, status, index) async {
    String msg = '${number}_$status';
    String url = APIHOST + UPDATESTATUS;
    print(msg);
    var res = await http.post(
      Uri.parse(url),
      body: {"phone": "$number", "status": "$status"},
    );
    print(res.body);
    if (res.body == "update") {
      SocketController().updateDoctorStatus(msg);
      if (status == "Accepted") {
        DoctorModel foundFromPending = pendingLists.firstWhere(
            (element) => element.number == number,
            orElse: () => DoctorModel("", "", "", "", ""));
        DoctorModel foundFromBlock = blockedList.firstWhere(
            (element) => element.number == number,
            orElse: () => DoctorModel("", "", "", "", ""));
        if (foundFromPending.number != "") {
          acceptedList.add(pendingLists.removeAt(index));
        } else if (foundFromBlock.number != "") {
          acceptedList.add(blockedList.removeAt(index));
        }
      } else if (status == "Rejected") {
        rejectedList.add(pendingLists.removeAt(index));
      } else if (status == "Blocked") {
        blockedList.add(acceptedList.removeAt(index));
      }
    } else
      Get.snackbar("Error", "Something Wrong",
          colorText: Colors.white, backgroundColor: Colors.red);
  }

  //end
}
