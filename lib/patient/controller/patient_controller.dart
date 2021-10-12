import 'dart:convert';

import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PatientController extends GetxController {
  var number = ''.obs;
  var name = ''.obs;
  var imgName = ''.obs;

  getProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    number(pref.get("number").toString());
    print("Enter Patient");
    String checkname = pref.getString("name");
    print("....." + checkname.toString());
    // if (checkname != null ? checkname.isEmpty : true)

    {
      String url = APIHOST + ASSETS;
      var res = await http.post(
        Uri.parse(url),
        body: {"phone": "${number.value}", "table": "patient"},
        headers: {
          "Authorization": pref.containsKey("token") ? pref.get("token") : ""
        },
      );
      var json;
      if (res.body.contains('Error'))
        print("    ==== > ${res.body}");
      else {
        print('===> p ==   ${jsonDecode(res.body)}');
        json = jsonDecode(res.body);

        pref.setString("name", "$name");
        name(json['name']);

        Get.find<ChatController>().updateCurrName(name.value);

        imgName(json['img']);
        pref.setString("img", json['img']);
        pref.setString("name", json['name']);
        pref.setString("isCcdAllow", json['isCcdAllow']);

        print("Check isCcdAllow");
        print(json['isCcdAllow']);
        if (imgName.value != '') {
          //var imgRes = http.post(Uri.parse("${FILES_IMG} $imgName"));
        }

        // print(imgName);

      }
    }

    name(pref.getString("name").toString());
    print(pref.getString("img"));
    Get.find<ChatController>().updateCurrName(pref.getString("name"));
    Get.find<ChatController>().updateCurrNumber(pref.getString("number"));
    Get.find<ChatController>().updateImg(pref.getString("img"));
    Get.find<ChatController>().updateCurrName(name.value);
    Get.find<ChatController>().getDataOnStartOfTheChat();
    // GroupMsg().getDataOnStartOfTheChat();
    // GroupMsg().getGroupCreationDataIfCreated();
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
    init();
  }

  init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    number(pref.getString("number").toString());

    Get.find<ChatController>().updateCurrNumber(number.value);
    Get.find<SocketController>().onCOnnected(number.value);
  }

  ////end
}
