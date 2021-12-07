import 'package:hive/hive.dart';
part 'stock.g.dart';

@HiveType(typeId: 13)
class Stock extends HiveObject {
  @HiveField(0)
  late List<int> prodIds;

  Stock({
    required this.prodIds
  });


}
