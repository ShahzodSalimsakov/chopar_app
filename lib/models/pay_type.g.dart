// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayTypeAdapter extends TypeAdapter<PayType> {
  @override
  final int typeId = 10;

  @override
  PayType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayType()..value = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, PayType obj) {
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
      other is PayTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
