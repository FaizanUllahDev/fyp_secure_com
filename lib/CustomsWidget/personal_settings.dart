import 'package:flutter/material.dart';

class PersonalSettings extends StatelessWidget {
  final roomData;

  const PersonalSettings({Key key, this.roomData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(),
      ),
    );
  }
}
