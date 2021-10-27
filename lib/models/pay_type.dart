import 'package:hive/hive.dart';

part 'pay_type.g.dart';

@HiveType(typeId: 10)
class PayType {
  @HiveField(0)
  late String value;
}