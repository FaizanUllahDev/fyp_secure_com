import 'package:hive/hive.dart';
part 'message.g.dart';

@HiveType(typeId: 2)
class Message {
  @HiveField(0)
  String msgid;
  @HiveField(1)
  String msg;
  @HiveField(2)
  String type;
  @HiveField(3)
  String id;

  Message({this.msgid = "", this.msg = "", this.type = "", this.id = ""});
}
