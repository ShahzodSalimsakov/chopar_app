// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryTimeAdapter extends TypeAdapter<DeliveryTime> {
  @override
  final int typeId = 8;

  @override
  DeliveryTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryTime()..value = fields[0] as DeliveryTimeEnum;
  }

  @override
  void write(BinaryWriter writer, DeliveryTime obj) {
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
      other is DeliveryTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeliveryTimeEnumAdapter extends TypeAdapter<DeliveryTimeEnum> {
  @override
  final int typeId = 7;

  @override
  DeliveryTimeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeliveryTimeEnum.now;
      case 1:
        return DeliveryTimeEnum.later;
      default:
        return DeliveryTimeEnum.now;
    }
  }

  @override
  void write(BinaryWriter writer, DeliveryTimeEnum obj) {
    switch (obj) {
      case DeliveryTimeEnum.now:
        writer.writeByte(0);
        break;
      case DeliveryTimeEnum.later:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryTimeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
