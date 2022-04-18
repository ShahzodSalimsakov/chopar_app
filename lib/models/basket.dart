
import 'package:hive/hive.dart';

part 'basket.g.dart';

@HiveType(typeId: 2)
class Basket {

	@HiveField(0)
  late String encodedId;

	@HiveField(1)
  late int lineCount;

  @HiveField(2)
  late int? totalPrice;
  Basket({required this.encodedId, required this.lineCount, this.totalPrice});
}
