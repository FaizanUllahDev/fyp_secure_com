import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:fyp_secure_com/CustomsWidget/chat_bubble.dart';
import 'package:fyp_secure_com/chats/audio_player.dart';
import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
import 'package:fyp_secure_com/chats/group/groupSent_recieve.dart';
import 'package:fyp_secure_com/chats/photo_viewer.dart';
import 'package:fyp_secure_com/chats/video_image_viewer.dart';
import 'package:fyp_secure_com/chats/xml_file.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/hiveBox/chat_room.dart';
import 'package:fyp_secure_com/hiveBox/forward_class.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;
// Import package

class GroupListpage extends StatefulWidget {
  final ChatRoom chatRoom;
  final name, img;

  const GroupListpage({Key key, this.chatRoom, this.name, this.img})
      : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<GroupListpage> {
  String dbName;
  //FlutterRecord _flutterRecord;

  AutoScrollController controller;

  final ScrollController _scrollController = ScrollController();
  //Box<ChatRoom> box;
  int lengthofChat = 0;
  String role;

  //////audio
  ///
  final message = TextEditingController();
  bool isPlaying = false;
  String playerTxt = '';

  bool isTyped = false;
  //var _playerSubscription;
  bool isAudioSending = false;
  Directory folder_path;
  FlutterSoundRecorder flutterSound;
  String path;

  double xmlH = 100;
  bool isCcdAllowForPatient = false;

  //AudioCache cache = AudioCache();
  atStartCheckPatientAllowing() async {
    //var res = http.post(Uri.parse(APIHOST + "checkPatientCCdAllow.php"));
  }

  init() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.get('role');

    var gid = pref.getString("gid");
    dbName = '${Get.find<ChatController>().currNumber.value}' + "_" + gid;
    isCcdAllowForPatient = pref.getString("isCcdAllow") == null ||
            pref.getString("isCcdAllow") == '0'
        ? false
        : true;
    print(isCcdAllowForPatient);
    setState(() {});

    print("DBNAME => " + dbName);
    //box = await Hive.openBox<ChatRoom>('$dbName');
  }

  @override
  void initState() {
    super.initState();
    flutterSound = FlutterSoundRecorder();
    // _flutterRecord = FlutterRecord();
    init();
  }

  _scrollTo(ind) async {
    try {
      await controller.scrollToIndex(ind,
          duration: Duration(microseconds: 200),
          preferPosition: AutoScrollPosition.begin);
      await controller.highlight(ind);
    } catch (e) {}
  }

  double h = 50;

  @override
  Widget build(BuildContext context) {
    controller = AutoScrollController(
        keepScrollOffset: true,
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    final size = MediaQuery.of(context).size;
//getPatientCCDIFAllowing
    //print("DBNAme => $dbName");

    return Container(
      margin: EdgeInsets.only(top: 0),
      color: Colors.white,
      child: Column(
        children: [
          role == 'Doctor'
              ? GestureDetector(
                  onVerticalDragUpdate: (detail) {
                    print(detail.delta.dy);
                    print(h);
                    if (detail.delta.dy.toString().contains('-')) {
                      if (h != 50) {
                        h -= 3;
                      }
                    } else if (h < (MediaQuery.of(context).size.height - 200)) {
                      h += 3;
                    }
                    Get.find<ChatManager>().updateHBox(h);
                  },
                  child: GetBuilder<ChatManager>(
                    init: ChatManager(),
                    initState: (_) {},
                    builder: (_) {
                      return Container(
                        height: _.boxH,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                child: XmlFile(
                              number: widget.name.split('_')[1],
                            )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : isCcdAllowForPatient
                  ? Text("data")
                  : Container(),
          Expanded(
            child: FutureBuilder(
              future: Hive.openBox<ChatRoom>(dbName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else
                  return GetBuilder<ChatManager>(
                    init: ChatManager(),
                    initState: (_) {},
                    builder: (_) {
                      return ValueListenableBuilder(
                        valueListenable:
                            Hive.box<ChatRoom>(dbName).listenable(),
                        builder: (BuildContext context, Box<ChatRoom> box,
                            Widget child) {
                          if (box.values.isBlank) {
                            return Center(
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Text(
                                    "End-To-End Encrpted Chat",
                                    style: CustomStyles.foreclr.copyWith(
                                        color: Colors.blue, fontSize: 15),
                                  )),
                            );
                          }
                          // print("...---" +
                          //     _.forwardIndexesSelected.length.toString());
                          return _.forwardIndexesSelected.length == 0
                              ? showChatDetails(box)
                              : showSelectedViewOFChat(box);
                        },
                      );
                    },
                  );
              },
            ),
          ),
          //bottom bar
          GetBuilder<ChatManager>(
            init: ChatManager(),
            initState: (_) {},
            builder: (_) {
              return _.forwardIndexesSelected.length == 0
                  ? Container(
                      decoration: BoxDecoration(color: Colors.white),
                      height: 70,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Container(
                            height: 50,
                            child: TextField(
                              controller: message,
                              onSubmitted: (v) {
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn);
                              },
                              onChanged: (v) {
                                v.isEmpty
                                    ? Get.find<ChatController>()
                                        .updateTyped(false)
                                    : Get.find<ChatController>()
                                        .updateTyped(true);
                              },
                              decoration: InputDecoration(
                                isDense: false,
                                contentPadding:
                                    EdgeInsets.only(right: 10, left: 20),
                                fillColor: Colors.blue,
                                enabled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                hintText: "Type a message",
                                suffixIcon: Container(
                                  width: 78,
                                  child: Row(
                                    children: [
                                      InkWell(
                                          onTap: () =>
                                              pickFile(ImageSource.gallery),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.attach_file_sharp,
                                              color: Colors.blue,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      InkWell(
                                          onTap: () =>
                                              pickFile(ImageSource.camera),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              CupertinoIcons.camera,
                                              color: Colors.blue,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                          SizedBox(
                            width: 5,
                          ),
                          Obx(() {
                            final con = Get.find<ChatController>();
                            return !con.isTyped.value
                                ? InkWell(
                                    onTap: () async {
                                      if (await Permission.microphone
                                              .request()
                                              .isGranted &&
                                          await Permission.storage
                                              .request()
                                              .isGranted) {
                                        !isPlaying ? recordAudio() : stopRec();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: !isPlaying
                                          ? Icon(
                                              Icons.mic,
                                              color: Colors.white,
                                              size: 40,
                                            )
                                          : !isAudioSending
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 30,
                                                  child: Lottie.asset(
                                                      "assets/images/mic.json"),
                                                )
                                              : CircularProgressIndicator(),
                                    ))
                                : InkWell(
                                    onTap: () async {
                                      GroupMsg().GroupchatSender(
                                        widget.name,
                                        widget.chatRoom.toPhone,
                                        message.text,
                                        'text',
                                        0,
                                        dbName,
                                        widget.img,
                                      );
                                      message.clear();
                                      con.updateTyped(false);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  );
                          }),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: 30,
                    );
            },
          ),
        ],
      ),
    );

    // return Container(
    //   margin: EdgeInsets.only(top: 0),
    //   color: Colors.white,
    //   child: Column(
    //     children: [
    //       role == 'Doctor'
    //           ? GestureDetector(
    //               onVerticalDragUpdate: (detail) {
    //                 print(detail.delta.dy);
    //                 print(h);
    //                 if (detail.delta.dy.toString().contains('-')) {
    //                   if (h != 50) {
    //                     h -= 3;
    //                   }
    //                 } else if (h < (MediaQuery.of(context).size.height - 200)) {
    //                   h += 3;
    //                 }
    //                 Get.find<ChatManager>().updateHBox(h);
    //               },
    //               child: GetBuilder<ChatManager>(
    //                 init: ChatManager(),
    //                 initState: (_) {},
    //                 builder: (_) {
    //                   return Container(
    //                     height: _.boxH,
    //                     color: Colors.black,
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.end,
    //                       children: [
    //                         Expanded(
    //                             child: XmlFile(
    //                           number: widget.chatRoom.toPhone,
    //                         )),
    //                         Align(
    //                           alignment: Alignment.bottomCenter,
    //                           child: Icon(
    //                             Icons.menu,
    //                             color: Colors.white,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   );
    //                 },
    //               ),
    //             )
    //           : isCcdAllowForPatient
    //               ? Text("data")
    //               : Container(),
    //       Expanded(
    //         child: FutureBuilder(
    //           future: Hive.openBox<ChatRoom>(dbName),
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return Center(child: CircularProgressIndicator());
    //             } else
    //               return ValueListenableBuilder(
    //                 valueListenable: Hive.box<ChatRoom>(dbName).listenable(),
    //                 builder: (BuildContext context, Box<ChatRoom> box,
    //                     Widget child) {
    //                   if (box.values.isBlank) {
    //                     return Center(
    //                       child: Container(
    //                           padding: EdgeInsets.symmetric(vertical: 30),
    //                           child: Text(
    //                             "End-To-End Encrpted Chat",
    //                             style: CustomStyles.foreclr
    //                                 .copyWith(color: Colors.blue, fontSize: 15),
    //                           )),
    //                     );
    //                   }
    //                   // print("...---" +
    //                   //     _.forwardIndexesSelected.length.toString());
    //                   return true //_.forwardIndexesSelected.length == 0
    //                       ? showChatDetails(box)
    //                       : showSelectedViewOFChat(box);
    //                 },
    //               );
    //           },
    //         ),
    //       ),
    //       //bottom bar

    //       Get.find<ChatManager>().forwardIndexesSelected.length == 0
    //           ? Container(
    //               decoration: BoxDecoration(color: Colors.white),
    //               height: 70,
    //               padding: EdgeInsets.symmetric(vertical: 10),
    //               width: size.width,
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 textBaseline: TextBaseline.alphabetic,
    //                 children: [
    //                   SizedBox(
    //                     width: 5,
    //                   ),
    //                   Expanded(
    //                       child: Container(
    //                     height: 50,
    //                     child: TextField(
    //                       controller: message,
    //                       onSubmitted: (v) {
    //                         _scrollController.animateTo(
    //                             _scrollController.position.maxScrollExtent,
    //                             duration: Duration(milliseconds: 300),
    //                             curve: Curves.fastOutSlowIn);
    //                       },
    //                       onChanged: (v) {
    //                         v.isEmpty
    //                             ? Get.find<ChatController>().updateTyped(false)
    //                             : Get.find<ChatController>().updateTyped(true);
    //                       },
    //                       decoration: InputDecoration(
    //                         isDense: false,
    //                         contentPadding:
    //                             EdgeInsets.only(right: 10, left: 20),
    //                         fillColor: Colors.blue,
    //                         enabled: true,
    //                         border: OutlineInputBorder(
    //                           borderRadius: BorderRadius.circular(35),
    //                         ),
    //                         hintText: "Type a message",
    //                         suffixIcon: Container(
    //                           width: 78,
    //                           child: Row(
    //                             children: [
    //                               InkWell(
    //                                   onTap: () =>
    //                                       pickFile(ImageSource.gallery),
    //                                   child: Container(
    //                                     decoration: BoxDecoration(
    //                                       shape: BoxShape.circle,
    //                                     ),
    //                                     child: Icon(
    //                                       Icons.attach_file_sharp,
    //                                       color: Colors.blue,
    //                                     ),
    //                                   )),
    //                               SizedBox(
    //                                 width: 9,
    //                               ),
    //                               InkWell(
    //                                   onTap: () => pickFile(ImageSource.camera),
    //                                   child: Container(
    //                                     decoration: BoxDecoration(
    //                                       shape: BoxShape.circle,
    //                                     ),
    //                                     child: Icon(
    //                                       CupertinoIcons.camera,
    //                                       color: Colors.blue,
    //                                     ),
    //                                   )),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   )),
    //                   SizedBox(
    //                     width: 5,
    //                   ),
    //                   Obx(() {
    //                     final con = Get.find<ChatController>();
    //                     return !con.isTyped.value
    //                         ? InkWell(
    //                             onTap: () async {
    //                               if (await Permission.microphone
    //                                       .request()
    //                                       .isGranted &&
    //                                   await Permission.storage
    //                                       .request()
    //                                       .isGranted) {
    //                                 !isPlaying ? recordAudio() : stopRec();
    //                               }
    //                             },
    //                             child: Container(
    //                               padding: EdgeInsets.all(5),
    //                               decoration: BoxDecoration(
    //                                 color: Colors.blue,
    //                                 shape: BoxShape.circle,
    //                               ),
    //                               child: !isPlaying
    //                                   ? Icon(
    //                                       Icons.mic,
    //                                       color: Colors.white,
    //                                       size: 40,
    //                                     )
    //                                   : !isAudioSending
    //                                       ? CircleAvatar(
    //                                           backgroundColor:
    //                                               Colors.transparent,
    //                                           radius: 30,
    //                                           child: Lottie.asset(
    //                                               "assets/images/mic.json"),
    //                                         )
    //                                       : CircularProgressIndicator(),
    //                             ))
    //                         : InkWell(
    //                             onTap: () async {
    //                               ChatController().chatSender(
    //                                   widget.name,
    //                                   widget.chatRoom.toPhone,
    //                                   message.text,
    //                                   'text',
    //                                   0,
    //                                   dbName);
    //                               message.clear();
    //                               con.updateTyped(false);
    //                             },
    //                             child: Container(
    //                               padding: EdgeInsets.all(5),
    //                               decoration: BoxDecoration(
    //                                 color: Colors.blue,
    //                                 shape: BoxShape.circle,
    //                               ),
    //                               child: Icon(
    //                                 Icons.send_rounded,
    //                                 color: Colors.white,
    //                                 size: 40,
    //                               ),
    //                             ),
    //                           );
    //                   }),
    //                   SizedBox(
    //                     width: 5,
    //                   ),
    //                 ],
    //               ),
    //             )
    //           : Container(
    //               height: 30,
    //             ),
    //     ],
    //   ),
    // );
  }

  Widget showChatDetails(Box<ChatRoom> box) {
    _scrollTo(box.values.length);
    controller.highlight(box.values.length);
    return ListView.builder(
      // controller: controller,
      controller: controller,
      itemCount: box.values.length,
      itemBuilder: (ctx, index) {
        // controller.scrollToIndex(index,
        //     preferPosition: AutoScrollPosition.begin);
        final data = box.values.toList()[index];
        var isfrom = false;
        if (data.fromPhone == widget.chatRoom.fromPhone) isfrom = true;
        return AutoScrollTag(
          key: ValueKey(index),
          controller: controller,
          index: index,
          highlightColor: Colors.black.withOpacity(0.1),
          child: InkWell(
            onLongPress: () {
              print("object");
              Get.find<ChatManager>().updateForwardIndexesSelected(index, data);
              //setState(() {});
            },
            child: _chatBubble(
              data.msg,
              isfrom,
              data.time.split(' ')[1].split('.')[0],
              data.type,
              data.status,
              index,
              data.serverStatus,
              false,
              data.userRole,
            ),
          ),
        );
      },
    );
  }

  showSelectedViewOFChat(box) {
    _scrollTo(box.values.length);
    controller.highlight(box.values.length);
    return GetBuilder<ChatManager>(
      init: ChatManager(),
      initState: (_) {},
      builder: (_) {
        return ListView.builder(
          // controller: controller,
          controller: controller,
          itemCount: box.values.length,
          itemBuilder: (ctx, index) {
            // controller.scrollToIndex(index,
            //     preferPosition: AutoScrollPosition.begin);
            final data = box.values.toList()[index];
            var isfrom = false;
            if (data.fromPhone == widget.chatRoom.fromPhone) isfrom = true;
            bool checkSelected = false;
            ForwardClass isFound = Get.find<ChatManager>()
                .forwardIndexesSelected
                .firstWhere((element) => element.index == index, orElse: () {
              return ForwardClass(index: -1);
            });
            if (isFound.index != -1) {
              checkSelected = true;
            }
            return AutoScrollTag(
              key: ValueKey(index),
              controller: controller,
              index: index,
              highlightColor: Colors.black.withOpacity(0.1),
              child: InkWell(
                onTap: () {
                  if (checkSelected) {
                    Get.find<ChatManager>().updateForwardClear(isFound);
                  } else
                    Get.find<ChatManager>()
                        .updateForwardIndexesSelected(index, data);
                },
                child: _chatBubble(
                  data.msg,
                  isfrom,
                  data.time.split(' ')[1].split('.')[0],
                  data.type,
                  data.status,
                  index,
                  data.serverStatus,
                  checkSelected,
                  data.fromPhone,
                ),
              ),
            );
          },
        );
      },
    );
  }

  recordAudio() async {
    FlutterSoundRecorder value =
        await flutterSound.openAudioSession(audioFlags: 3);
    value.isStopped ? value.stopRecorder() : null;
    Directory dir = await ChatController().getDirpPath();

    String path = dir.path +
        "audio/audio" +
        DateTime.now()
            .toIso8601String()
            .split('.')[0]
            .split('T')[1]
            .toString()
            .replaceAll(":", "") +
        ".mp3";

    print("Given Path =>? $path");

    value.startRecorder(toFile: path);
    setState(() {
      isPlaying = true;
    });
  }

  getPatientCCDIFAllowing(context) async {
    return GestureDetector(
      onVerticalDragUpdate: (detail) {
        print(detail.delta.dy);
        print(h);
        if (detail.delta.dy.toString().contains('-')) {
          if (h != 50) {
            h -= 3;
          }
        } else if (h < (MediaQuery.of(context).size.height - 200)) {
          h += 3;
        }
        Get.find<ChatManager>().updateHBox(h);
        //setState(() {});
      },
      child: GetBuilder<ChatManager>(
        init: ChatManager(),
        initState: (_) {},
        builder: (_) {
          return Container(
            height: _.boxH,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: XmlFile(
                  number: widget.chatRoom.toPhone,
                )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  stopRec() async {
    path = await flutterSound.stopRecorder();
    flutterSound.closeAudioSession().then((value) {});
    setState(() {
      isPlaying = false;
      isAudioSending = true;
    });
    GroupMsg().GroupchatSender(
      widget.name,
      widget.chatRoom.toPhone,
      path,
      'audio',
      0,
      dbName,
      widget.img,
    );

    setState(() {
      isAudioSending = false;
    });
  }

  @override
  void dispose() {
    flutterSound;
    atDispose();
    super.dispose();
  }

  atDispose() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("gid");
  }

  saveRecording() async {
    print("Stop");
    Get.find<ChatManager>().updateisPlaying(false);

    //await Record.stop();
    try {
      await flutterSound.closeAudioSession();
      await flutterSound.stopRecorder();
      // String savepath = await flutterSound.stopRecorder();
      //await _flutterRecord.stopRecorder();
      // await flutterSound.closeAudioSession();
      // print(savepath);
      // RecordMp3.instance.stop();
      // Get.find<ChatController>().sendMSG(
      //     Get.find<ChatController>().currNumber.value,
      //     "name",
      //     widget.chatRoom.toPhone,
      //     File(path),
      //     "audio",
      //     DateTime.now(),
      //     0,
      //     dbName);
    } catch (e) {
      print(e.toString());
    }
  }

  //
  openRecorder() async {
    print(DateTime.now().toIso8601String());
    print("Audio");
    try {
      if (await Permission.microphone.request().isGranted) {
        Get.find<ChatManager>().updateisPlaying(true);
        //print(await Record.hasPermission());
        folder_path = await ChatController().getDirpPath();
        folder_path = await getExternalStorageDirectory();

        String t = DateTime.now().toIso8601String().split('.')[0];
        path = "${folder_path.path}/audio/$t.aac";
        print(path);
        Get.find<ChatManager>().updateisPlaying(false);
        await flutterSound.openAudioSession().then((value) async {
          value.startRecorder(toFile: null);
        });
        //path = await _flutterRecord.startRecorder(path: 'test', maxVolume: 7.0);

        print(path);
      }
    } catch (e) {
      // await flutterSound.startRecorder();
      await flutterSound.closeAudioSession();
      await flutterSound.stopRecorder();
      Get.find<ChatManager>().updateisPlaying(false);
      print(e.toString());
    }
    // RecordMp3.instance.start(path, (RecordErrorType type) {
    //   // record fail callback
    //   type.printError();
    // });
  }

  pickFile(src) async {
    var permitted = await Permission.camera.request().isGranted;
    if (!permitted) return;
    permitted = await Permission.storage.request().isGranted;
    if (!permitted) return;
    final pickedFile = await ImagePicker().getImage(source: src);

    setState(() {
      if (pickedFile != null) {
        File _image;
        _image = File(pickedFile.path);
        Get.to(VideoImageViewer(
          file: _image,
          roomList: widget.chatRoom,
          name: widget.name,
          dbName: dbName,
          index: 0,
          img: widget.img,
        ));
      } else {
        print('No image selected.');
      }
    });
  }

  _chatBubble(message, isme, time, type, status, index, serverStatus,
      checkSelected, fromNumber) {
    bool fromMe = isme;
    Alignment alignment = fromMe ? Alignment.topRight : Alignment.topLeft;
    Alignment chatArrowAlignment =
        fromMe ? Alignment.topRight : Alignment.topLeft;
    TextStyle textStyle = TextStyle(
      fontSize: 16.0,
      color: fromMe ? Colors.black : Colors.black,
    );
    Color chatBgColor = fromMe ? Colors.blue[200] : Colors.black12;
    EdgeInsets edgeInsets = fromMe
        ? EdgeInsets.fromLTRB(5, 5, 15, 5)
        : EdgeInsets.fromLTRB(15, 5, 5, 5);
    EdgeInsets margins = fromMe
        ? EdgeInsets.fromLTRB(80, 5, 10, 5)
        : EdgeInsets.fromLTRB(10, 5, 80, 5);

    bool isFailed = false;
    if (status == 'failed') {
      isFailed = true;
      time += '  ' + status;
    }
    // bool isDownloading = false;
    //print("Image ====== > ${message}");
//
    return Container(
      color: checkSelected ? Colors.blue : Colors.white,
      margin: margins,
      child: Align(
        alignment: alignment,
        child: Column(
          children: <Widget>[
            CustomPaint(
              painter: ChatBubble(
                color: chatBgColor,
                alignment: chatArrowAlignment,
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    isme
                        ? Container(
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              fromNumber,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                    Padding(
                      padding: edgeInsets,
                      child: type == "text"
                          ? Text(
                              '$message',
                              style: textStyle,
                            )
                          : (status == "downloaded" || status == "failed") &&
                                  type == 'image'
                              ? Container(
                                  height: 200,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          print("Viewer");
                                          Get.to(PhotoViewer(
                                            file: File(message),
                                          ));
                                        },
                                        child: Image.file(
                                          File(message),
                                          fit: BoxFit.fill,
                                          width: 300,
                                        ),
                                      ),
                                      serverStatus == 'u'
                                          ? Align(
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator())
                                          : Container(),
                                    ],
                                  ),
                                )
                              : status == 'notdownload' && type == 'image'
                                  ? Container(
                                      height: 200,
                                      width: 100,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.network(
                                            FILES_IMG + "blur.jpg",
                                            height: 200,
                                            fit: BoxFit.fill,
                                          ),
                                          serverStatus == 'd'
                                              ? Align(
                                                  alignment: Alignment.center,
                                                  child: InkWell(
                                                      onTap: () async {
                                                        print("object");
                                                        await ChatManager()
                                                            .downloadFiles(
                                                                message,
                                                                index,
                                                                type,
                                                                dbName,
                                                                widget.chatRoom
                                                                    .fromPhone);
                                                      },
                                                      child:
                                                          CircularProgressIndicator()))
                                              : serverStatus == 'f'
                                                  ? Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: CircleAvatar(
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            await ChatManager()
                                                                .downloadFiles(
                                                                    message,
                                                                    index,
                                                                    type,
                                                                    dbName,
                                                                    widget
                                                                        .chatRoom
                                                                        .fromPhone);
                                                            print("Download");
                                                          },
                                                          icon: Obx(() {
                                                            final con = Get.find<
                                                                ChatManager>();
                                                            return !con
                                                                    .isDownloading
                                                                    .value
                                                                ? Icon(
                                                                    Icons
                                                                        .file_download,
                                                                    color: Colors
                                                                        .red,
                                                                  )
                                                                : CircularProgressIndicator(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .amber,
                                                                  );
                                                          }),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                        ],
                                      ),
                                    )

                                  //end

                                  : status == 'notdownload' && type == 'audio'
                                      ? Stack(
                                          children: [
                                            new AudioPlayerView(
                                              path: message,
                                            ),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              alignment: Alignment.center,
                                              color: Colors.white,
                                              child: IconButton(
                                                onPressed: () async {
                                                  await ChatManager()
                                                      .downloadFiles(
                                                          message,
                                                          index,
                                                          "audio",
                                                          dbName,
                                                          widget.chatRoom
                                                              .fromPhone);
                                                  print("Download");
                                                },
                                                icon: Icon(
                                                  Icons.file_download,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                            serverStatus == 'd'
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child:
                                                        CircularProgressIndicator())
                                                : serverStatus == 'f'
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: CircleAvatar(
                                                          child: IconButton(
                                                            onPressed:
                                                                () async {
                                                              await ChatManager()
                                                                  .downloadFiles(
                                                                      message,
                                                                      index,
                                                                      type,
                                                                      dbName,
                                                                      widget
                                                                          .chatRoom
                                                                          .fromPhone);
                                                              print("Download");
                                                            },
                                                            icon: Obx(() {
                                                              final con = Get.find<
                                                                  ChatManager>();
                                                              return !con
                                                                      .isDownloading
                                                                      .value
                                                                  ? Icon(
                                                                      Icons
                                                                          .file_download,
                                                                      color: Colors
                                                                          .red,
                                                                    )
                                                                  : CircularProgressIndicator(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .amber,
                                                                    );
                                                            }),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                          ],
                                        )
                                      : new AudioPlayerView(
                                          path: message,
                                        ),
                    ),
                    isFailed
                        ? Text(
                            '$time',
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            '$time ',
                            style: TextStyle(color: Colors.black),
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
