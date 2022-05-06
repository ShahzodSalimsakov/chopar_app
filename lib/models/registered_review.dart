import 'package:hive/hive.dart';

part 'registered_review.g.dart';

@HiveType(typeId: 17)
class RegisteredReview {
  @HiveField(0)
  late int orderId;
}