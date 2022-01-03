// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_is_scrolled.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeIsScrolledAdapter extends TypeAdapter<HomeIsScrolled> {
  @override
  final int typeId = 15;

  @override
  HomeIsScrolled read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeIsScrolled()..value = fields[0] as bool;
  }

  @override
  void write(BinaryWriter writer, HomeIsScrolled obj) {
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
      other is HomeIsScrolledAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
