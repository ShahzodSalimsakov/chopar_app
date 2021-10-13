// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CurrentCity on _CurrentCity, Store {
  Computed<String>? _$cityPlaceholderComputed;

  @override
  String get cityPlaceholder => (_$cityPlaceholderComputed ??= Computed<String>(
          () => super.cityPlaceholder,
          name: '_CurrentCity.cityPlaceholder'))
      .value;

  final _$cityAtom = Atom(name: '_CurrentCity.city');

  @override
  City? get city {
    _$cityAtom.reportRead();
    return super.city;
  }

  @override
  set city(City? value) {
    _$cityAtom.reportWrite(value, super.city, () {
      super.city = value;
    });
  }

  final _$_CurrentCityActionController = ActionController(name: '_CurrentCity');

  @override
  void setCurrentCity(City c) {
    final _$actionInfo = _$_CurrentCityActionController.startAction(
        name: '_CurrentCity.setCurrentCity');
    try {
      return super.setCurrentCity(c);
    } finally {
      _$_CurrentCityActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
city: ${city},
cityPlaceholder: ${cityPlaceholder}
    ''';
  }
}
