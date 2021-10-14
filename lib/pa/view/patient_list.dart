import 'package:flutter/material.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/pa/controller/pa_controller.dart';
import 'package:fyp_secure_com/pa/view/add_patient_form.dart';
import 'package:get/get.dart';

class AddRecord extends StatefulWidget {
  final number;

  const AddRecord({Key key, this.number}) : super(key: key);
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  List jsonMap = [];
  bool isLoading = true;
  atStart() async {
    jsonMap = await getPatientList(widget.number);
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    atStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patients"),
        centerTitle: true,
      ),
      body: Container(
        child: isLoading || jsonMap.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: jsonMap.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {
                          Get.to(AddPatientForm(
                            number: jsonMap[index]['number'],
                            img: jsonMap[index]['img'],
                            name: jsonMap[index]['name'],
                            docNumber: widget.number,
                          ));
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              jsonMap[index]['img'] == ""
                                  ? FILES_IMG + "blur.jpg"
                                  : FILES_IMG + jsonMap[index]['img']),
                        ),
                        title: Text(
                          jsonMap[index]['name'].toString().toUpperCase(),
                          style: TextStyle(
                              color: blue, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(jsonMap[index]['number']),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Divider(),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
