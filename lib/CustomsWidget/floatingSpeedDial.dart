import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fyp_secure_com/chats/all_accepted_friends.dart';
import 'package:get/get.dart';

Widget customeFloatBtn = SpeedDial(
  /// both default to 16
  marginEnd: 18,
  marginBottom: 20,
  // animatedIcon: AnimatedIcons.menu_close,
  // animatedIconTheme: IconThemeData(size: 22.0),
  /// This is ignored if animatedIcon is non null
  icon: Icons.add,
  activeIcon: Icons.remove,
  iconTheme: IconThemeData(color: Colors.grey[50], size: 30),

  /// The label of the main button.
  // label: Text("Open Speed Dial"),
  /// The active label of the main button, Defaults to label if not specified.
  // activeLabel: Text("Close Speed Dial"),
  /// Transition Builder between label and activeLabel, defaults to FadeTransition.
  // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
  /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
  buttonSize: 56.0,
  visible: true,

  /// If true user is forced to close dial manually
  /// by tapping main button and overlay is not rendered.
  closeManually: false,

  /// If true overlay will render no matter what.
  renderOverlay: false,
  curve: Curves.bounceIn,
  overlayColor: Colors.black,

  overlayOpacity: 0.5,
  onOpen: () => print('OPENING DIAL'),
  onClose: () => print('DIAL CLOSED'),
  tooltip: 'Chat',
  heroTag: 'Chat',
  backgroundColor: Colors.blue,
  foregroundColor: Colors.black,
  elevation: 8.0,
  shape: CircleBorder(),
  // orientation: SpeedDialOrientation.Up,
  // childMarginBottom: 2,
  // childMarginTop: 2,
  children: [
    // SpeedDialChild(
    //   child: Icon(Icons.group_rounded),
    //   backgroundColor: Colors.white,
    //   label: 'Create Group',
    //   labelStyle: TextStyle(fontSize: 18.0),
    //   onTap: () => Get.to(() => CreateGroup()),
    //   onLongPress: () => print('FIRST CHILD LONG PRESS'),
    // ),
    SpeedDialChild(
      child: Icon(Icons.chat),
      backgroundColor: Colors.white,
      label: 'New Message',
      labelStyle: TextStyle(fontSize: 18.0),
      onTap: () => Get.to(() => AllAcceptedFriend()),
      onLongPress: () => print('SECOND CHILD LONG PRESS'),
    ),
  ],
);
