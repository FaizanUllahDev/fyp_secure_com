import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fyp_secure_com/animations/fadeAnimation.dart';
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
                Stack(
                  children: [
                    ClipPath(
                      child: Container(
                        color: Colors.blue[400],
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                      ),
                      clipper: WaveClipperOne(),
                    ),
                    ClipPath(
                      child: Container(
                        color: Colors.blue[600],
                        height: 160,
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Send Invitation To Patient",
                            style: GoogleFonts.pacifico(
                                fontSize: 30, color: white),
                          ),
                        ),
                      ),
                      clipper: WaveClipperTwo(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    child: FadeAnimation(
                      0,
                      TextFormField(
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
                          labelStyle: TextStyle(
                              color: blue, fontWeight: FontWeight.bold),
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
                      // CustomTextField(

                      //   error: 'Invalid Number ',
                      //   crontroller: number_Controller,
                      //   label: "Number",
                      //   isPassword: false,
                      //   keyboard: TextInputType.phone,
                      //   icon: Icon(
                      //     Icons.phone,
                      //     size: 27,
                      //     color: blue,
                      //   ),
                      // ),
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
                              Get.snackbar("OK", "Sending Successfully");
                              Get.find<DoctorHomeController>()
                                  .updateListOfInvits(InvitationModel(
                                      "${number_Controller.text}",
                                      '',
                                      "waiting"));
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.SUCCES,
                                body: Center(
                                  child: Text(
                                    'Invitation Sent Successfully...',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 25),
                                  ),
                                ),
                                title: 'This is Ignored',
                                desc: 'This is also Ignored',
                                btnOkOnPress: () {
                                  Get.back();
                                },
                              )..show();
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
