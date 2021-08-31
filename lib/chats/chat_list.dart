import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:fyp_secure_com/CustomsWidget/chat_bubble.dart';
import 'package:fyp_secure_com/chats/audio_player.dart';
import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
import 'package:fyp_secure_com/chats/form_view.dart';
import 'package:fyp_secure_com/chats/photo_viewer.dart';
import 'package:fyp_secure_com/chats/xml_file.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/loginController.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/commonAtStart/styles.dart';
import 'package:fyp_secure_com/doctor/controller/doctor_home_controller.dart';
import 'package:fyp_secure_com/hiveBox/chat_room.dart';
import 'package:fyp_secure_com/hiveBox/forward_class.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'video_image_viewer.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
// Import package

class ChatListPage extends StatefulWidget {
  final ChatRoom chatRoom;
  final name;

  const ChatListPage({Key key, this.chatRoom, this.name}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
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
  Directory folder_path = Directory("");

  String path;

  double xmlH = 100;
  bool isCcdAllowForPatient = false;

  FlutterSoundRecorder value;

  //AudioCache cache = AudioCache();
  atStartCheckPatientAllowing() async {
    var res = http.post(Uri.parse(APIHOST + "checkPatientCCdAllow.php"));
  }

  init() async {
    value = FlutterSoundRecorder();
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.get('role');
    dbName =
        '${Get.find<ChatController>().currNumber.value}_${widget.chatRoom.toPhone}';
    isCcdAllowForPatient = pref.getString("isCcdAllow") == null ||
            pref.getString("isCcdAllow") == '0'
        ? false
        : true;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
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
    dbName =
        '${Get.find<ChatController>().currNumber.value}_${widget.chatRoom.toPhone}';
//getPatientCCDIFAllowing
    //print("DBNAme => $dbName");

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
                            )),
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
          Flexible(
            flex: 1,
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
                                      ChatController().chatSender(
                                          widget.name,
                                          widget.chatRoom.toPhone,
                                          message.text,
                                          'text',
                                          0,
                                          dbName);
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

  Widget showChatDetails(box) {
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
                ),
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
    await value.stopRecorder();

    setState(() {
      isPlaying = false;
      isAudioSending = true;
    });
    ChatController().chatSender(
        widget.name, widget.chatRoom.toPhone, path, 'audio', 0, dbName);

    setState(() {
      isAudioSending = false;
    });
  }

  @override
  void dispose() {
    // flutterSound.closeAudioSession().then((value) {});

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
        ));
      } else {
        print('No image selected.');
      }
    });
  }

  _chatBubble(
      message, isme, time, type, status, index, serverStatus, checkSelected) {
    bool fromMe = isme;
    Alignment alignment = fromMe ? Alignment.topRight : Alignment.topLeft;
    Alignment chatArrowAlignment =
        fromMe ? Alignment.topRight : Alignment.topLeft;
    TextStyle textStyle = TextStyle(
      fontSize: 15.0,
      color: fromMe ? Colors.black : Colors.black,
    );
    Color chatBgColor = fromMe ? Colors.blue[200] : Colors.black12;
    EdgeInsets edgeInsets = fromMe
        ? EdgeInsets.fromLTRB(5, 5, 15, 2)
        : EdgeInsets.fromLTRB(15, 5, 5, 2);
    EdgeInsets margins = fromMe
        ? EdgeInsets.fromLTRB(80, 5, 10, 5)
        : EdgeInsets.fromLTRB(10, 5, 80, 5);

    bool isFailed = false;
    if (status == 'failed') {
      isFailed = true;
      time += '  ' + status;
    }
    bool isDownloading = false;
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
                margin: EdgeInsets.only(right: 4, left: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
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
                                                          widget
                                                              .chatRoom.toPhone,
                                                        );
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
                                                              widget.chatRoom
                                                                  .toPhone,
                                                            );
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
                                                    widget.chatRoom.toPhone,
                                                  );
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
                                                                widget.chatRoom
                                                                    .toPhone,
                                                              );
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
                            ' $time'.split(":")[0] + '$time'.split(":")[1],
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            '$time'.split(":")[0] +
                                ":" +
                                '$time'.split(":")[1] +
                                "  ",
                            style: TextStyle(color: Colors.black38),
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
