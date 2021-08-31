import 'dart:convert';

import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:http/http.dart' as http;

getPatientList(String numberOfPa) async {
  //print(numberOfPa);
  Uri uri = Uri.parse(APIHOST + "getPatientList.php");

  var res = await http.post(
    uri,
    body: {
      "num": numberOfPa.toString(),
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
