import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/hiveBox/chat_room.dart';
import 'package:fyp_secure_com/hiveBox/forward_class.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatManager extends GetxController {
  List<RoomList> searchLst = <RoomList>[].obs;
  bool isDownloading = false;
  double boxH = 50.0;
  var isPlaying = false.obs;
  int selectedInd = 0;
  String CurrentChatOPen = "";

  updateCurrentChatOPen(v) {
    CurrentChatOPen = v;
    update();
  }

  List<ChatRoom> individualChatList = [];
  bool isNewChatMessage = false;

  var maxTime = ''.obs;

  updateMaxTime(v) => maxTime(v);

  getFormView(pnum, docNumber) async {
    Uri url = Uri.parse(APIHOST + "getFormView.php");
    var res = await http.post(url, body: {
      "pnum": pnum,
      "docnum": docNumber,
    });
    if (res.statusCode == 200) {
      print(res.body);
      return jsonDecode(res.body);
    } else {
      print(res.body);
      return "";
    }
  }

  removeNewMessageIndicator() {
    isNewChatMessage = false;
    update();
  }

  addNewChatInList(ChatRoom chatRoom) {
    individualChatList.add(chatRoom);
    isNewChatMessage = true;
    update();
  }

  assignChatList(lst) {
    individualChatList = lst;
    update;
  }

  int currentIndex = 0;

  List<ForwardClass> forwardIndexesSelected = [];

  updateForwardIndexesSelected(ind, data) {
    ForwardClass room = ForwardClass(index: ind, roomData: data);
    forwardIndexesSelected.add(room);
    update();
  }

  updateForwardClear(data) {
    forwardIndexesSelected.remove(data);
    update();
  }

  int chatSelectedIndex = -1;

  updatechatSelectedIndex(ind) {
    chatSelectedIndex = ind;
    update();
  }

  updateCurrentIndex(ind) {
    currentIndex = ind;
    update();
  }

  updateSelectedInd(ind) {
    selectedInd = ind;
    update();
  }

  updateHBox(h) {
    boxH = h;
    update();
  }

  updateSearchLst(List<RoomList> lst) {
    searchLst = lst;
  }

  var position = Duration().obs;

  // Platform messages are asynchronous, so we initialize in an async method.

  var duration = new Duration().obs;
  //AudioPlayer advancedPlayer;
  var isPlayinga = true.obs;

  updateDownloadingStatus(n) {
    isDownloading = n;
    update();
  }

  updateisPlaying(n) => isPlaying(n);

/////audio

  ///////
  @override
  void onInit() {
    super.onInit();
  }

  ///base image
  ///

  ///
  ///

  downloadFiles(fileName, index, type, dbName, from) async {
    try {
      updateDownloadingStatus(true);
      ChatController().updateStatusOfServerCallingU_D("d", ++index, dbName);

      if (await Permission.storage.request().isGranted) {
        try {
          var url;
          if (type == "image")
            url = FILES_IMG + fileName;
          else if (type == "audio") url = FILES_MP3 + fileName;
          var response = await http.get(Uri.parse(url)); // <--2
          await ChatController().getDirpPath();
          var documentDirectory = await getExternalStorageDirectory();
          //var firstPath = documentDirectory.path + "/$folderName/img";
          var savefileName =
              DateTime.now().toString() + '$fileChecker' + fileName;

          var filePathAndName;
          if (type == "audio") {
            filePathAndName =
                documentDirectory.path + '/$folderName/audio/$fileName';
          } else if (type == "image") {
            filePathAndName =
                documentDirectory.path + '/$folderName/img/$savefileName';
          }
          print(
              "//////////////////////////////////////////////////////////////////////////////////////////" +
                  filePathAndName);
          List<int> newBtyes = response.bodyBytes;
          // for (int i = 0; i < response.bodyBytes.length; ++i) {
          //   if (i % 2 == 0) newBtyes[i] = response.bodyBytes[i] - 100;
          // }

          Encrypted encrypted;

          final iv = IV.fromLength(16);
          String keystr = from;
          int value = 1;
          for (int i = from.toString().length; i < 32; ++i) {
            if (value == 9) {
              value = 1;
            }
            value++;

            keystr = keystr + value.toString();
          }

          final key = Key.fromUtf8(keystr);
          print(keystr);
          final encrypter = Encrypter(AES(key));
          encrypted = Encrypted(newBtyes);
          newBtyes = encrypter.decryptBytes(encrypted, iv: iv);

          File file2 = new File(filePathAndName); // <-- 2
          file2.writeAsBytesSync(newBtyes); // <-- 3
          // String dec_path = EncryptData.decrypt_file(file2.path);
          // File newF = File(dec_path);
          // file2.writeAsBytesSync(newF.readAsBytesSync());
          // print(
          //     "//////////////////////////////////////////////////////////////////////////////////////////" +
          //         newF.path);
          // newF.deleteSync(recursive: true);
          updateStatusFileOfChat("downloaded", --index, dbName, file2.path);
          ChatController()
              .updateStatusOfServerCallingU_D("done", --index, dbName);

          url = APIHOST + onDownload;
          var dltFile = await http.post(Uri.parse(url), body: {
            "filename": fileName,
            "type": type,
          });

          if (!dltFile.body.contains('Error')) {
            print("deleted");
          } else
            print("Error To Delete => ${dltFile.body}");

          //
        } catch (e) {
          ChatController().updateStatusOfServerCallingU_D("f", --index, dbName);
          updateStatusFileOfChat("notdownload", --index, dbName, fileName);
          print(e);
        }
      }
    } catch (e) {
      print("Error Ha ...");
      ChatController().updateStatusOfServerCallingU_D("f", --index, dbName);
      updateStatusFileOfChat("notdownload", --index, dbName, fileName);
      print(e);
    }

    print("Here isDownloading(true);");

    updateDownloadingStatus(false);

    // return filePathAndName;
  }

  updateStatusFileOfChat(status, index, dbname, path) {
    Hive.openBox<ChatRoom>(dbname).then((value) {
      //--index;
      ChatRoom conver = value.getAt(index);
      print(conver.status);
      conver.msg = path;
      conver.status = status;
      value.putAt(index, conver);
      conver = value.getAt(index);
    });
  }

  ///
}
