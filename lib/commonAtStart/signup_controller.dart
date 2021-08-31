import 'dart:io';
import 'package:get/get.dart';
import 'APIHelper.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class SignUpController extends GetxController {
  static var number, name, role, licence;
  static File dp = File("");
  static int OTP = 456676;
  var isLoading = false.obs;

  signup() async {
    isLoading(true);

    var msg;
    String url = APIHOST + SIGNUP;
    var stream, len;
    if (dp != null) {
      stream = http.ByteStream(DelegatingStream.typed(dp.openRead()));
      len = await dp.length();

      var req = http.MultipartRequest("POST", Uri.parse(url));
      var multi = new http.MultipartFile(
        "img",
        stream,
        len,
        filename: '${DateTime.now().toIso8601String().split('T')[0]}' +
            basename(dp.path),
      );
      req.files.add(multi);
      req.fields['phone'] = '$number';
      req.fields['code'] = '$licence';
      req.fields['role'] = '$role';
      req.fields['time'] = '${DateTime.now()}';
      req.fields['name'] = '$name';
      var respose = await req.send();
      if (respose.statusCode == 200) {
        //msg = respose.reasonPhrase.toUpperCase();
        await http.Response.fromStream(respose).then((value) {
          print(value.body);
          msg = value.body.replaceAll("null", '');
        });
      } else
        msg = "Server Error";
    } else {
      var req = await http.post(Uri.parse(url), body: {
        'phone': '$number',
        'code': '$licence',
        'role': '$role',
        'time': '${DateTime.now()}',
        'name': '$name',
        'img': ''
      });
      if (req.statusCode != 200) {
        Get.snackbar("Error", "Server Error");
      } else {
        msg = req.body;
      }
    }

    isLoading(false);
    return msg;
  }
}
