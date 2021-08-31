import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/commonAtStart/start_explore.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/patient/controller/patient_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

class All_controller extends Bindings {
  getrole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String role = pref.getString("role");
    if (role != null) {
      Get.put(ChatController());
      Get.put(FriendController());
      Get.put(ChatManager());
    }
  }

  @override
  void dependencies() {
    Get.put(SocketController());
    getrole();
    // Get.put(ChatController());
    // Get.put(ChatManager());
    // Get.put(FriendController());
    //Get.put(LoginController());

    // Get.put(AdminController());
  }
}

updateProfile({name, preimg, phone, img, role}) async {
  var res;
  if (img == "") {
    res = await http.post(
      Uri.parse(APIHOST + profileUpdate),
      body: {
        "name": name,
        "preimg": preimg,
        "phone": phone,
        "img": preimg,
        "role": role,
      },
    );
  } else {
    var stream = http.ByteStream(DelegatingStream.typed(img.openRead()));
    var len = await img.length();
    var req = http.MultipartRequest("POST", Uri.parse(APIHOST + profileUpdate));
    var multi = new http.MultipartFile(
      "img",
      stream,
      len,
      filename: basename(img.path),
    );
    req.files.add(multi);

    req.fields['name'] = name;
    req.fields['preimg'] = preimg;
    req.fields['phone'] = phone;

    req.fields['role'] = role;
    var respose = await req.send();

    // respose.then((value) => statusCode = value.statusCode);
    res = respose;
    if (respose.statusCode == 200) {
      //msg = respose.reasonPhrase.toUpperCase();
      await http.Response.fromStream(respose).then((value) async {
        print(value.body);
        // msg = value.body;
      });
    }
  }

  return res;
}

logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Get.find<SocketController>()
      .socketlogout(Get.find<ChatController>().currNumber.value);
  await preferences.remove('phone');
  await preferences.remove('name');
  await preferences.remove('img');

  await preferences.clear();

  Get.delete<ChatController>(force: true);
  Get.delete<ChatManager>(force: true);
  Get.delete<FriendController>(force: true);
  Get.delete<DoctorHomeController>(force: true);
  Get.delete<PatientController>(force: true);

  Get.offAll(() => StartExploer());
}
