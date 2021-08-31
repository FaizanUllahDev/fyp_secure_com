import 'package:flutter/material.dart';
import 'package:fyp_secure_com/CustomsWidget/profile.dart';
import 'package:fyp_secure_com/chats/archive_chat.dart';
import 'package:fyp_secure_com/colors/color.dart';
import 'package:fyp_secure_com/doctor/view/doctor_home.dart';
import 'package:fyp_secure_com/doctor/view/invitation_list_page.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

getNavBar(cur, context) {
  return Container(
    child: GNav(
      rippleColor: Colors.blue, // tab button ripple color when pressed
      hoverColor: Colors.blue, // tab button hover color
      haptic: true, // haptic feedback
      tabBorderRadius: 14,
      tabActiveBorder:
          Border.all(color: Colors.blue, width: 1), // tab button border
      tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
      // tabShadow: [
      //   BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
      // ], // tab button shadow
      curve: Curves.easeOutExpo, // tab animation curves
      duration: Duration(milliseconds: 300), // tab animation duration
      gap: 5, // the tab button gap between icon and text
      // color: Colors.grey[800], // unselected icon color
      activeColor: Colors.blue, // selected icon and text color
      iconSize: 24, // tab button icon size
      tabBackgroundColor:
          Colors.purple.withOpacity(0.1), // selected tab background color
      selectedIndex: cur,
      tabMargin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      padding: EdgeInsets.symmetric(
          horizontal: 10, vertical: 7), // navigation bar padding
      tabs: [
        GButton(
          icon: LineIcons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.person_add,
          text: 'Invite',
        ),
        GButton(
          icon: Icons.archive,
          text: 'Archive',
        ),
        GButton(
          icon: Icons.settings,
          text: 'Profile',
        ),
      ],
      onTabChange: (ind) {
        switch (ind) {
          case 0:
            Get.offAll(() => DoctorHome());
            break;
          case 1:
            Get.offAll(() => InvitationListPage());
            break;
          case 2:
            Get.offAll(() => ArchiveChat());
            break;
          case 3:
            Get.offAll(() => Profile());
            break;
        }
      },
    ),
  );
}
