import 'package:hive/hive.dart';

part 'delivery_notes.g.dart';

@HiveType(typeId: 11)
class DeliveryNotes {
  @HiveField(0)
  late String deliveryNotes;
}