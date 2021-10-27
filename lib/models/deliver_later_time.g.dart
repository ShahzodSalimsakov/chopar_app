// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deliver_later_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliverLaterTimeAdapter extends TypeAdapter<DeliverLaterTime> {
  @override
  final int typeId = 9;

  @override
  DeliverLaterTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliverLaterTime()..value = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, DeliverLaterTime obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliverLaterTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
