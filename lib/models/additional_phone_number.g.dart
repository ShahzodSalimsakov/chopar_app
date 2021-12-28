// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'additional_phone_number.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdditionalPhoneNumberAdapter extends TypeAdapter<AdditionalPhoneNumber> {
  @override
  final int typeId = 14;

  @override
  AdditionalPhoneNumber read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdditionalPhoneNumber()..additionalPhoneNumber = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, AdditionalPhoneNumber obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.additionalPhoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdditionalPhoneNumberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
