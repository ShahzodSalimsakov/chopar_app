// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TerminalsAdapter extends TypeAdapter<Terminals> {
  @override
  final int typeId = 3;

  @override
  Terminals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Terminals(
      id: fields[0] as String?,
      createdAt: fields[1] as String?,
      updatedAt: fields[2] as String?,
      terminalId: fields[3] as String?,
      name: fields[4] as String?,
      desc: fields[5] as String?,
      nameUz: fields[6] as String?,
      descUz: fields[7] as String?,
      nameEn: fields[8] as String?,
      descEn: fields[9] as String?,
      deliveryTime: fields[10] as String?,
      pickupTime: fields[11] as String?,
      latitude: fields[12] as String?,
      longitude: fields[13] as String?,
      openWork: fields[14] as String?,
      closeWork: fields[15] as String?,
      openWeekend: fields[16] as String?,
      closeWeekend: fields[17] as String?,
      tgGroup: fields[18] as String?,
      active: fields[19] as bool?,
      deliveryType: fields[21] as String?,
      paymeActive: fields[22] as bool?,
      paymeTestMode: fields[23] as bool?,
      paymeMerchantId: fields[24] as String?,
      paymeSecureKey: fields[25] as String?,
      paymeSecureKeyTest: fields[26] as String?,
      paymePrint: fields[27] as String?,
      paymeCallbackTime: fields[28] as Null,
      clickActive: fields[29] as bool?,
      clickMerchantServiceId: fields[30] as String?,
      clickMerchantUserId: fields[31] as String?,
      clickSecretKey: fields[32] as String?,
      clickMerchantId: fields[33] as String?,
      cityId: fields[34] as int?,
      isWorking: fields[35] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Terminals obj) {
    writer
      ..writeByte(35)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.updatedAt)
      ..writeByte(3)
      ..write(obj.terminalId)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.desc)
      ..writeByte(6)
      ..write(obj.nameUz)
      ..writeByte(7)
      ..write(obj.descUz)
      ..writeByte(8)
      ..write(obj.nameEn)
      ..writeByte(9)
      ..write(obj.descEn)
      ..writeByte(10)
      ..write(obj.deliveryTime)
      ..writeByte(11)
      ..write(obj.pickupTime)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.longitude)
      ..writeByte(14)
      ..write(obj.openWork)
      ..writeByte(15)
      ..write(obj.closeWork)
      ..writeByte(16)
      ..write(obj.openWeekend)
      ..writeByte(17)
      ..write(obj.closeWeekend)
      ..writeByte(18)
      ..write(obj.tgGroup)
      ..writeByte(19)
      ..write(obj.active)
      ..writeByte(21)
      ..write(obj.deliveryType)
      ..writeByte(22)
      ..write(obj.paymeActive)
      ..writeByte(23)
      ..write(obj.paymeTestMode)
      ..writeByte(24)
      ..write(obj.paymeMerchantId)
      ..writeByte(25)
      ..write(obj.paymeSecureKey)
      ..writeByte(26)
      ..write(obj.paymeSecureKeyTest)
      ..writeByte(27)
      ..write(obj.paymePrint)
      ..writeByte(28)
      ..write(obj.paymeCallbackTime)
      ..writeByte(29)
      ..write(obj.clickActive)
      ..writeByte(30)
      ..write(obj.clickMerchantServiceId)
      ..writeByte(31)
      ..write(obj.clickMerchantUserId)
      ..writeByte(32)
      ..write(obj.clickSecretKey)
      ..writeByte(33)
      ..write(obj.clickMerchantId)
      ..writeByte(34)
      ..write(obj.cityId)
      ..writeByte(35)
      ..write(obj.isWorking);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TerminalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
