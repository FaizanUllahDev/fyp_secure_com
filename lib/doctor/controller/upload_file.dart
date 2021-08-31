import 'dart:async';

import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';

uploadccd(phone, file, time) async {
  print("enter");
  try {
    String url = APIHOST + uploadCCD;
    //print(finalmsg);
    StreamView<List<int>> stream, sending;
    int len;
    stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
    len = await file.length();
    //List<int> f1st = await stream.first;
    //f1st.first = f1st.first + 10;

    // stream.first.then((value) => value = f1st);

    var req = http.MultipartRequest("POST", Uri.parse(url));
    var multi = new http.MultipartFile(
      "msg",
      stream,
      len,
      filename: basename(file.path),
    );
    req.files.add(multi);
    req.fields['from'] = phone;
    req.fields['time'] = time;
    var uploadRes = await req.send();

    if (uploadRes.statusCode == 200) {
      //msg = respose.reasonPhrase.toUpperCase();
      await http.Response.fromStream(uploadRes).then((value) async {
        print(value.body);
      });
    } else {
      print("Server Error");
      print(uploadRes.reasonPhrase);
    }
    return uploadRes.statusCode;
  } catch (e) {
    print(e);
  }
}
