// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentCityAdapter extends TypeAdapter<CurrentCity> {
  @override
  final int typeId = 0;

  @override
  CurrentCity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentCity()..city = fields[0] as City?;
  }

  @override
  void write(BinaryWriter writer, CurrentCity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.city);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentCityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
