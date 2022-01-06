// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_scroll_position.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeScrollPositionAdapter extends TypeAdapter<HomeScrollPosition> {
  @override
  final int typeId = 16;

  @override
  HomeScrollPosition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeScrollPosition()..value = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, HomeScrollPosition obj) {
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
      other is HomeScrollPositionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
