import 'package:flutter/material.dart';
import 'package:fyp_secure_com/commonAtStart/chat_controller.dart';
import 'package:get/get.dart';

class GetContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatController>(
        init: ChatController(),
        initState: (_) {},
        builder: (_) {
          return ListView.builder(
              itemCount: _.contactList.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(_.contactList[index].displayName),
                  leading: CircleAvatar(
                    child: Center(
                      child: Text(_.contactList[index].givenName),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
