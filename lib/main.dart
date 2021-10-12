// @dart=2.9
import 'dart:async';
import 'dart:io';

//$procQ = "SELECT formdataofpatient.pro FROM `formdataofpatient` WHERE formdataofpatient.number = (select number from patient WHERE number = '03431530052')  ORDER by formdataofpatient.curDate DESC LIMIT 1";

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_secure_com/admin/view/admin_home.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/all_controller.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:fyp_secure_com/commonAtStart/index.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/doctor/view/doctor_home.dart';
import 'package:fyp_secure_com/hiveBox/chat_room.dart';
import 'package:fyp_secure_com/hiveBox/message.dart';
import 'package:fyp_secure_com/hiveBox/room_list.dart';
import 'package:fyp_secure_com/pa/view/pa_home.dart';
import 'package:fyp_secure_com/patient/view/patient_home.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///flutter packages pub run build_runner build --delete-conflicting-outputs

var screen;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future onSelectNotification(String payload) async {
  print('notification payload: $payload');
}

Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  print(title);
  print(body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref = await SharedPreferences.getInstance();
  String role = pref.containsKey("role") ? pref.getString("role") : "";
  String token = pref.containsKey("token") ? pref.get("token") : "";
  String number = pref.containsKey("number") ? pref.get("number") : "";

  //ChatController().updateCurrNumber(pref.get("number"));
  if (role == null)
    screen = StartExploer();
  else if (role == "Admin")
    screen = AdminHome();
  else if (role == "Doctor")
    screen = DoctorHome();
  else if (role == "Patient")
    screen = PatientHome();
  else if (role == "pa") screen = PAHome();

  if (!kIsWeb) {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }
  Hive.registerAdapter(ChatRoomAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(RoomListAdapter());

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('login');

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification);

  /// await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CheckLifeOFApp();
  }
}

class CheckLifeOFApp extends StatefulWidget {
  @override
  _CheckLifeOFAppState createState() => _CheckLifeOFAppState();
}

class _CheckLifeOFAppState extends State<CheckLifeOFApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    print("App Start");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("App Dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //print("Dispose");
    setState(() {});
    print("object");
    if (state == AppLifecycleState.inactive) {
      Get.find<SocketController>()
          .socketlogout(Get.find<ChatController>().currNumber.value);
    }
    if (state == AppLifecycleState.resumed) {
      Get.find<SocketController>()
          .onCOnnected(Get.find<ChatController>().currNumber.value);
    }
    if (state == AppLifecycleState.detached) {}
    if (state == AppLifecycleState.paused) {}
  }

  /////
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: All_controller(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter ',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: white),
      ),
      home: screen,
      // home: Get.find<SocketController>().checkConnected.value
      //     ? screen
      //     : Scaffold(
      //         body: Center(
      //           child: Text("Network Error ! \n Check Wifi OR Mobile Data "),
      //         ),
      //       ),
    );
  }
}
