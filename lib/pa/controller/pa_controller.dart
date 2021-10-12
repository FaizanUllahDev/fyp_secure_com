import 'dart:convert';

import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

getPatientList(String numberOfPa) async {
  //print(numberOfPa);
  SharedPreferences pref = await SharedPreferences.getInstance();
  Uri uri = Uri.parse(APIHOST + "getPatientList.php");

  var res = await http.post(
    uri,
    body: {
      "num": numberOfPa.toString(),
    },
    headers: {
      "Authorization": pref.containsKey("token") ? pref.get("token") : ""
    },
  );

  if (res.statusCode == 200) {
    //print(res.body);
    var a = jsonDecode(res.body);

    return a;
  } else {
    print(res.statusCode);
    return [];
  }
}
