import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import 'APIHelper.dart';

class SocketController extends GetxController {
  IO.Socket socket =
      IO.io(IP, OptionBuilder().setTransports(['websocket']).build());
  var onlineFriends = <String>[].obs;
  var checkConnected = false.obs;

  @override
  void onClose() {
    //socket.emit("close", [Get.find<ChatController>().currNumber.value]);
    super.onClose();
  }

  @override
  void onInit() {
    connectAndListen();
    super.onInit();
    checkOnlineFriends();
    pingOnlineLIst();
    checkIsOnline();
  }

  void connectAndListen() {
    socket = IO.io(IP, OptionBuilder().setTransports(['websocket']).build());
    //print(":Admin Socket");
    socket.onConnect((_) {
      //print(' Admin connect');
      onCOnnected(Get.find<ChatController>().currNumber.value);
      Get.find<SocketController>().checkConnected(true);
    });

    //socket.emit('connect', ['Admin Connect']);
    socket.onConnectError((data) {
      Get.find<SocketController>().checkConnected(false);
      print('socket=>error');
    });

    socket.onDisconnect((_) {
      Get.find<SocketController>().checkConnected(false);
      socket.emit('close', [Get.find<ChatController>().currNumber.value]);

      //socketlogout(Get.find<ChatController>().currNumber.value);
      print('disconnect');
    });

    // socket.on("close", (list) {
    //   print("Onlines cLOSWE");
    //   print(list);
    //   bool findNum = false;
    //   onlineFriends.clear();
    //   list.forEach((element) {
    //     onlineFriends.add(element[2]);
    //   });
    // });

    // socket.on(
    //     'onGroupCreate', (data) => GroupMsg().getGroupCreationDataIfCreated());
  }

  void onCOnnected(number) {
    Get.find<SocketController>().socket.emit(EVENT_SEND_NUMBER, ['$number']);
  }

  void checkIsOnline() {
    socket.on("check_is_toonline", (data) {
      //print(data);
      // print("Save Data TO SEEVER");
    });
  }

  void checkOnlineFriends() {
    socket.on("online", (list) {
      print("Onlines ==> ${Get.find<ChatController>().currNumber.value}");
      print(list);
      //bool findNum = false;
      onlineFriends.clear();
      list.forEach((element) {
        onlineFriends.add(element[2]);
      });
    });
  }

  void pingOnlineLIst() {
    // if (socket == null) {
    //   socket = IO.io(IP, OptionBuilder().setTransports(['websocket']).build());
    // }
    socket.emit('online', []);
  }

  void socketlogout(number) {
    // Get.find<SocketController>()
    //     .socket
    //     .emit('CLOSE', [Get.find<ChatController>().currNumber.value]);
    Get.find<SocketController>().socket.emit(EVENT_LOGOUT, ['$number']);

    // socket.clearListeners();
    // socket.close();
  }

  void sendOTP(number, otp) {
    Get.find<SocketController>()
        .socket
        .emit('otp', [' =>   , $number => OTP => $otp']);
  }

  void updateDoctorStatus(msg) {
    Get.find<SocketController>().socket.emit(EVENT_DOCTOR_STATUS, '$msg');
  }

  //////end
}
