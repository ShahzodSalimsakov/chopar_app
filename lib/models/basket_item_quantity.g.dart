// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_item_quantity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BasketItemQuantityAdapter extends TypeAdapter<BasketItemQuantity> {
  @override
  final int typeId = 19;

  @override
  BasketItemQuantity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BasketItemQuantity()
      ..quantity = fields[0] as int
      ..lineId = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, BasketItemQuantity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.lineId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasketItemQuantityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
