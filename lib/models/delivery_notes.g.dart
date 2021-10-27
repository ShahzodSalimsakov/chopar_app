// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_notes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryNotesAdapter extends TypeAdapter<DeliveryNotes> {
  @override
  final int typeId = 11;

  @override
  DeliveryNotes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryNotes()..deliveryNotes = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, DeliveryNotes obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.deliveryNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryNotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
