import 'package:hive/hive.dart';

part 'delivery_time.g.dart';

@HiveType(typeId: 7)
enum DeliveryTimeEnum {
  @HiveField(0)
  now,
  @HiveField(1)
  later
}

@HiveType(typeId: 8)
class DeliveryTime {
  @HiveField(0)
  late DeliveryTimeEnum value;
}
