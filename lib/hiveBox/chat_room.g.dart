// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatRoomAdapter extends TypeAdapter<ChatRoom> {
  @override
  final int typeId = 3;

  @override
  ChatRoom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      // ignore: sdk_version_ui_as_code
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatRoom(
      fromPhone: fields[0] as String,
      toPhone: fields[1] as String,
      msg: fields[2] as String,
      type: fields[3] as String,
      time: fields[4] as String,
      status: fields[5] as String,
      serverStatus: fields[6] as String,
      isGroup: fields[7] as bool,
      userRole: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoom obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.fromPhone)
      ..writeByte(1)
      ..write(obj.toPhone)
      ..writeByte(2)
      ..write(obj.msg)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.serverStatus)
      ..writeByte(7)
      ..write(obj.isGroup)
      ..writeByte(8)
      ..write(obj.userRole);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
