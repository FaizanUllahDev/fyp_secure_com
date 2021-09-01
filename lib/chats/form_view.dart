import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:http/http.dart' as http;

class FormView extends StatefulWidget {
  final pnumber, docNumber, data;

  const FormView({Key key, this.pnumber, this.docNumber, this.data})
      : super(key: key);

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  bool isHistoryOpen = false;

  getPHistory() async {
    Uri url = Uri.parse(APIHOST + "getFormViewHistory.php");
    var res = await http.post(url, body: {
      "pnum": widget.pnumber,
      "docnum": widget.docNumber,
    });
    if (res.statusCode == 200) {
      // print(res.body);
      return jsonDecode(res.body);
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isHistoryOpen
                ? Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          future: getPHistory(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting)
                              return CircularProgressIndicator();
                            //  print(snapshot.data);
                            if (snapshot.data is String || !snapshot.hasData) {
                              return Text("Not Found");
                            }
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (ctx, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Procedure : ".toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(snapshot.data[index]['pro']),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Medications : ".toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(snapshot.data[index]['med']),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Date : ".toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(snapshot.data[index]['curDate']
                                                .toString()
                                                .split(" ")[0]),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          }),
                    ),
                  )
                : getView(widget.data, 0),
          ],
        ),
      ),
    );
  }

  getView(snapshot, index) {
    return widget.data != null && snapshot is String == false
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Procedure : ".toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(snapshot[index]['pro']),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Medications : ".toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(snapshot[index]['med']),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Date : ".toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(snapshot[index]['curDate'].toString().split(" ")[0]),
                  ],
                )
              ],
            ),
          )
        : Center(
            child: Text("Not Found .. \n Searching ... "),
          );
  }
}
