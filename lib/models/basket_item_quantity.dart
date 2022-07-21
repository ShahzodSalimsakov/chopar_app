import 'package:hive/hive.dart';

part 'basket_item_quantity.g.dart';

@HiveType(typeId: 19)
class BasketItemQuantity {
  @HiveField(0)
  late int quantity;

  @HiveField(1)
  late int lineId;
}