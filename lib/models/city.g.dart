// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CityAdapter extends TypeAdapter<City> {
  @override
  final int typeId = 0;

  @override
  City read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return City(
      id: fields[0] as int,
      xmlId: fields[1] as String,
      name: fields[2] as String,
      nameUz: fields[3] as String,
      mapZoom: fields[4] as String,
      lat: fields[5] as String,
      lon: fields[6] as String,
      active: fields[7] as bool,
      sort: fields[8] as int,
      phone: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, City obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.xmlId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.nameUz)
      ..writeByte(4)
      ..write(obj.mapZoom)
      ..writeByte(5)
      ..write(obj.lat)
      ..writeByte(6)
      ..write(obj.lon)
      ..writeByte(7)
      ..write(obj.active)
      ..writeByte(8)
      ..write(obj.sort)
      ..writeByte(9)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
