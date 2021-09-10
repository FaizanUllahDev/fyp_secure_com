import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomeDialogWidget {
  diloagBox(title, message, context) {
    return showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                onPressed: () => Get.back(),
                label: Text("Ok"),
              ),
            ],
          );
        });
  }
}
