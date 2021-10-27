import 'package:hive/hive.dart';

part 'delivery_type.g.dart';

@HiveType(typeId: 6)
enum DeliveryTypeEnum {
  @HiveField(0)
  pickup,
  @HiveField(1)
  deliver
}

@HiveType(typeId: 5)
class DeliveryType {
  @HiveField(0)
  DeliveryTypeEnum? value;
}