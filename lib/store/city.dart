import 'package:chopar_app/models/city.dart';
import 'package:hive/hive.dart';
part 'city.g.dart';

@HiveType(typeId: 0)
class CurrentCity {
  @HiveField(0)
  City? city;

  String get cityPlaceholder {
    CurrentCity? currentCity = Hive.box<CurrentCity>('currentCity').get('currentCity');
    if (currentCity == null) {
      return 'Ваш город';
    }

    return currentCity.city!.name;
  }

  void setCurrentCity(City c) {
    Box<CurrentCity> transaction = Hive.box<CurrentCity>('currentCity');
    CurrentCity currentCity = new CurrentCity();
    currentCity.city = c;
    transaction.put('currentCity', currentCity);
    city = c;
  }
}