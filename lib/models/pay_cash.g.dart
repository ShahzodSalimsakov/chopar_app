// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_cash.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayCashAdapter extends TypeAdapter<PayCash> {
  @override
  final int typeId = 12;

  @override
  PayCash read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayCash()..value = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, PayCash obj) {
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
      other is PayCashAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
