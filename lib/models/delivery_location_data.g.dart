// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_location_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryLocationDataAdapter extends TypeAdapter<DeliveryLocationData> {
  @override
  final int typeId = 4;

  @override
  DeliveryLocationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryLocationData(
      house: fields[0] as String?,
      flat: fields[1] as String?,
      entrance: fields[2] as String?,
      doorCode: fields[3] as String?,
      notes: fields[4] as String?,
      lat: fields[5] as double?,
      lon: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryLocationData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.house)
      ..writeByte(1)
      ..write(obj.flat)
      ..writeByte(2)
      ..write(obj.entrance)
      ..writeByte(3)
      ..write(obj.doorCode)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.lat)
      ..writeByte(6)
      ..write(obj.lon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryLocationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
