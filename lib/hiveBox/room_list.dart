import 'package:hive/hive.dart';
part 'room_list.g.dart';

@HiveType(typeId: 1)
class RoomList {
  @HiveField(0)
  String phone;
  @HiveField(1)
  String name;
  @HiveField(2)
  String lastMsg;
  @HiveField(3)
  String pic;
  @HiveField(4)
  String lastMsgTime;
  @HiveField(5)
  String id;
  @HiveField(6)
  bool isArchive = false;
  @HiveField(7)
  bool isGroup;
  @HiveField(8)
  String userRole;
  @HiveField(9)
  bool isPin;

  RoomList({
    this.name = "",
    this.phone = "",
    this.lastMsg = "",
    this.lastMsgTime = "",
    this.pic = "",
    this.id = "",
    this.isArchive = false,
    this.isGroup = false,
    this.userRole = "",
    this.isPin = false,
  });
}
