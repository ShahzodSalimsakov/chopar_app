import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/modal_fit.dart';
import 'package:chopar_app/store/city.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChooseCity extends HookWidget {
  final CurrentCity _currentCity = CurrentCity();

  Widget cityModal(BuildContext context, List<City> cities) {
    return Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  'Выберите город',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cities[index].name, style: TextStyle(color: Colors.black),),
                      trailing: _currentCity.city!.id == cities[index].id ? const Icon(Icons.check, color: Colors.yellow,) : null,

                      selected: _currentCity.city!.id == cities[index].id,
                      onTap: () {
                        _currentCity.setCurrentCity(cities[index]);
                        Navigator.of(context).pop();
                      },
                    );
                  }),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final cities = useState<List<City>>(List<City>.empty());

    Future<void> loadCities() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.hq.fungeek.net', '/api/cities/public');
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<City> cityList = List<City>.from(
            json['data'].map((m) => new City.fromJson(m)).toList());
        cities.value = cityList;
        if (_currentCity.city == null) {
          _currentCity.setCurrentCity(cityList[0]);
        }

      }
    }

    useEffect(() {
      loadCities();
    }, []);

    return Observer(
        builder: (_) => ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentCity.cityPlaceholder,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
            onTap: () => showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => cityModal(context, cities.value),
                )));
  }
}
