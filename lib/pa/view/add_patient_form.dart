import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/custome_dialog_widget.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddPatientForm extends StatefulWidget {
  final number, img, name, docNumber;

  const AddPatientForm(
      {Key key, this.number, this.img, this.name, this.docNumber})
      : super(key: key);
  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final proController = TextEditingController();
  final medController = TextEditingController();
  bool isLoading = false;
  final fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.img == ""
                  ? FILES_IMG + "blur.jpg"
                  : FILES_IMG + widget.img),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.name)
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: fKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Procedure: "),
                      ),
                      Flexible(
                          child: TextFormField(
                        controller: proController,
                        validator: (t) {
                          return t.length > 0 ? null : "Enter Procedure";
                        },
                      )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Medication: "),
                      ),
                      Flexible(
                          child: TextFormField(
                        controller: medController,
                        validator: (t) {
                          return t.length > 0 ? null : "Enter Medications";
                        },
                      )),
                    ],
                  ),
                  SizedBox(height: 40),
                  isLoading
                      ? CircularProgressIndicator()
                      : InkWell(
                          onTap: () async {
                            print("///////////// " + LoginController.number);
                            if (fKey.currentState.validate()) submit();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: blue,
                            ),
                            child: Center(
                              child: Text(
                                "Add History",
                                style: TextStyle(color: white, fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submit() async {
    isLoading = true;
    if (mounted) setState(() {});
    Uri uri = Uri.parse(APIHOST + formdataOfPatient);
    var res = await http.post(uri, body: {
      "number": widget.number,
      "pro": proController.text,
      "med": medController.text,
      "fromDoc": widget.docNumber,
      "paNumber": LoginController.number,
      "curDate": DateTime.now().toString(),
    });
    isLoading = false;
    if (mounted) setState(() {});
    if (res.statusCode == 200) {
      //Get.snackbar("Alert", "Data Saved ... ");
      CustomeDialogWidget().diloagBox("Alert", "Data Saved!", context);
    } else
      CustomeDialogWidget().diloagBox("Alert", "Failed!", context);
  }
}
