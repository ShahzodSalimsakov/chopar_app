import 'package:chopar_app/models/city.dart';
import 'package:mobx/mobx.dart';
part 'city.g.dart';
class CurrentCity = _CurrentCity with _$CurrentCity;

abstract class _CurrentCity with Store {
  _CurrentCity();
  @observable
  City? city;

  @computed
  String get cityPlaceholder {
    if (city == null) {
      return 'Ваш город';
    }

    return city!.name;
  }

  @action
  void setCurrentCity(City c) {
    city = c;
  }
}