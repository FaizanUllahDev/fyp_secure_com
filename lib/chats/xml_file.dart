import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/doctor/controller/upload_file.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class XmlFile extends StatefulWidget {
  final number;

  const XmlFile({this.number});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<XmlFile> {
  int _counter = 0;
  XmlDocument document = XmlDocument();
  List<XmlElement> titles = [];
  List<XmlElement> tables = [];
  List<DataTableSource> d = [];
  PageController controller = PageController(initialPage: 0);

  List<DataColumn> head = [];
  List<DataRow> rows = [];
  String path = '';
  String ccdDate = '', ccdFile = '';

  String _dateTime = '';
  List checkByReferDoctor = [];
  var gid = '';

  atStart() async {
    print("CCD NUMBER ===== > " + widget.number);
    ccdDate = "${widget.number}_ccddate";
    ccdFile = "${widget.number}_ccd";

    SharedPreferences pref = await SharedPreferences.getInstance();
    print("object ... " + pref.getString(ccdFile).toString());

    //dowloadccd();
    FriendsModel m;

    gid = pref.getString("gid");
    print("GID = " + gid);
    if (gid != null || gid != "") {
      dowloadccd();
    } else {
      setState(() {
        path = pref.getString(ccdFile).toString() == null
            ? ""
            : pref.getString(ccdFile);
        _dateTime =
            pref.getString(ccdDate) == null ? "" : pref.getString(ccdDate);
      });
      print(path.toString() + "....\n..." + _dateTime.toString());
      fetchCCD(path);
    }

    // if (m.phone == "") {
    // } else if (path != '' && path != null) {}
    // // print(pref.getString("${widget.number}_ccd"));
    // print(path);
  }

  @override
  void initState() {
    super.initState();
    atStart();
  }

  List<String> choices = <String>[
    "Impoert CCD File",
    //"Allow to Patient",
    // "Clear CCD",
  ];
  int currentIndex = 0;
  List<String> names = [];
  List<int> ccdIndex = [];
  List<String> allowTitles = [];

  //new NeverScrollableScrollPhysics()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: titles.length > 0
          ? Container(
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8),
                            child: Text(
                              "Visited Date : " + _dateTime,
                              style: TextStyle(color: white),
                            ),
                          ),
                          gid != ''
                              ? Container()
                              : PopupMenuButton(
                                  color: white,
                                  icon: Icon(
                                    Icons.more_vert_outlined,
                                    color: white,
                                  ),
                                  onSelected: (String v) async {
                                    if (v == choices[0]) {
                                      var d = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2200),
                                      );
                                      _dateTime = d
                                          .toString()
                                          .split('T')[0]
                                          .split(' ')[0];
                                      print(_dateTime);

                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.setString(ccdDate, _dateTime);

                                      setState(() {
                                        _dateTime;
                                      });
                                      pickFile();
                                    }
                                    // else if (v == choices[1]) {
                                    //   //allow

                                    //   //patient
                                    // }
                                    // else if (choices[1] == v) {
                                    //   SharedPreferences pref =
                                    //       await SharedPreferences.getInstance();
                                    //   pref.remove("${widget.number}_ccd");
                                    //   path = '';
                                    //   titles.clear();
                                    //   head.clear();
                                    //   rows.clear();
                                    //   setState(() {});
                                    // }
                                  },
                                  padding: EdgeInsets.zero,
                                  // initialValue: choices[_selection],
                                  itemBuilder: (BuildContext context) {
                                    return choices.map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                        ],
                      )),
                  GetBuilder<ChatManager>(
                      init: ChatManager(),
                      initState: (_) {},
                      builder: (_) {
                        ccdIndex.clear();
                        return Container(
                          height: 45,
                          child: ListView.builder(
                              // gridDelegate:
                              //     SliverGridDelegateWithMaxCrossAxisExtent(
                              //         maxCrossAxisExtent: 100,
                              //         childAspectRatio: 2 / 1,
                              //         crossAxisSpacing: 0,
                              //         mainAxisSpacing: 0),
                              itemCount: names.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (ctx, index) {
                                String ccdName = names[index];
                                // String ccdName = titles[index]
                                //     .findAllElements('title')
                                //     .toList()[0]
                                //     .firstChild
                                //     .text
                                //     .split(',')[0]
                                //     .toLowerCase();

                                if (allowTitles.isEmpty) {
                                  if (ccdName == "allergies" ||
                                      ccdName == "medications" ||
                                      ccdName == "procedures" ||
                                      ccdName == "immunizations") {
                                    ccdIndex.add(index);
                                    // ChatManager().updateCurrentIndex(index);
                                    return InkWell(
                                      onTap: () {
                                        print(ccdIndex);
                                        print(index);
                                        controller.jumpToPage(index);
                                        _.currentIndex = index;
                                        ChatManager().updateSelectedInd(index);
                                      },
                                      child: Container(
                                        //  / height: 50,
                                        margin: EdgeInsets.only(
                                            top: 2, left: 2, right: 0),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: _.selectedInd == index
                                              ? white
                                              : Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(1),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "medications" == names[index]
                                                ? "  RX  "
                                                : "${names[index]}",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else
                                    return Center();
                                } else if (allowTitles.firstWhere(
                                        (element) => element == ccdName,
                                        orElse: () => "") ==
                                    ccdName) {
                                  return InkWell(
                                    onTap: () {
                                      print(ccdIndex);
                                      print(index);
                                      controller.jumpToPage(index);
                                      _.currentIndex = index;
                                      ChatManager().updateSelectedInd(index);
                                    },
                                    child: Container(
                                      //  / height: 50,
                                      margin: EdgeInsets.only(
                                          top: 2, left: 2, right: 0),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: _.selectedInd == index
                                            ? white
                                            : Colors.blue,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "medications" == names[index]
                                              ? "  RX  "
                                              : "${names[index]}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                } else
                                  return Center();
                              }),
                        );
                      }),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        onPageChanged: (ind) {
                          Get.find<ChatManager>().updateSelectedInd(ind);
                          setState(() {});
                        },
                        allowImplicitScrolling: false,
                        pageSnapping: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: titles.length,
                        itemBuilder: (ctx, ind) {
                          getContant(ind);
                          return SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: [
                                  // Container(
                                  //   margin: EdgeInsets.only(top: 7, bottom: 7),
                                  //   padding: EdgeInsets.all(8.0),
                                  //   decoration: BoxDecoration(
                                  //     color: white,
                                  //     borderRadius: BorderRadius.circular(30),
                                  //   ),
                                  //   child: Text(
                                  //     "${titles[ind].findAllElements('title').toList()[0].firstChild}",
                                  //     style: TextStyle(color: blue),
                                  //   ),
                                  // ),
                                  // Text('''
                                  //       ${all.first.findAllElements('tbody').first.findAllElements('tr').toList()[0]}
                                  //       '''),
                                  // Text(
                                  //     "${titles[ind].findAllElements('text').toList()[0].findAllElements('tbody').first.findAllElements('tr')}"),
                                  head.length > 0 && rows.length > 0
                                      ? DataTable(
                                          columns: head,
                                          rows: rows,
                                          headingRowColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        )
                                      : Text(
                                          "Empty ... ",
                                          style: TextStyle(color: white),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 150,
                child: TextButton(
                  onPressed: () async {
                    print("${widget.number}_ccd");
                    var d = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2200),
                    );
                    _dateTime = d.toString().split('T')[0].split(' ')[0];
                    print(_dateTime);

                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString(ccdDate, _dateTime);
                    pickFile();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Import CCD"),
                      Icon(Icons.add),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  dowloadccd() async {
    //Get.find<FriendController>().getReferGroupListFun(widget.number);
    print("Enter CCD");
    if (await Permission.storage.request().isGranted) {
      try {
        var url;
        // print("Enter CCD");
        await ChatController().getDirpPath();
        var documentDirectory = await getExternalStorageDirectory();
        //var firstPath = documentDirectory.path + "/$folderName/img";
        var savefileName = Get.find<ChatController>().currNumber.value +
            '$fileChecker' +
            widget.number +
            ".xml";

        var filePathAndName;

        filePathAndName =
            documentDirectory.path + '/$folderName/img/$savefileName';
        //print(File(filePathAndName).existsSync());
        {
          url = FILES_ccd + widget.number + '.xml';

          var response = await http.get(Uri.parse(url)); // <--2

          // print(
          //     "//////////////////////////////////////////////////////////////////////////////////////////" +
          //         filePathAndName);
          File file2 = new File(filePathAndName); // <-- 2
          file2.writeAsBytesSync(response.bodyBytes); // <-- 3
          // print(file2.lastModifiedSync());
        }
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("${widget.number}_ccd", filePathAndName);
        _dateTime = DateTime.now().toString().split('T')[0].split(' ')[0];
        pref.setString(ccdDate, _dateTime);
        // print(pref.getString("${widget.number}_ccd"));

        var res = await http.post(Uri.parse(APIHOST + "getTitle.php"), body: {
          "pnum": "${widget.number}",
          "dnum": Get.find<ChatController>().currNumber.value
        });

        if (res.statusCode == 200) {
          List dbd = jsonDecode(res.body);
          print("CCD ALLOW ");
          dbd = jsonDecode(dbd[0]);
          // print(dbd.last);
          dbd.forEach((element) {
            allowTitles.add(element);
            print(element);
          });
          // setState(() {});
          fetchCCD(filePathAndName);
          setState(() {});
        } else {
          FriendsModel model = Get.find<FriendController>()
              .getreferList
              .firstWhere((element) => element.phone == widget.number,
                  orElse: () =>
                      FriendsModel("name", " phone", "_status", "role", false));

          // print("Enter in ccd");
          // print(model.role);
          // var allow = jsonDecode(model.role);
          // // print("Abc => " + allow);
          // allow.forEach((element) {
          //   allowTitles.add(element);
          //   print(element);
          // });
          // setState(() {});
        }
        // setState(() {});
        // fetchCCD(filePathAndName);
        //
      } catch (e) {
        print(e);
      }
    }
    print(allowTitles);
  }

  pickFile() async {
    try {
      await Permission.storage.request().isGranted;
      final picker = await FilePicker.platform.pickFiles();

      if (picker != null) {
        String path = picker.files.single.path;
        setState(() {});
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("${widget.number}_ccd", path);
        print(pref.getString("${widget.number}_ccd"));

        uploadccd(
          widget.number,
          File(path),
          _dateTime,
        );
        fetchCCD(path);

        ///

        ///
      } else {
        // User canceled the picker
        print("Not Picked");
      }
    } catch (e) {
      print(e);
    }
  }

  fetchCCD(path) async {
    final file = new File(path);
    document = XmlDocument.parse(file.readAsStringSync());

    titles.clear();
    names.clear();
    document
        .findAllElements('ClinicalDocument')
        .toList()
        .first
        .findElements('component')
        .first
        .findAllElements('structuredBody')
        .forEach((compList) {
      compList.findAllElements("component").forEach((sectionList) {
        sectionList.findAllElements("section").forEach((titleList) {
          titles.add(titleList);
        });
      });
    });
    setState(() {});
    SharedPreferences pref = await SharedPreferences.getInstance();

    titles.forEach((element) {
      String ccdName = element
          .findAllElements('title')
          .toList()[0]
          .firstChild
          .text
          .split(',')[0]
          .toLowerCase();
      names.add(ccdName);
    });
    pref.setString("titles", jsonEncode(names));
  }

  getContant(ind) {
    head.clear();
    rows.clear();
    if (titles[ind]
            .findAllElements('text')
            .toList()[0]
            .findAllElements('table')
            .toList()
            .length >
        0) {
      List<XmlElement> all = titles[ind]
          .findAllElements('text')
          .toList()[0]
          .findAllElements('table')
          .toList();

      List<XmlElement> thead = all.first
          .findAllElements("thead")
          .first
          .findAllElements('tr')
          .first
          .findAllElements('th')
          .toList();

      thead.forEach((element) {
        head.add(DataColumn(
          label: Container(
            color: white,
            child: Text(
              element.firstChild.toString(),
              maxLines: 1,
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ));
      });

      var t = all.first
          .findAllElements('tbody')
          .first
          .findAllElements('tr')
          .toList();

      t.forEach((trs) {
        // print(trs);

        List<DataCell> cells = [];

        if (trs.findAllElements('th').toList().length > 0) {
          var c = trs.findAllElements('th').toList();

          c.forEach((element) {
            // print(element.firstChild);
            var a = element.firstChild;
            if (element.findAllElements('content').toList().length > 0) {
              var contectv = element.findAllElements('content').toList()[0];
              if (contectv.firstChild.toString() == '')
                a = contectv.parent.children[2];
              else
                a = contectv.firstChild;
            }
            cells.add(DataCell(
                Text(
                  "$a",
                  style: TextStyle(color: Colors.white),
                ),
                placeholder: true));
          });

          rows.add(DataRow(
              cells: cells,
              selected: true,
              color: MaterialStateProperty.all(Colors.blue)));

          print('\n TH ${rows.length}\n');
        }

        var c = trs.findAllElements('td').toList();
        //print(c.length);
        c.forEach((element) {
          print('\n\n');
          var a;
          // print(element.firstChild.text);

          a = element.firstChild;
          if (element.findAllElements('content').toList().length > 0) {
            var contectv = element.findAllElements('content').toList()[0];
            if (contectv.firstChild == null)
              a = contectv.parent.children[2];
            else
              a = contectv.firstChild;
          }
          cells.add(DataCell(
              Text(
                "$a",
                style: TextStyle(color: white),
              ),
              placeholder: true));
        });

        rows.add(DataRow(
            cells: cells,
            selected: true,
            color: MaterialStateProperty.all(Colors.blue)));
        // print(" =====> ${cells.length}");
      });
    }
  }
}
