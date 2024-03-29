import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:fyp_secure_com/CustomsWidget/chat_bubble.dart';
import 'package:fyp_secure_com/chats/audio_player.dart';
import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
import 'package:fyp_secure_com/chats/form_view.dart';
import 'package:fyp_secure_com/chats/photo_viewer.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/hiveBox/chat_room.dart';
import 'package:fyp_secure_com/hiveBox/forward_class.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'video_image_viewer.dart';
//import 'package:http/http.dart' as http;

import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
// Import package

class ChatListPage extends StatefulWidget {
  final ChatRoom chatRoom;
  final RoomList roomList;
  final name;
  final int index;

  const ChatListPage(
      {Key key, this.chatRoom, this.name, this.index, this.roomList})
      : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  String dbName = "";
  //FlutterRecord _flutterRecord;

  //AutoScrollController controller;

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
  Directory folder_path = Directory("");

  String path;
  bool isAtBottom = false;

  double xmlH = 100;
  bool isCcdAllowForPatient = false;

  FlutterSoundRecorder value;

  //AudioCache cache = AudioCache();
  atStartCheckPatientAllowing() async {
//    var res = http.post(Uri.parse(APIHOST + "checkPatientCCdAllow.php"));
  }

  var medData;
  bool isProcess = true;

  init() async {
    try {
      isProcess = true;
      Get.find<ChatManager>().updateCurrentChatOPen(widget.chatRoom.toPhone);
      value = FlutterSoundRecorder();
      SharedPreferences pref = await SharedPreferences.getInstance();
      role = pref.get('role');
      dbName =
          '${Get.find<ChatController>().currNumber.value}_${widget.chatRoom.toPhone}';

      await Hive.openBox<ChatRoom>(dbName);
      print(dbName);

      Box<ChatRoom> box = Hive.box<ChatRoom>(dbName);
      Get.find<ChatManager>().assignChatList(box.values.toList());

      isCcdAllowForPatient = pref.getString("isCcdAllow") == null ||
              pref.getString("isCcdAllow") == '0'
          ? false
          : true;

      medData = await ChatManager()
          .getFormView(widget.chatRoom.toPhone, LoginController.number);
    } catch (e) {}

    isProcess = false;
    print(isProcess);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // _flutterRecord = FlutterRecord();
    init();
  }

  double h = 50;

  scrollToBottom() {
    try {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 0),
      color: Colors.white,
      child: Column(
        children: [
          role == 'Doctor'
              ? GestureDetector(
                  // onVerticalDragUpdate: (detail) {
                  //   print(detail.delta.dy);
                  //   print(h);
                  //   if (detail.delta.dy.toString().contains('-')) {
                  //     if (h != 50) {
                  //       h -= 3;
                  //     }
                  //   } else if (h < (MediaQuery.of(context).size.height - 200)) {
                  //     h += 3;
                  //   }
                  //   Get.find<ChatManager>().updateHBox(h);
                  // },
                  child: GetBuilder<ChatManager>(
                    init: ChatManager(),
                    initState: (_) {},
                    builder: (_) {
                      return Container(
                        height: 100, // _.boxH,
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                child: FormView(
                              pnumber: widget.chatRoom.toPhone,
                              docNumber: LoginController.number,
                              data: medData,
                            )),
                            Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            // Expanded(
                            //     child: XmlFile(
                            //   number: widget.chatRoom.toPhone,
                            // )),
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: Icon(
                            //     Icons.menu,
                            //     color: Colors.white,
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : isCcdAllowForPatient
                  ? Text("data")
                  : Container(),
          isProcess
              ? Flexible(flex: 1, child: CircularProgressIndicator())
              : Flexible(
                  flex: 1,
                  child: ValueListenableBuilder(
                      valueListenable: Hive.box<ChatRoom>(dbName).listenable(),
                      builder: (context, Box<ChatRoom> box, _) {
                        return Center(
                          child: GetBuilder<ChatManager>(
                            init: ChatManager(),
                            initState: (_) {},
                            builder: (_) {
                              // if (_.isNewChatMessage) {

                              //   _.removeNewMessageIndicator();
                              // }
                              if (_.individualChatList.length == 0)
                                return Center(
                                  child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 30),
                                      child: Text(
                                        "End-To-End Encrpted Chat",
                                        style: CustomStyles.foreclr.copyWith(
                                            color: Colors.blue, fontSize: 15),
                                      )),
                                );
                              else
                                return showChatDetails(_.individualChatList);
                            },
                          ),
                        );
                      }),
                ),
          //bottom bar
          GetBuilder<ChatManager>(
            init: ChatManager(),
            initState: (_) {},
            builder: (_) {
              return _.forwardIndexesSelected.length == 0
                  ? Container(
                      decoration: BoxDecoration(color: Colors.white),
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 3),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                      width: size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              child: Container(
                            height: 50,
                            child: TextField(
                              onTap: () => scrollToBottom(),
                              controller: message,
                              keyboardAppearance: Brightness.dark,
                              onSubmitted: (v) {},
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
                                              Icons.photo,
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
                                              size: 30,
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
                                      try {
                                        // var conver = ChatRoom(
                                        //   fromPhone: Get.find<ChatController>()
                                        //       .currNumber
                                        //       .value,
                                        //   toPhone: widget.chatRoom.toPhone,
                                        //   time: DateTime.now().toString(),
                                        //   msg: message.text,
                                        //   type: "text",
                                        //   status: 'send',
                                        //   serverStatus: 'u',
                                        //   isGroup: false,
                                        //   userRole: "",
                                        // );
                                        // Get.find<ChatManager>()
                                        //     .addNewChatInList(conver);
                                        // //  scrollToBottom();
                                        ChatController().chatSender(
                                            widget.name,
                                            widget.chatRoom.toPhone,
                                            message.text,
                                            'text',
                                            0,
                                            dbName,
                                            widget.roomList.pic,
                                            widget.roomList.userRole);
                                        message.clear();
                                      } catch (e) {}

                                      con.updateTyped(false);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.send_rounded,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  );
                          }),
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
  }

  //  if (box.values.isBlank) {
  //                         return Center(
  //                           child: Container(
  //                               padding: EdgeInsets.symmetric(vertical: 30),
  //                               child: Text(
  //                                 "End-To-End Encrpted Chat",
  //                                 style: CustomStyles.foreclr.copyWith(
  //                                     color: Colors.blue, fontSize: 15),
  //                               )),
  //                         );
  //                       }
  //                       // print("...---" +
  //                       //     _.forwardIndexesSelected.length.toString());
  //                       return _.forwardIndexesSelected.length == 0
  //                           ? showChatDetails(box)
  //                           : showSelectedViewOFChat(box);

  Widget showChatDetails(List<ChatRoom> lst) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: lst.length + 1,
      itemBuilder: (ctx, index) {
        if (index == lst.length) {
          scrollToBottom();
          return Container(
            height: 70,
          );
        } else {
          final data = lst[index];
          // Get.find<ChatManager>().maxTime.value.split(" ")[0] ==
          //         data.time.split(" ")[0]
          //     ? null
          //     : Get.find<ChatManager>().updateMaxTime(data.time);
          var isfrom = false;
          if (data.fromPhone == widget.chatRoom.fromPhone) isfrom = true;
          return InkWell(
            onLongPress: () {
              print("Delete Multi");
              // Get.find<ChatManager>().updateForwardIndexesSelected(index, data);
              //setState(() {});

              /*
Obx(
                    () => Get.find<ChatManager>().maxTime.value.split(" ")[0] ==
                            data.time.split(" ")[0]
                        ? Container()
                        : Text(data.time.split(" ")[0]),
                  ),
                  index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data.time.split(" ")[0]),
                        )
                      : Container(),
                */
            },
            child: ChatBubbleView(
              message: data.msg,
              isme: isfrom,
              time: data.time.split(' ')[1].split('.')[0],
              type: data.type,
              status: data.status,
              index: index,
              serverStatus: data.serverStatus,
              checkSelected: false,
              dbName: dbName,
              chatRoom: widget.chatRoom,
            ),
          );
        }
      },
    );
  }

  showSelectedViewOFChat(box) {
    return GetBuilder<ChatManager>(
      init: ChatManager(),
      initState: (_) {},
      builder: (_) {
        return ListView.builder(
          controller: _scrollController,
          itemCount: box.values.length,
          itemBuilder: (ctx, index) {
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
            return InkWell(
              onTap: () {
                if (checkSelected) {
                  Get.find<ChatManager>().updateForwardClear(isFound);
                } else
                  Get.find<ChatManager>()
                      .updateForwardIndexesSelected(index, data);
              },
              child: ChatBubbleView(
                message: data.msg,
                isme: isfrom,
                time: data.time.split(' ')[1].split('.')[0],
                type: data.type,
                status: data.status,
                index: index,
                serverStatus: data.serverStatus,
                checkSelected: checkSelected,
                dbName: dbName,
                chatRoom: widget.chatRoom,
              ),
            );
          },
        );
      },
    );
  }

  recordAudio() async {
    //  value.isStopped ? value.stopRecorder() : null;
    Directory dir = await ChatController().getDirpPath();

    path = dir.path +
        "audio/audio" +
        DateTime.now()
            .toIso8601String()
            .split('.')[0]
            .split('T')[1]
            .toString()
            .replaceAll(":", "") +
        ".mp4";

    print("Given Path =>? $path");

    // await value.startRecorder(
    //     toFile: path,
    //     codec: Codec.aacMP4,
    //     numChannels: 3,
    //     audioSource: AudioSource.microphone);

    isPlaying = true;
    setState(() {});
    await value.openAudioSession().then((value) async {
      await value.startRecorder(
          toFile: path,
          codec: Codec.aacMP4,
          audioSource: AudioSource.microphone);
    });
  }

  stopRec() async {
    await value.stopRecorder();

    setState(() {
      isPlaying = false;
      isAudioSending = true;
    });
    ChatController().chatSender(widget.name, widget.chatRoom.toPhone, path,
        'audio', 0, dbName, widget.roomList.pic, widget.roomList.userRole);

    setState(() {
      isAudioSending = false;
    });
  }

  @override
  void dispose() {
    // flutterSound.closeAudioSession().then((value) {});

    Get.find<ChatManager>().updateCurrentChatOPen("");
    value.closeAudioSession().then((value) {});

    super.dispose();
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
          details: widget.roomList,
        ));
      } else {
        print('No image selected.');
      }
    });
  }

  // _chatBubble(
  //     message, isme, time, type, status, index, serverStatus, checkSelected) {
  //   //print("Image ====== > ${message}");

  //   return Container(
  //     color: checkSelected ? Colors.blue : Colors.white,
  //     margin: margins,
  //     child: Align(
  //       alignment: alignment,
  //       child: Column(
  //         children: <Widget>[
  //           CustomPaint(
  //             painter: ChatBubble(
  //               color: chatBgColor,
  //               alignment: chatArrowAlignment,
  //             ),
  //             child: Container(
  //               margin: EdgeInsets.only(right: 7, left: 7, bottom: 2, top: 3),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: edgeInsets,
  //                     child: type == "text"
  //                         ? Text(
  //                             '$message',
  //                             style: textStyle,
  //                           )
  //                         : (status == "downloaded" || status == "failed") &&
  //                                 type == 'image'
  //                             ? Container(
  //                                 height: 200,
  //                                 child: Stack(
  //                                   alignment: Alignment.center,
  //                                   children: [
  //                                     GestureDetector(
  //                                       onTap: () {
  //                                         print("Viewer");
  //                                         Get.to(PhotoViewer(
  //                                           file: File(message),
  //                                         ));
  //                                       },
  //                                       child: Image.file(
  //                                         File(message),
  //                                         fit: BoxFit.fill,
  //                                         width: 300,
  //                                       ),
  //                                     ),
  //                                     serverStatus == 'u'
  //                                         ? Align(
  //                                             alignment: Alignment.center,
  //                                             child:
  //                                                 CircularProgressIndicator())
  //                                         : Container(),
  //                                   ],
  //                                 ),
  //                               )
  //                             : status == 'notdownload' && type == 'image'
  //                                 ? Container(
  //                                     height: 200,
  //                                     width: 100,
  //                                     child: Stack(
  //                                       alignment: Alignment.center,
  //                                       children: [
  //                                         Image.network(
  //                                           FILES_IMG + "blur.jpg",
  //                                           height: 200,
  //                                           fit: BoxFit.fill,
  //                                         ),
  //                                         serverStatus == 'd'
  //                                             ? Align(
  //                                                 alignment: Alignment.center,
  //                                                 child: InkWell(
  //                                                   onTap: () async {
  //                                                     print("object");
  //                                                     await ChatManager()
  //                                                         .downloadFiles(
  //                                                       message,
  //                                                       index,
  //                                                       type,
  //                                                       dbName,
  //                                                       widget.chatRoom.toPhone,
  //                                                     );
  //                                                     setState(() {});
  //                                                   },
  //                                                   child:
  //                                                       CircularProgressIndicator(),
  //                                                 ),
  //                                               )
  //                                             : serverStatus == 'f'
  //                                                 ? Align(
  //                                                     alignment:
  //                                                         Alignment.center,
  //                                                     child: CircleAvatar(
  //                                                       child: IconButton(
  //                                                         onPressed: () async {
  //                                                           await ChatManager()
  //                                                               .downloadFiles(
  //                                                             message,
  //                                                             index,
  //                                                             type,
  //                                                             dbName,
  //                                                             widget.chatRoom
  //                                                                 .toPhone,
  //                                                           );
  //                                                           print("Download");
  //                                                           setState(() {});
  //                                                         },
  //                                                         icon: GetBuilder<
  //                                                             ChatManager>(
  //                                                           init: ChatManager(),
  //                                                           initState: (_) {},
  //                                                           builder: (con) {
  //                                                             return !con
  //                                                                     .isDownloading
  //                                                                 ? Icon(
  //                                                                     Icons
  //                                                                         .file_download,
  //                                                                     color: Colors
  //                                                                         .red,
  //                                                                   )
  //                                                                 : CircularProgressIndicator(
  //                                                                     backgroundColor:
  //                                                                         Colors
  //                                                                             .amber,
  //                                                                   );
  //                                                           },
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   )
  //                                                 : Container(),
  //                                       ],
  //                                     ),
  //                                   )

  //                                 //end

  //                                 : status == 'notdownload' && type == 'audio'
  //                                     ? GetBuilder(
  //                                         init: ChatManager(),
  //                                         initState: (_) {},
  //                                         builder: (ChatManager con) {
  //                                           return Stack(
  //                                             children: [
  //                                               new AudioPlayerView(
  //                                                 path: message,
  //                                               ),
  //                                               Container(
  //                                                 height: 50,
  //                                                 width: 50,
  //                                                 alignment: Alignment.center,
  //                                                 color: Colors.white,
  //                                                 child: IconButton(
  //                                                   onPressed: () async {
  //                                                     await ChatManager()
  //                                                         .downloadFiles(
  //                                                       message,
  //                                                       index,
  //                                                       "audio",
  //                                                       dbName,
  //                                                       widget.chatRoom.toPhone,
  //                                                     );
  //                                                     print("Download");
  //                                                     setState(() {});
  //                                                   },
  //                                                   icon: Icon(
  //                                                     Icons.file_download,
  //                                                     color: Colors.blue,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               serverStatus == 'd'
  //                                                   ? Align(
  //                                                       alignment:
  //                                                           Alignment.topLeft,
  //                                                       child:
  //                                                           CircularProgressIndicator())
  //                                                   : serverStatus == 'f'
  //                                                       ? Align(
  //                                                           alignment: Alignment
  //                                                               .topLeft,
  //                                                           child: CircleAvatar(
  //                                                             child: IconButton(
  //                                                               onPressed:
  //                                                                   () async {
  //                                                                 await ChatManager()
  //                                                                     .downloadFiles(
  //                                                                   message,
  //                                                                   index,
  //                                                                   type,
  //                                                                   dbName,
  //                                                                   widget
  //                                                                       .chatRoom
  //                                                                       .toPhone,
  //                                                                 );
  //                                                                 print(
  //                                                                     "Download");
  //                                                                 setState(
  //                                                                     () {});
  //                                                               },
  //                                                               icon: GetBuilder<
  //                                                                   ChatManager>(
  //                                                                 init:
  //                                                                     ChatManager(),
  //                                                                 initState:
  //                                                                     (_) {},
  //                                                                 builder:
  //                                                                     (con) {
  //                                                                   return !con
  //                                                                           .isDownloading
  //                                                                       ? Icon(
  //                                                                           Icons.file_download,
  //                                                                           color:
  //                                                                               Colors.red,
  //                                                                         )
  //                                                                       : CircularProgressIndicator(
  //                                                                           backgroundColor:
  //                                                                               Colors.amber,
  //                                                                         );
  //                                                                 },
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         )
  //                                                       : Container(),
  //                                             ],
  //                                           );
  //                                         })
  //                                     : new AudioPlayerView(
  //                                         path: message,
  //                                       ),
  //                   ),
  //                   isFailed
  //                       ? Text(
  //                           ' $time'.split(":")[0] + '$time'.split(":")[1],
  //                           style: TextStyle(color: Colors.red, fontSize: 12),
  //                         )
  //                       : Text(
  //                           '$time'.split(":")[0] +
  //                               ":" +
  //                               '$time'.split(":")[1] +
  //                               "  ",
  //                           style:
  //                               TextStyle(color: Colors.black38, fontSize: 12),
  //                         ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class ChatBubbleView extends StatefulWidget {
  final message,
      isme,
      time,
      type,
      status,
      index,
      serverStatus,
      checkSelected,
      dbName,
      chatRoom;

  ChatBubbleView({
    Key key,
    this.message,
    this.isme,
    this.time,
    this.type,
    this.status,
    this.index,
    this.serverStatus,
    this.checkSelected,
    this.dbName,
    this.chatRoom,
  }) : super(key: key);

  @override
  State<ChatBubbleView> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubbleView> {
  final isProcessing = false;
  @override
  Widget build(BuildContext context) {
    bool fromMe = widget.isme;
    Alignment alignment = fromMe ? Alignment.topRight : Alignment.topLeft;
    Alignment chatArrowAlignment =
        fromMe ? Alignment.topRight : Alignment.topLeft;
    TextStyle textStyle = TextStyle(
      fontSize: 15.0,
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
    //var time;
    if (widget.status == 'failed') {
      isFailed = true;
      // time += '  ' + widget.status;
    }
    return Container(
      color: widget.checkSelected ? Colors.blue : Colors.white,
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
                margin: EdgeInsets.only(right: 7, left: 7, bottom: 2, top: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: edgeInsets,
                      child: widget.type == "text"
                          ? Text(
                              '${widget.message}',
                              style: textStyle,
                            )
                          : (widget.status == "downloaded" ||
                                      widget.status == "failed") &&
                                  widget.type == 'image'
                              ? Container(
                                  height: 200,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          print("Viewer");
                                          Get.to(PhotoViewer(
                                            file: File(widget.message),
                                          ));
                                        },
                                        child: Image.file(
                                          File(widget.message),
                                          fit: BoxFit.fill,
                                          width: 300,
                                        ),
                                      ),
                                      widget.serverStatus == 'u'
                                          ? Align(
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator())
                                          : Container(),
                                    ],
                                  ),
                                )
                              : widget.status == 'notdownload' &&
                                      widget.type == 'image'
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
                                          widget.serverStatus == 'd'
                                              ? Align(
                                                  alignment: Alignment.center,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      print("object");

                                                      await ChatManager()
                                                          .downloadFiles(
                                                        widget.message,
                                                        widget.index,
                                                        widget.type,
                                                        widget.dbName,
                                                        widget.chatRoom.toPhone,
                                                      );
                                                    },
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                              : widget.serverStatus == 'f'
                                                  ? Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: CircleAvatar(
                                                        child: IconButton(
                                                          onPressed: () async {
                                                            await ChatManager()
                                                                .downloadFiles(
                                                              widget.message,
                                                              widget.index,
                                                              widget.type,
                                                              widget.dbName,
                                                              widget.chatRoom
                                                                  .toPhone,
                                                            );
                                                            print("Download");
                                                            setState(() {});
                                                          },
                                                          icon: GetBuilder<
                                                              ChatManager>(
                                                            init: ChatManager(),
                                                            initState: (_) {},
                                                            builder: (con) {
                                                              return !con
                                                                      .isDownloading
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
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                        ],
                                      ),
                                    )

                                  //end

                                  : widget.status == 'notdownload' &&
                                          widget.type == 'audio'
                                      ? GetBuilder(
                                          init: ChatManager(),
                                          initState: (_) {},
                                          builder: (ChatManager con) {
                                            return Stack(
                                              children: [
                                                new AudioPlayerView(
                                                  path: widget.message,
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
                                                        widget.message,
                                                        widget.index,
                                                        "audio",
                                                        widget.dbName,
                                                        widget.chatRoom.toPhone,
                                                      );
                                                      print("Download");
                                                      setState(() {});
                                                    },
                                                    icon: Icon(
                                                      Icons.file_download,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                widget.serverStatus == 'd'
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child:
                                                            CircularProgressIndicator())
                                                    : widget.serverStatus == 'f'
                                                        ? Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: CircleAvatar(
                                                              child: IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  await ChatManager()
                                                                      .downloadFiles(
                                                                    widget
                                                                        .message,
                                                                    widget
                                                                        .index,
                                                                    widget.type,
                                                                    widget
                                                                        .dbName,
                                                                    widget
                                                                        .chatRoom
                                                                        .toPhone,
                                                                  );
                                                                  print(
                                                                      "Download");
                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon: GetBuilder<
                                                                    ChatManager>(
                                                                  init:
                                                                      ChatManager(),
                                                                  initState:
                                                                      (_) {},
                                                                  builder:
                                                                      (con) {
                                                                    return !con
                                                                            .isDownloading
                                                                        ? Icon(
                                                                            Icons.file_download,
                                                                            color:
                                                                                Colors.red,
                                                                          )
                                                                        : CircularProgressIndicator(
                                                                            backgroundColor:
                                                                                Colors.amber,
                                                                          );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                              ],
                                            );
                                          })
                                      : new AudioPlayerView(
                                          path: widget.message,
                                        ),
                    ),
                    isFailed
                        ? Text(
                            ' ${widget.time}'.split(":")[0] +
                                '${widget.time}'.split(":")[1],
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : Text(
                            '${widget.time}'.split(":")[0] +
                                ":" +
                                '${widget.time}'.split(":")[1] +
                                "  ",
                            style:
                                TextStyle(color: Colors.black38, fontSize: 12),
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
