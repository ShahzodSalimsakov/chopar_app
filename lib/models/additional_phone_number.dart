import 'package:hive/hive.dart';

part 'additional_phone_number.g.dart';

@HiveType(typeId: 14)
class AdditionalPhoneNumber {
  @HiveField(0)
  late String additionalPhoneNumber;
}