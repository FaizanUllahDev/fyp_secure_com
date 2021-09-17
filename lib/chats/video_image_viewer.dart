import 'package:flutter/material.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoImageViewer extends StatelessWidget {
  final file;
  final name;
  final roomList;
  final textOFImage = TextEditingController();
  final index, dbName, img;

  VideoImageViewer(
      {this.file, this.name, this.roomList, this.dbName, this.index, this.img});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: PhotoView(
                  enableRotation: true, imageProvider: FileImage(file)),
            ),
            Obx(
              () => Get.find<ChatController>().uploading.value
                  ? Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    )
                  : Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.white30,
                    //       borderRadius: BorderRadius.circular(35),
                    //     ),
                    //     child: TextField(
                    //       controller: textOFImage,
                    //       cursorColor: Colors.black,
                    //       decoration: InputDecoration(
                    //         enabled: true,
                    //         focusColor: Colors.amber,
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(35),
                    //         ),
                    //         hintText: "Type Here",
                    //         contentPadding:
                    //             EdgeInsets.symmetric(horizontal: 20),
                    //         alignLabelWithHint: true,
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    IconButton(
                      onPressed: () async {
                        //save image to application
                        //  print(index);
                        print("data imgae");
                        Get.find<ChatController>().uploading(true);
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        String gid = pref.getString("gid");
                        if (gid == "" || gid == null) {
                          await ChatController().chatSender(name,
                              roomList.toPhone, file, "image", index, dbName);
                        } else {
                          // await GroupMsg().GroupchatSender(
                          //     name,
                          //     roomList.toPhone,
                          //     file,
                          //     "image",
                          //     index,
                          //     dbName,
                          //     img);
                        }
                        // Obx(() {

                        Get.find<ChatController>().uploading(false);
                        print(Get.find<ChatController>().uploading.value);
                        if (Get.find<ChatController>().uploading.value)
                          CircularProgressIndicator();
                        else {
                          print(Get.find<ChatController>().uploading.value);
                          Get.back();
                        }
                        //  });
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 58.0),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.amber,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
