import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
                                            Expanded(
                                              child: Text(
                                                "Presenting Illness : "
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(snapshot.data[index]
                                                  ['presentingIllness']),
                                            ),
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
                : getView(0),
          ],
        ),
      ),
    );
  }

  getView(index) {
    return widget.data != ""
        ? Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Procedure : ".toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Text(widget.data[index]['pro'])),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Medications : ".toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Text(widget.data[index]['med'])),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Presenting Illness : ".toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Text(widget.data[index]['presentingIllness'])),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Date : ".toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Text(widget.data[index]['curDate']
                            .toString()
                            .split(" ")[0])),
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
