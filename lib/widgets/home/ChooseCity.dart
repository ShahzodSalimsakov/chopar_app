import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/modal_fit.dart';
import 'package:chopar_app/store/city.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChooseCity extends HookWidget {
  Widget cityModal(BuildContext context, List<City> cities) {
    City? currentCity = Hive.box<City>('currentCity').get('currentCity');
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
                      title: Text(
                        cities[index].name,
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: currentCity != null &&
                              currentCity.id == cities[index].id
                          ? const Icon(
                              Icons.check,
                              color: Colors.yellow,
                            )
                          : null,
                      selected: currentCity != null &&
                          currentCity.id == cities[index].id,
                      onTap: () {
                        Box<City> transaction = Hive.box<City>('currentCity');
                        transaction.put('currentCity', cities[index]);
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
      var url = Uri.https('api.choparpizza.uz', '/api/cities/public');
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<City> cityList = List<City>.from(
            json['data'].map((m) => new City.fromJson(m)).toList());
        cities.value = cityList;
        City? currentCity = Hive.box<City>('currentCity').get('currentCity');
        if (currentCity == null) {
          Hive.box<City>('currentCity').put('currentCity', cityList[0]);
        }
      }
    }

    useEffect(() {
      loadCities();
    }, []);

    return ValueListenableBuilder<Box<City>>(
        valueListenable: Hive.box<City>('currentCity').listenable(),
        builder: (context, box, _) {
          City? currentCity = box.get('currentCity');
          return ListTile(
              contentPadding: EdgeInsets.only(left: 2),
              title: Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      currentCity != null ? currentCity.name : 'Ваш город',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
              onTap: () => showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => cityModal(context, cities.value),
                  ));
        });
  }
}
