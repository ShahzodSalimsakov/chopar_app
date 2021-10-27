// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryTypeAdapter extends TypeAdapter<DeliveryType> {
  @override
  final int typeId = 5;

  @override
  DeliveryType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryType()..value = fields[0] as DeliveryTypeEnum?;
  }

  @override
  void write(BinaryWriter writer, DeliveryType obj) {
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
      other is DeliveryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeliveryTypeEnumAdapter extends TypeAdapter<DeliveryTypeEnum> {
  @override
  final int typeId = 6;

  @override
  DeliveryTypeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DeliveryTypeEnum.pickup;
      case 1:
        return DeliveryTypeEnum.deliver;
      default:
        return DeliveryTypeEnum.pickup;
    }
  }

  @override
  void write(BinaryWriter writer, DeliveryTypeEnum obj) {
    switch (obj) {
      case DeliveryTypeEnum.pickup:
        writer.writeByte(0);
        break;
      case DeliveryTypeEnum.deliver:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryTypeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
