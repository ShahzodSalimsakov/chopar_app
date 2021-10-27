import 'package:hive/hive.dart';

part 'deliver_later_time.g.dart';

@HiveType(typeId: 9)
class DeliverLaterTime {
  @HiveField(0)
  late String value;
}