// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registered_review.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegisteredReviewAdapter extends TypeAdapter<RegisteredReview> {
  @override
  final int typeId = 17;

  @override
  RegisteredReview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegisteredReview()..orderId = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, RegisteredReview obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.orderId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisteredReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
