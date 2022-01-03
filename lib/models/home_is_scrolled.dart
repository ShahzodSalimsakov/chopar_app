import 'package:hive/hive.dart';

part 'home_is_scrolled.g.dart';

@HiveType(typeId: 15)
class HomeIsScrolled {
  @HiveField(0)
  late bool value;
}