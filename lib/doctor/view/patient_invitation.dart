import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/custome_dialog_widget.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/doctor/model/invitaton.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class InvitePatient extends StatefulWidget {
  @override
  _InvitePatientState createState() => _InvitePatientState();
}

class _InvitePatientState extends State<InvitePatient> {
  final formKey = GlobalKey<FormState>();

  final number_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(DoctorHomeController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitation"),
        elevation: 0,
        bottomOpacity: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (txt) {
                        if (txt.length < 10) {
                          return "widget.error";
                        } else {
                          return null;
                        }
                      },
                      controller: number_Controller,
                      style:
                          TextStyle(color: blue, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: blue, width: 1.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: blue, width: 1.0)),
                        labelText: "Phone Number",
                        labelStyle:
                            TextStyle(color: blue, fontWeight: FontWeight.bold),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              if (Platform.isAndroid &&
                                  Platform
                                      .isIOS) if (await Permission.contacts
                                  .request()
                                  .isGranted) {
                                ///

                              }

                              ///
                            },
                            icon: Icon(Icons.contact_page_rounded)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: AnimatedButton(
                      color: blue,
                      text: "Invite",
                      buttonTextStyle: GoogleFonts.ibmPlexSans(
                          fontSize: 25,
                          color: white,
                          fontStyle: FontStyle.italic),
                      pressEvent: () async {
                        if (formKey.currentState.validate()) {
                          bool isValid = true;
                          Get.find<DoctorHomeController>()
                              .invitationList
                              .forEach((element) {
                            //print(element.number);
                            if (element.number == number_Controller.text) {
                              Get.snackbar(
                                "Error",
                                "Already Exist ",
                                icon: Icon(Icons.error),
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              isValid = false;
                              return;
                            }
                          });
                          if (isValid) {
                            var json = await DoctorHomeController()
                                .sendInvitation(number_Controller.text);
                            if (json.body.toString().contains('Failed')) {
                              print(json.body);
                              Get.snackbar("Error", "${json.body}");
                            } else {
                              CustomeDialogWidget().diloagBox("Invitation",
                                  'Invitation Sent Successfully...', context);
                              Get.snackbar("OK", "Sending Successfully");
                              Get.find<DoctorHomeController>()
                                  .updateListOfInvits(InvitationModel(
                                      "${number_Controller.text}",
                                      '',
                                      "waiting"));
                            }
                          } else {
                            Get.snackbar("Error", "Already Exist");
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
