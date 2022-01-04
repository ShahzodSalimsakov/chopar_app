import 'package:hive/hive.dart';

part 'home_scroll_position.g.dart';

@HiveType(typeId: 16)
class HomeScrollPosition {
  @HiveField(0)
  late int value;
}