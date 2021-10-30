import 'package:hive/hive.dart';

part 'pay_cash.g.dart';

@HiveType(typeId: 12)
class PayCash {
  @HiveField(0)
  late String value;
}