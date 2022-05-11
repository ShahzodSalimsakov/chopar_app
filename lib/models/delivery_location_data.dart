import 'package:hive/hive.dart';

part 'delivery_location_data.g.dart';

@HiveType(typeId: 4)
class DeliveryLocationData {
  @HiveField(0)
  late String? house;

  @HiveField(1)
  late String? flat;

  @HiveField(2)
  late String? entrance;

  @HiveField(3)
  late String? doorCode;

  @HiveField(5)
  late double? lat;

  @HiveField(6)
  late double? lon;

  @HiveField(7)
  late String? address;

  @HiveField(8)
  late String? label;

  DeliveryLocationData({this.house, this.flat, this.entrance, this.doorCode, this.lat, this.lon, this.address, this.label});
}