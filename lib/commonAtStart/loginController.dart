import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'APIHelper.dart';

class LoginController extends GetxController {
  static String whoLogin = '';
  static String number = '';
  static int otp = 0;
  static String status = '';
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  login() async {
    isLoading.value = true;
    Map<String, dynamic> msg = {"d": "1"};
    print(msg);
    String url = APIHOST + LOGIN;
    try {
      await http.post(
        Uri.parse(url),
        headers: {
          "Content-Typen": "application/json",
        },
        body: {
          'phone': "$number",
        },
      ).then((value) {
        //print(value);
        var json = value.body;
        print("==> $json");
        if (value.statusCode == 200) msg = jsonDecode(json);
      });
      //isLoading(false);
      //print(msg);
    } catch (e) {
      print("Login MAIN FUN ." + e.toString());
    }
    return msg;
  }

  ///end
}
