import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:http/http.dart' as http;

class FormView extends StatefulWidget {
  final pnumber, docNumber;

  const FormView({Key key, this.pnumber, this.docNumber}) : super(key: key);

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  bool isHistoryOpen = false;

  getFormView() async {
    Uri url = Uri.parse(APIHOST + "getFormView.php");
    var res = await http.post(url, body: {
      "pnum": widget.pnumber,
      "docnum": widget.docNumber,
    });
    if (res.statusCode == 200) {
      print(res.body);
      return jsonDecode(res.body);
    } else {
      print(res.body);
      return "";
    }
  }

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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: isHistoryOpen ? getPHistory() : getFormView(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();
                      print(snapshot.data);
                      if (snapshot.data is String || !snapshot.hasData) {
                        return Text("Not Found");
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (ctx, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
            ),
            /*
            isHistoryOpen
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isHistoryOpen = false;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Close History",
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isHistoryOpen = true;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "History",
                          style: TextStyle(color: white),
                        ),
                      ),
                    ),
                  ),
                  */
          ],
        ),
      ),
    );
  }
}
