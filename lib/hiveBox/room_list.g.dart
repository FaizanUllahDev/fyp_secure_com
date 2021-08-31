// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomListAdapter extends TypeAdapter<RoomList> {
  @override
  final int typeId = 1;

  @override
  RoomList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomList(
      name: fields[1] as String,
      phone: fields[0] as String,
      lastMsg: fields[2] as String,
      lastMsgTime: fields[4] as String,
      pic: fields[3] as String,
      id: fields[5] as String,
      isArchive: fields[6] as bool,
      isGroup: fields[7] as bool,
      userRole: fields[8] as String,
      isPin: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RoomList obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.phone)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lastMsg)
      ..writeByte(3)
      ..write(obj.pic)
      ..writeByte(4)
      ..write(obj.lastMsgTime)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.isArchive)
      ..writeByte(7)
      ..write(obj.isGroup)
      ..writeByte(8)
      ..write(obj.userRole)
      ..writeByte(9)
      ..write(obj.isPin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
