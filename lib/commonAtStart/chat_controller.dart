import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_secure_com/chats/chatDbmanger.dart/chat_manger.dart';
import 'package:fyp_secure_com/chats/group/groupSent_recieve.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/friend_list_handler/controller/friend_controller.dart';
import 'package:fyp_secure_com/hiveBox/chat_room.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/patient/model/friends_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'APIHelper.dart';

class ChatController extends GetxController {
  var currNumber = ''.obs;
  String number = "";
  var currName = ''.obs;
  var curImg = ''.obs;

  var bgProcessing = false.obs;

  var isTyped = false.obs;
  var uploading = false.obs;
  var isSending = false.obs;
  var savechatindex = 0.obs;
  var searchList = <RoomList>[];

  List<Contact> contactList = [];

  fetchCOntacts() async {
    contactList =
        (await ContactsService.getContacts(withThumbnails: false)).toList();
    contactList.forEach((cont) {
      FriendsModel found = Get.find<FriendController>().doctorLists.firstWhere(
          (element) => element.phone == cont.phones,
          orElse: () => FriendsModel("", "", "", "", false));
      if (found.name == "") contactList.remove(cont);
    });
    update();
  }

  updateSearchList(List<RoomList> lst) => searchList = lst;

  updateTyped(n) => isTyped(n);
  updateImg(n) => curImg(n);

  var msgID;

  updateCurrNumber(newNumber) => currNumber(newNumber);
  updateCurrName(newName) => currName(newName);

  ////
  Future chatSender(name, tophone, msg, type, index, dbName) async {
    await uploading_all_MSG(msg, Get.find<ChatController>().currNumber.value,
        tophone, type, name, DateTime.now(), dbName);
  }

  var taskbgStart = false.obs;
  /////////chat send
  //

  // in used
  uploading_all_MSG(file, from, to, type, name, time, dbname) async {
    Get.find<ChatController>().isSending(false);

    Encrypted encrypted;

    final iv = IV.fromLength(16);
    print(" ... " + from);
    String keystr = from;
    print(" ... " + from.toString().length.toString());
    int value = 1;
    for (int i = from.toString().length; i < 32; ++i) {
      if (value == 9) {
        value = 1;
      }
      value++;

      keystr = keystr + value.toString();
    }

    final key = Key.fromUtf8(keystr);
    print(keystr.length);
    final encrypter = Encrypter(AES(key));

    saveROOM(to, type == "text" ? file : "file", time, name);
    File fileAfterSavingLocallay = File("");
    if (type != 'text') {
      if (type == "audio") {
        fileAfterSavingLocallay = File(file);
        //fileAfterSavingLocallay = await saveFilesOFChat(fil, type);
        saveConversation(from, to, file, name, type, time);
      } else {
        fileAfterSavingLocallay = await saveFilesOFChat(file, type);
        saveConversation(
            from, to, fileAfterSavingLocallay.path, name, type, time);

        fileAfterSavingLocallay = file;
      }
    } else {
      //if is text
      print("TExt");
      encrypted = encrypter.encrypt(file, iv: iv);
      // final decrypted = encrypter.decrypt(encrypted, iv: iv);
      saveConversation(from, to, file, name, type, time);
    }
    print("Enter ");
    Get.find<ChatController>().isSending(false);
    Get.find<SocketController>().checkConnected.value;
    if (1 > 0) {
      uploading(true);
      var msg;
      String url = APIHOST + UPLOADCHAT;
      //uploaderBgTest(fileAfterSavingLocallay, url, from, to, type);
      //
      if (type == "image" || type == "audio") {
        List<int> btyes = fileAfterSavingLocallay.readAsBytesSync();
        List<int> crptedBtyes = btyes;

        encrypted = encrypter.encryptBytes(btyes, iv: iv);
        crptedBtyes = encrypted.bytes;

        // for (int i = 0; i < btyes.length; ++i) {
        //   if (i % 2 == 0) {
        //     encrypted = encrypter.encrypt(btyes[i].toString(), iv: iv);
        //     //// error here
        //     crptedBtyes[i] = encrypted.bytes.first;
        //   }
        // }
        // File crypted = File(fileAfterSavingLocallay.path);
        Directory crypt = await getDirpPath();
        print(fileAfterSavingLocallay.path.split('.'));
        print(fileAfterSavingLocallay.path.split('.').last);

        File newFile = File(type == "image"
            ? crypt.path +
                "temp." +
                fileAfterSavingLocallay.path.split('.').last
            : crypt.path + 'temp.mp4');
        print(newFile);
        await newFile.writeAsBytes(crptedBtyes);
        await uploadFIlesToServerInUsed(newFile, url, from, to, type);
        newFile.deleteSync(recursive: true);
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
          updateStatusOfChat("failed", chatindex, '${from}_$to');
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

      uploading(false);
    } else
      updateStatusOfChat(
          "failed", Get.find<ChatController>().savechatindex.value, dbname);
    // return msg;
    uploading(false);
  }

  /// in use
  uploadFIlesToServerInUsed(
      fileAfterSavingLocallay, url, from, to, type) async {
    // bgProcessing(true);
    print("bgProcessing  Start ==> " + fileAfterSavingLocallay.path);
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
        updateStatusOfServerCallingU_D("done", chatindex, '${from}_$to');
        // msg = value.body;
      });
    } else {
      //  msg = "Server Error";
      int chatindex = Get.find<ChatController>().savechatindex.value;
      updateStatusOfChat("failed", chatindex, '${from}_$to');

      updateStatusOfServerCallingU_D("failed", chatindex, '${from}_$to');
    }

    // file.delete(recursive: true);
    //bgProcessing(false);

    print("bgProcessing End  ==> " + bgProcessing.value.toString());
  }

  ///
  Future<Directory> getDirpPath() async {
    Directory chatpath = Directory("");
    if (await Permission.storage.request().isGranted) {
      var root = await getExternalStorageDirectory();
      //List files = await FileManager(root: root).walk().toList();

      Directory _appDocDirFolder = Directory('${root.path}/$folderName/');
      if (await _appDocDirFolder.exists()) {
        chatpath = _appDocDirFolder;
      } else {
        //if folder not exists create folder and then return its path
        final Directory _appDocDirNewFolder =
            await _appDocDirFolder.create(recursive: true);
        chatpath = _appDocDirNewFolder;
        _appDocDirFolder = Directory('${root.path}/$folderName/img');
        if (!await _appDocDirFolder.exists())
          await _appDocDirFolder.create(recursive: true);
        _appDocDirFolder = Directory('${root.path}/$folderName/audio');
        if (!await _appDocDirFolder.exists())
          await _appDocDirFolder.create(recursive: true);
      }
    }
    return chatpath;
  }

  Future<File> saveFilesOFChat(File file, type) async {
    Directory folder_path = Directory("");
    folder_path = await getDirpPath();
    // if (type == "image")
    //   file = io.Directory("$folder_path/img/").listSync();
    // else
    //   file = io.Directory("$folder_path/audio/").listSync();
    String fileName = basename(file.path);
    fileName = DateTime.now().toString() + '$fileChecker' + fileName;
    File localImage;
    if (type == "image") {
      localImage = await file.copy('${folder_path.path}img/$fileName');
    } else {
      localImage = await file.copy('${folder_path.path}audio/$fileName');
    }

    return localImage;
  }

  updateStatusOfChat(status, index, dbname) {
    Hive.openBox<ChatRoom>(dbname).then((value) {
      ChatRoom conver = value.getAt(index);
      conver.status = status;
      value.putAt(index, conver);
      conver = value.getAt(index);
    });
  }

  //for d & u ;
  updateStatusOfServerCallingU_D(status, index, dbname) {
    --index;
    Hive.openBox<ChatRoom>(dbname).then((value) async {
      ChatRoom conver = value.getAt(index);
      conver.serverStatus = status;
      await value.putAt(index, conver);
      conver = value.getAt(index);
    });
  }

  void recieveMSG() async {
    Get.find<SocketController>().socket.on(EVENT_MSG, (data) async {
      print("get");

      // GroupMsg().getGroupCreationDataIfCreated();
      // GroupMsg().getMsgFromServerOnPing(data);
      getMsgFromServerOnPing(data);
    });
  }

// called when user turn online
  getMsgFromServerOnPing(data) async {
    print("On GEt111");

    var recData = data.toString().split(seprateString);

    // print(recData[1]);
    if (recData[1] == Get.find<ChatController>().currNumber.value) {
      String url = APIHOST + getChat;
      var response = await http.post(Uri.parse(url), body: {
        "to": "${recData[1]}",
      });
      if (response.statusCode == 200) {
        if (!response.body.toLowerCase().contains("failed") &&
            !response.body.toLowerCase().contains("Error")) {
          print(response.body);
          List recieveMSG = jsonDecode(response.body);
          recieveMSG.forEach((element) {
            // print(element);
            String decrypted;
            if (element['type'] == 'text') {
              final iv = IV.fromLength(16);
              String keystr = element['fromid'];
              // for (int i = element['fromid'].toString().length; i < 16; ++i) {
              //   keystr += '1';
              // }

              int value = 1;
              for (int i = element['fromid'].toString().length; i < 32; ++i) {
                if (value == 9) {
                  value = 1;
                }
                value++;

                keystr = keystr + value.toString();
              }
              print(keystr.length);
              final key = Key.fromUtf8("$keystr");
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
    } else
      print("Other Chat");
  }

  ///send
  saveROOM(to, lastmsg, time, name) {
    String mainDBNAme = Get.find<ChatController>().currNumber.value + ROOMLIST;
    Hive.openBox<RoomList>(mainDBNAme).then((value) {
      bool found = false;
      // print(recData[1]);
      int index = -1;
      RoomList pre = RoomList();

      for (int i = 0; i < value.values.length; ++i) {
        RoomList element = value.values.elementAt(i);
        if (element.phone == to) {
          //print("ID ==> ${i}");
          index = i;
          found = true;
          pre = element;
        }
        // if (found) return;
      }
      // print("ELEMENT===? $found nad = > $index");
      var roomData = RoomList(
        id: "-1",
        lastMsg: "$lastmsg",
        lastMsgTime: "$time",
        name: "${!found ? name : pre.name}",
        phone: "$to",
        isGroup: false,
        isPin: false,
        userRole: "",
        pic: "",
        isArchive: false,
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
    //String sendingMSG = "${from}_${to}_${msg}_${type}_${time}_$name";
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
        userRole: "",
      );
      value.add(conver);
      Get.find<ChatController>().savechatindex(value.values.length);
      Get.find<ChatManager>().addNewChatInList(conver);
    });
  }

  ///////
  @override
  void onInit() {
    super.onInit();
    recieveMSG();
    //GroupMsg().recieveMSG();

    //getDataOnStartOfTheChat();
  }

  ///
  getDataOnStartOfTheChat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Get.find<ChatController>().currNumber(pref.getString("number"));
    String url = APIHOST + getChat;

    var response = await http.post(Uri.parse(url), body: {
      "to": "${Get.find<ChatController>().currNumber.value}",
    });
    if (response.statusCode == 200) {
      if (!response.body.toLowerCase().contains("error") &&
          response.body.isNotEmpty) {
        print(response.body);
        List recieveMSG = jsonDecode(response.body);
        recieveMSG.forEach((element) {
          print(element);

          String decrypted;
          if (element['type'] == 'text') {
            final iv = IV.fromLength(16);
            String keystr = '';

            int value = 1;
            for (int i = element['fromid'].toString().length; i < 32; ++i) {
              if (value == 9) {
                value = 1;
              }
              value++;
              keystr += value.toString();
            }

            // final key = Key.fromUtf8("${from}");
            final key = Key.fromUtf8("${element['fromid']}$keystr");
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
  }

//recieved
  onrecieveSaveMesg(recData, decrypted) async {
    String dbName = '${recData['toid']}_${recData['fromid']}';
    print("On get => ${recData['name']}");
    int id = 0;

    await Hive.openBox<ChatRoom>(dbName).then((value) {
      var conver = ChatRoom(
        fromPhone: recData['fromid'],
        toPhone: recData['toid'],
        time: recData['time'],
        msg: decrypted,
        type: recData['type'],
        status: recData['type'] != 'text' ? 'notdownload' : 'recieved',
        serverStatus: 'f',
        isGroup: false,
        userRole: "",
      );
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
    await Hive.openBox<RoomList>(mainDBNAme).then((value) {
      bool found = false;
      // print(recData[1]);
      int index = -1;
      RoomList pre;

      for (int i = 0; i < value.values.length; ++i) {
        RoomList element = value.values.elementAt(i);
        if (element.phone == recData['fromid'].toString()) {
          // print("ID ==> ${i}");
          index = i;
          found = true;
          pre = element;
        }
        // if (found) return;
      }

      var roomData = RoomList(
        id: "-1",
        lastMsg: decrypted,
        lastMsgTime: recData['time'].toString(),
        name: '${recData['name']}',
        phone: '${recData['fromid']}',
        isArchive: false,
        isGroup: false,
        isPin: false,
        userRole: "",
        pic: "",
      );
      if (found == false) {
        value.add(roomData);
      }
      if (found) {
        value.putAt(index, roomData);
      }
    });
  }

  sendnotify(fromnumber, msg, id) async {
    /// Recommended to create this regardless as the behaviour may vary as
    /// mentioned in https://developer.android.com/training/notify-user/group
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Doc.Talk',
      'FYP',
      'Chat Message From',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'login',
      largeIcon: DrawableResourceAndroidBitmap('login'),
      //sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        id, '$fromnumber ', "$msg", platformChannelSpecifics,
        payload: '$number');
  }
}
