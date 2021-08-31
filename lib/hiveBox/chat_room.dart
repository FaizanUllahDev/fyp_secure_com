import 'package:hive/hive.dart';

///flutter packages pub run build_runner build

part 'chat_room.g.dart';

@HiveType(typeId: 3)
class ChatRoom {
  @HiveField(0)
  String fromPhone;
  @HiveField(1)
  String toPhone;
  @HiveField(2)
  String msg;
  @HiveField(3)
  String type;
  @HiveField(4)
  String time;
  @HiveField(5)
  String status;
  @HiveField(6)
  String serverStatus;
  @HiveField(7)
  bool isGroup;
  @HiveField(8)
  String userRole;
  @HiveField(9)
  String chatid;
  ChatRoom({
    this.fromPhone = "",
    this.toPhone = "",
    this.msg = "",
    this.type = "",
    this.time = "",
    this.status = "",
    this.serverStatus = "",
    this.isGroup = false,
    this.userRole = "",
    this.chatid = "",
  });
}
