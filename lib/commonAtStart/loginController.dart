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
    String msg = '';
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
        // print("==> $json");
        msg = json;
      });
      //isLoading(false);
      //print(msg);
    } catch (e) {
      print(e);
    }
    return msg;
  }

  ///end
}
