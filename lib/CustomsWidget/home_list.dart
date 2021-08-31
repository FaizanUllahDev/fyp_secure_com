import 'package:flutter/material.dart';

class HomeList extends StatelessWidget {
  final leading, title, sub, trailing;

  const HomeList({this.leading, this.title, this.sub, this.trailing});

  @override
  Widget build(BuildContext context) {
    ///data/user/0/com.example.fyp_chat_app/cache/image_picker9001887264347397463.jpg
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          // backgroundImage: FileImage(File(profile_img)),
          child: Text(
            "${title.toString()}",
            style: TextStyle(color: Colors.white),
          ),
          radius: 50,
        ),
        title: Text("$title"),
        subtitle: Text("$sub"),
        trailing: Text("$trailing"),
      ),
    );
  }
}
