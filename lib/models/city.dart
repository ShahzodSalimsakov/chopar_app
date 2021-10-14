
import 'package:hive/hive.dart';
part 'city.g.dart';

@HiveType(typeId: 0)
class City extends HiveObject {
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String xmlId;
  @HiveField(2)
  late String name;
  @HiveField(3)
  late String nameUz;
  @HiveField(4)
  late String mapZoom;
  @HiveField(5)
  late String lat;
  @HiveField(6)
  late String lon;
  @HiveField(7)
  late bool active;
  @HiveField(8)
  late int sort;
  @HiveField(9)
  late String phone;

  City(
      {required this.id,
        required this.xmlId,
        required this.name,
        required this.nameUz,
        required this.mapZoom,
        required this.lat,
        required this.lon,
        required this.active,
        required this.sort,
        required this.phone});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    xmlId = json['xml_id'];
    name = json['name'];
    nameUz = json['name_uz'];
    mapZoom = json['map_zoom'];
    lat = json['lat'];
    lon = json['lon'];
    active = json['active'];
    sort = json['sort'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['xml_id'] = this.xmlId;
    data['name'] = this.name;
    data['name_uz'] = this.nameUz;
    data['map_zoom'] = this.mapZoom;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['active'] = this.active;
    data['sort'] = this.sort;
    data['phone'] = this.phone;
    return data;
  }

  // String get cityPlaceholder {
  //   City? currentCity = Hive.box<City>('currentCity').get('currentCity');
  //   if (currentCity == null) {
  //     return 'Ваш город';
  //   }
  //
  //   return currentCity!.name;
  // }
  //
  // void setCurrentCity(City c) {
  //   Box<City> transaction = Hive.box<City>('currentCity');
  //   transaction.put('currentCity', c);
  // }
}
