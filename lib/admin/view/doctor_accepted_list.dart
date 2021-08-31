import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp_secure_com/admin/controller/admin_controller.dart';
import 'package:fyp_secure_com/admin/model/doctor_model.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/commonAtStart/start_explore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';

class AdminAcceptList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accepted"),
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
        () => Get.find<AdminController>().acceptedList.length > 0
            ? DoctorListAccepted(Get.find<AdminController>().acceptedList)
            : Center(child: Text("No Record.")),
      ),
      drawer: customDrawer(),
    );
  }
}

class DoctorListAccepted extends StatelessWidget {
  final RxList<DoctorModel> list;
  DoctorListAccepted(this.list);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.find<AdminController>().updateDoctorStatus(
                          list[index].number, "Blocked", index);
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.block_flipped),
                          Text("Block"),
                        ],
                      ),
                    ),
                  )),
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
