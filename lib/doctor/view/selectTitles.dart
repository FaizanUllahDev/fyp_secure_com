import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/doctor/model/names.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SelectTitleCcd extends StatefulWidget {
  final ccdTitles;
  final pNumber;

  const SelectTitleCcd({this.ccdTitles, this.pNumber});
  @override
  _SelectTitleCcdState createState() => _SelectTitleCcdState();
}

class _SelectTitleCcdState extends State<SelectTitleCcd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Check The Titles  !",
          // style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                List<CcdNames> names = [];
                names = widget.ccdTitles
                    .where((element) => element.isCheck == true)
                    .toList();
                var jsonDe = jsonEncode(names);
                uploadRefer(Get.find<ChatController>().currNumber.value,
                    context, jsonDe);
              },
              icon: Icon(Icons.done)),
        ],
      ),
      body: ListView.builder(
          itemCount: widget.ccdTitles.length,
          itemBuilder: (ctx, index) {
            return Container(
              child: Row(
                children: [
                  Checkbox(
                      checkColor: Colors.white,
                      activeColor: Colors.blue,
                      value: widget.ccdTitles[index].isCheck,
                      onChanged: (t) {
                        widget.ccdTitles[index].isCheck = t;

                        setState(() {});
                        print(t);
                      }),
                  Text(
                    widget.ccdTitles[index].name,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }),
    );
  }

  uploadRefer(docPhone, context, jsonname) async {
    var json = await http.post(
      Uri.parse(APIHOST + referList),
      body: {
        "allowTitles": jsonname,
        "doctorRefer": widget.pNumber.toString(),
        "referFrom": docPhone.toString(),
      },
    );
    if (json.statusCode == 200) {
      AwesomeDialog(
        context: context,
        animType: AnimType.RIGHSLIDE,
        dialogType: DialogType.SUCCES,
        body: Container(),
        buttonsTextStyle: TextStyle(fontSize: 25),
        btnOkText: "Refered SuccessFully  ! ",
        btnOkOnPress: () {},
      )..show();
      print("Refered !");
    } else {
      print(json.body);
    }
  }
}
