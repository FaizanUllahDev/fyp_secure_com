import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/admin/controller/admin_controller.dart';
import 'package:fyp_secure_com/admin/model/doctor_model.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/start_explore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';

class AdminRejectedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rejected"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.clear();
                Get.offAll(StartExploer());
              })
        ],
      ),
      body: Obx(
        () => Get.find<AdminController>().rejectedList.length > 0
            ? DoctorListRejected(Get.find<AdminController>().rejectedList)
            : Center(child: Text("No Record.")),
      ),
      drawer: customDrawer(),
    );
  }
}

class DoctorListRejected extends StatelessWidget {
  final RxList<DoctorModel> list;
  DoctorListRejected(this.list);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
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
                    style: TextStyle(fontSize: 25),
                  ),
                  subtitle: Text(
                    "${list[index].number}",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
