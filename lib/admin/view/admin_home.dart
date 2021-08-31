import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/admin/controller/admin_controller.dart';
import 'package:fyp_secure_com/admin/model/doctor_model.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/APIHelper.dart';
import 'package:fyp_secure_com/commonAtStart/all_controller.dart';
import 'package:fyp_secure_com/commonAtStart/socket_controller.dart';
import 'package:fyp_secure_com/commonAtStart/start_explore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  SharedPreferences pref;
  String number;

  // ini() async {
  //   pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     number = pref.getString("number");
  //   });
  //   try {
  //     var connectivityResult = await (Connectivity().checkConnectivity());
  //     if (connectivityResult == ConnectivityResult.wifi)
  //       AdminController().updateNetStatus(true);
  //   } catch (e) {
  //     AdminController().updateNetStatus(false);
  //   }
  // }

  @override
  void initState() {
    Get.put(AdminController(), permanent: true);
    super.initState();
    // Get.put(AdminController());

    //ini();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending "),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                //AdminController().logout();
                Get.delete<AdminController>(force: true);
                logout();
              })
        ],
      ),
      body: Obx(
        () => Get.find<AdminController>().pendingLists.length > 0
            ? DoctorListPending(Get.find<AdminController>().pendingLists)
            : Center(child: Text("No Record.")),
      ),
      drawer: customDrawer(),
      floatingActionButton: Visibility(
        visible: false,
        child: FloatingActionButton(
          autofocus: true,
          onPressed: () {
            Get.find<SocketController>().socket.emit(EVENT_CHECK_CONNECT,
                '${Get.find<AdminController>().number.value}');
            Get.find<SocketController>().socket.emit(EVENT_MSG,
                ['${Get.find<AdminController>().number.value}_Sample']);
          },
        ),
      ),
    );
  }
}

class DoctorListPending extends StatelessWidget {
  final RxList<DoctorModel> list;
  DoctorListPending(this.list);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Accept',
                color: Colors.black45,
                icon: CupertinoIcons.check_mark,
                onTap: () => Get.find<AdminController>()
                    .updateDoctorStatus(list[index].number, "Accepted", index),
              ),
              IconSlideAction(
                caption: 'Reject',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => Get.find<AdminController>()
                    .updateDoctorStatus(list[index].number, "Rejected", index),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: blue,
                ),
                child: ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(fontSize: 25),
                  ),
                  dense: true,
                  selectedTileColor: Colors.blue[300],
                  title: Text(
                    "${list[index].name}".toUpperCase(),
                    style: TextStyle(fontSize: 25, color: white),
                  ),
                  subtitle: Text(
                    "${list[index].number}",
                    style: TextStyle(fontSize: 20, color: white),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
