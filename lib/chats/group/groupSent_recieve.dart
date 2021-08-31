import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/hiveBox/chat_room.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class GroupMsg {
  // in used
  uploading_all_MSG(file, from, to, type, name, time, dbname, pic) async {
    Get.find<ChatController>().isSending(false);
    Encrypted encrypted;
    //print(from);
    saveROOM(to, file, time, name, pic);
    File fileAfterSavingLocallay;
    if (type != 'text') {
      if (type == "audio") {
        fileAfterSavingLocallay = File(file);
        //fileAfterSavingLocallay = await saveFilesOFChat(fil, type);
        saveConversation(from, to, file, name, type, time);
      } else {
        fileAfterSavingLocallay =
            await Get.find<ChatController>().saveFilesOFChat(file, type);
        saveConversation(
            from, to, fileAfterSavingLocallay.path, name, type, time);

        fileAfterSavingLocallay = file;
      }
    } else {
      //if is text
      final iv = IV.fromLength(16);
      String keystr = from;
      for (int i = from.toString().length; i < 16; ++i) {
        keystr += '1';
      }
      print(keystr.length);
      final key = Key.fromUtf8("$keystr");
      final encrypter = Encrypter(AES(key));

      encrypted = encrypter.encrypt(file, iv: iv);
      // final decrypted = encrypter.decrypt(encrypted, iv: iv);
      saveConversation(from, to, file, name, type, time);
    }
    print("Enter ");
    Get.find<ChatController>().isSending(false);
    Get.find<SocketController>().checkConnected.value;
    if (1 > 0) {
      Get.find<ChatController>().uploading(true);
      var msg;
      String url = APIHOST + "group_chat.php";
      //uploaderBgTest(fileAfterSavingLocallay, url, from, to, type);
      //
      if (type == "image" || type == "audio") {
        List<int> btyes = fileAfterSavingLocallay.readAsBytesSync();
        List<int> crptedBtyes = btyes;
        for (int i = 0; i < btyes.length; ++i) {
          crptedBtyes[i] = btyes[i] + 100;
        }
        // File crypted = File(fileAfterSavingLocallay.path);
        Directory crypt = await Get.find<ChatController>().getDirpPath();
        print(fileAfterSavingLocallay.path.split('.'));
        print(fileAfterSavingLocallay.path.split('.').last);

        File newFile = File(type == "image"
            ? crypt.path +
                "temp." +
                fileAfterSavingLocallay.path.split('.').last
            : crypt.path + 'temp.mp3');
        print(newFile);
        await newFile.writeAsBytes(crptedBtyes);
        await uploadFIlesToServerInUsed(newFile, url, from, to, type);
        newFile.deleteSync(recursive: true);
        // initPlatformState(fileAfterSavingLocallay, url, from, to, type);
        // BackgroundFetch.start().then((int status1) async {
        //   taskbgStart(true);
        //   print('[BackgroundFetch] start success: ' + status1.toString());

        //   int status = 1;
        //   await BackgroundFetch.status.asStream().listen((event) {
        //     print('[BackgroundFetch] status: $status');
        //   });

        //   if (status == 100) {
        //     taskbgStart(false);
        //   }
        // }).catchError((e) {
        //   print('[BackgroundFetch] start FAILURE: $e');
        //   taskbgStart(false);
        // });
      } else {
        var req = await http.post(Uri.parse(url), body: {
          'from': from,
          'to': to,
          'type': type,
          'time': '${DateTime.now()}',
          'msg': "${encrypted.base64}",
        });
        if (req.statusCode != 200) {
          int chatindex = Get.find<ChatController>().savechatindex.value;
          Get.find<ChatController>()
              .updateStatusOfChat("failed", chatindex, '${from}_$to');
          print("Server Error");

          print(req.body);

          Get.snackbar("Error", "Server Error");
        } else {
          print(req.body);
          msg = req.body;
        }
      }

      String emitData = "$from$seprateString$to";
      Get.find<SocketController>().socket.emit(EVENT_MSG, [emitData]);

      Get.find<ChatController>().uploading(false);
    } else
      Get.find<ChatController>().updateStatusOfChat(
          "failed", Get.find<ChatController>().savechatindex.value, dbname);
    // return msg;
    Get.find<ChatController>().uploading(false);
  }

  /// in use
  uploadFIlesToServerInUsed(
      fileAfterSavingLocallay, url, from, to, type) async {
    //bgProcessing(true);
    print("bgProcessing ==> " + fileAfterSavingLocallay.path);
    StreamView<List<int>> stream;
    int len;
    //String enc_path = EncryptData.encrypt_file(fileAfterSavingLocallay.path);
    //File file = File(enc_path);

    stream = http.ByteStream(
        DelegatingStream.typed(fileAfterSavingLocallay.openRead()));
    len = await fileAfterSavingLocallay.length();

    List filnamelsit = DateTime.now().toIso8601String().split(' ');
    String newFileName = '';
    filnamelsit.forEach((element) {
      newFileName += element.toString();
    });
    newFileName = newFileName.replaceAll('.', '');
    newFileName = newFileName.replaceAll(':', '');
    newFileName +=
        "." + fileAfterSavingLocallay.path.toString().split('.').last;
    print(newFileName);
    var req = http.MultipartRequest("POST", Uri.parse(url));
    var multi = new http.MultipartFile(
      "msg",
      stream,
      len,
      filename: newFileName,
    );
    req.files.add(multi);
    req.fields['from'] = from;
    req.fields['to'] = to;
    req.fields['type'] = type;
    req.fields['time'] = '${DateTime.now()}';
    var respose = await req.send();
    var statusCode;
    // respose.then((value) => statusCode = value.statusCode);
    if (respose.statusCode == 200) {
      //msg = respose.reasonPhrase.toUpperCase();
      await http.Response.fromStream(respose).then((value) async {
        print(value.body);
        int chatindex = Get.find<ChatController>().savechatindex.value;
        Get.find<ChatController>()
            .updateStatusOfServerCallingU_D("done", chatindex, '${from}_$to');
        // msg = value.body;
      });
    } else {
      //  msg = "Server Error";
      int chatindex = Get.find<ChatController>().savechatindex.value;
      Get.find<ChatController>()
          .updateStatusOfChat("failed", chatindex, '${from}_$to');

      Get.find<ChatController>()
          .updateStatusOfServerCallingU_D("failed", chatindex, '${from}_$to');
    }

    // file.delete(recursive: true);
    // bgProcessing(false);

    print("bgProcessing ==> " +
        Get.find<ChatController>().bgProcessing.value.toString());
  }

  ////
  Future GroupchatSender(name, tophone, msg, type, index, dbName, pic) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    tophone = pref.getString("gid");
    await uploading_all_MSG(msg, Get.find<ChatController>().currNumber.value,
        tophone, type, name, DateTime.now(), dbName, pic);
  }

  ///send
  saveROOM(to, lastmsg, time, name, pic) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String gid = pref.getString("gid");
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    Hive.openBox<RoomList>(mainDBNAme).then((value) {
      bool found = false;
      int index = -1;
      RoomList pre;

      for (int i = 0; i < value.values.length; ++i) {
        RoomList element = value.values.elementAt(i);
        if (element.phone == to) {
          index = i;
          found = true;
          pre = element;
        }
      }
      var roomData = RoomList(
        id: gid,
        lastMsg: "me: $lastmsg",
        lastMsgTime: "$time",
        name: name,
        phone: gid,
        isGroup: true,
        isPin: false,
        userRole: "",
        pic: pic,
        isArchive: false,
        // isArchive: found
        //     ? pre.isArchive == null
        //         ? false
        //         : pre.isArchive
        //     : false,
      );

      if (found == false) {
        value.add(roomData);
      }
      if (found) {
        value.putAt(index, roomData);
      }
    });
  }

  saveConversation(from, to, lastmsg, name, type, time) async {
    String dbName = from + '_' + to;

    int ind = 0;
    print("Saving Type");
    print(dbName);
    await Hive.openBox<ChatRoom>(dbName).then((value) {
      var conver = ChatRoom(
        fromPhone: from,
        toPhone: to,
        time: "$time",
        msg: lastmsg.toString(),
        type: type,
        status: type != 'text' ? 'downloaded' : 'send',
        serverStatus: 'u',
        isGroup: false,
        userRole: name,
      );
      value.add(conver);
      Get.find<ChatController>().savechatindex(value.values.length);
      print("Storing Index");
      print(Get.find<ChatController>().savechatindex.value);
    });
  }

  //recieved
  onrecieveSaveMesg(recData, decrypted) async {
    String dbName =
        '${Get.find<ChatController>().currNumber.value}_${recData['gid']}';
    print("On get => " + dbName);
    int id = 0;

    await Hive.openBox<ChatRoom>(dbName).then((value) {
      // List abc = value.values.toList();
      // abc.sort((a, b) => (int.parse(a.chatid).compareTo(int.parse(b.chatid))));
      // abc = abc.reversed;
      var conver = ChatRoom(
        fromPhone: recData['from_id'],
        toPhone: recData['gid'],
        time: recData['time'].toString(),
        msg: decrypted,
        type: recData['type'],
        status: recData['type'] != 'text' ? 'notdownload' : 'recieved',
        serverStatus: 'f',
        isGroup: true,
        userRole: recData['name'],
        chatid: recData['chatID'],
      );

      //ChatRoom lastRoom = value.values.last;
      //print("On get => ${conver.fromPhone}");
      value.add(conver);
      id = value.length;
      //if()
      //notify
      // if (!Platform.isWindows) sendnotify(conver.fromPhone, conver.msg, id);
    });
  }

  onRecievesaveROOM(recData, decrypted) async {
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    //print(mainDBNAme);
    await Hive.openBox<RoomList>(mainDBNAme).then((value) {
      bool found = false;
      // print(recData[1]);
      int index = -1;
      RoomList pre;

      for (int i = 0; i < value.values.length; ++i) {
        RoomList element = value.values.elementAt(i);
        if (element.phone == recData['gid'].toString()) {
          // print("ID ==> ${i}");
          index = i;
          found = true;
          pre = element;
        }
        // if (found) return;
      }

      var roomData = RoomList(
        id: recData['gid'],
        lastMsg: decrypted,
        lastMsgTime: recData['time'].toString(),
        name: '${recData['title']}',
        phone: '${recData['gid']}',
        isArchive: false,
        isGroup: true,
        isPin: false,
        userRole: "",
        pic: recData['pic'].toString(),

        // isArchive: found
        //     ? pre.isArchive == null
        //         ? false
        //         : pre.isArchive
        //     : false,
      );
      if (found == false) {
        value.add(roomData);
      }
      if (found) {
        value.putAt(index, roomData);
      }
    });
  }

  ///
  // called when user turn online
  getMsgFromServerOnPing(data) async {
    print("On GRoup");
    try {
      var recData = data.toString().split(seprateString);

      // print(recData[1]);
      if (true) {
        String url = APIHOST + 'get_group_chat.php';
        var response = await http.post(Uri.parse(url), body: {
          "to": Get.find<ChatController>().currNumber.value,
        });
        print("=====>  GROUP from server ${response.body}");
        if (response.statusCode == 200) {
          if (!response.body.toLowerCase().contains("failed") &&
              !response.body.toLowerCase().contains("Error")) {
            print(response.body);
            List recieveMSG = jsonDecode(response.body);
            recieveMSG.forEach((element) {
              print(element);
              String decrypted;
              if (element['type'] == 'text') {
                String keystr = element['from_id'];
                for (int i = element['from_id'].toString().length;
                    i < 16;
                    ++i) {
                  keystr += '1';
                }
                print(keystr.length);
                final key = Key.fromUtf8("$keystr");
                final iv = IV.fromLength(16);
                // final key = Key.fromUtf8("${element['fromid']}11111");
                final encrypter = Encrypter(AES(key));
                Encrypted encrypted = Encrypted.fromBase64(element['msg']);
                decrypted = encrypter.decrypt(encrypted, iv: iv);
              } else
                decrypted = element['msg'];
              onRecievesaveROOM(element, decrypted);
              onrecieveSaveMesg(element, decrypted);
            });
          }
        } else {
          Get.snackbar("Error", "No Internet");
        }
        // onRecievesaveROOM(recData, decrypted);
        //onrecieveSaveMesg(recData, decrypted);
      } else
        print("Other Chat");
    } catch (e) {}
  }

  ///end
  void recieveMSG() async {
    Get.find<SocketController>().socket.on(EVENT_MSG, (data) async {
      print("get");
      getMsgFromServerOnPing(data);
    });
  }

  ///
  getDataOnStartOfTheChat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Get.find<ChatController>().currNumber(pref.getString("number"));
    print("\At Start ===/ ${Get.find<ChatController>().currNumber.value}");
    String url = APIHOST + 'get_group_chat.php';

    var response = await http.post(Uri.parse(url), body: {
      "to": Get.find<ChatController>().currNumber.value,
    });
    print("=====> from server");
    // print(response.body);
    if (response.statusCode == 200) {
      if (!response.body.toLowerCase().contains("error") &&
          response.body.isNotEmpty) {
        print("Chat ");
        print(response.body);
        List recieveMSG = jsonDecode(response.body);
        recieveMSG.forEach((element) {
          print(element);

          String decrypted;
          if (element['type'] == 'text') {
            final iv = IV.fromLength(16);
            String keystr = '';
            for (int i = element['from_id'].toString().length; i < 16; ++i) {
              keystr += '1';
            }

            // final key = Key.fromUtf8("${from}");
            final key = Key.fromUtf8("${element['from_id']}$keystr");
            final encrypter = Encrypter(AES(key));
            Encrypted encrypted = Encrypted.fromBase64(element['msg']);
            decrypted = encrypter.decrypt(encrypted, iv: iv);
          } else
            decrypted = element['msg'];
          onRecievesaveROOM(element, decrypted);
          onrecieveSaveMesg(element, decrypted);
        });
      }
    } else {
      Get.snackbar("Error", "No Internet");
    }

    //SocketController().pingOnlineLIst();
  }

  ///get_group_chat.php
  ///
  ///
  getGroupCreationDataIfCreated() async {
    try {
      var res = await http.post(
        Uri.parse(APIHOST + getGroupsCreationData),
        body: {
          "to": Get.find<ChatController>().currNumber.value,
        },
      );

      if (res.statusCode == 200) {
        List groupData = jsonDecode(res.body);
        print("Groups");
        print(groupData);

        groupData.forEach((element) {
          addGroupInHive(element['id'], element['pic'], element['title'],
              element['created_date'], element['created_by']);
        });

        ///
      } else {}
    } catch (e) {
      print("Groups Data");
      print(e);
    }
  }

  addGroupInHive(gid, img, name, curDate, createdBY) async {
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    await Hive.openBox<RoomList>(mainDBNAme).then((value) {
      var roomData = RoomList(
        id: createdBY,
        lastMsg: "",
        lastMsgTime: curDate.toString(),
        name: name,
        phone: gid,
        isArchive: false,
        isGroup: true,
        isPin: false,
        userRole: "",
        pic: img,
      );
      RoomList found = value.values.firstWhere(
          (element) => element.phone == gid,
          orElse: () => RoomList(phone: ""));

      if (found.phone == "") value.add(roomData);
    });
  }

  ///
  ///
  ///
  ///SELECT groups.title , groups.pic , groups.id , msg ,
  ///type ,doctor.img, doctor.name FROM groupchat
  ///INNER JOIN groups ON groups.id = groupchat.gid
  ///INNER JOIN doctor ON groupchat.from_id = doctor.number
  ///INNER JOIN groupmember ON groupmember.number = doctor.number
  ///
}

///Work
// SELECT * FROM groups INNER JOIN groupchat ON groups.id = groupchat.gid WHERE groupchat.gid = 25

// SELECT * FROM grouphavemems INNER JOIN groupmember ON groupmember.id = grouphavemems.id WHERE groupmember.number = '03041234567'
