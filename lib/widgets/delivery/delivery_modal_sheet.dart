import 'dart:convert';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/stock.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/yandex_geo_data.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

import '../../models/city.dart';
import '../../models/user.dart';

Map<String, String> terminalFoundErrors = {
  "nearest_terminal_not_found": "Ближайший к Вам филиал не найден",
  "nearest_terminals_is_closed": "Ближайший к Вам филиал закрыт"
};

class DeliveryModalSheet extends HookWidget {
  late Point currentPoint;

  DeliveryModalSheet({required this.currentPoint});

  Widget build(BuildContext context) {
    final _formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final geoData = useState<YandexGeoData?>(null);
    final Box<DeliveryLocationData> deliveryLocationBox =
        Hive.box<DeliveryLocationData>('deliveryLocationData');
    DeliveryLocationData? deliveryLocationData =
        deliveryLocationBox.get('deliveryLocationData');
    final isShowForm = useState<bool>(false);
    final houseText = useState<String>(deliveryLocationData?.house ?? '');
    final flatText = useState<String>(deliveryLocationData?.flat ?? '');
    final entranceText = useState<String>(deliveryLocationData?.entrance ?? '');
    final doorCodeText = useState<String>(deliveryLocationData?.doorCode ?? '');
    final addressLabel = useState<String>(deliveryLocationData?.label ?? '');

    var currentTerminal = useState<Terminals?>(null);
    var notFoundText = useState<String>('nearest_terminal_not_found');

    Future<void> getPointData() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.choparpizza.uz', 'api/geocode', {
        'lat': currentPoint.latitude.toString(),
        'lon': currentPoint.longitude.toString()
      });
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        geoData.value = YandexGeoData.fromJson(json['data']);

        var url =
            Uri.https('api.choparpizza.uz', 'api/terminals/find_nearest', {
          'lat': currentPoint!.latitude.toString(),
          'lon': currentPoint!.longitude.toString()
        });
        response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          List<Terminals> terminal = List<Terminals>.from(
              json['data']['items'].map((m) => Terminals.fromJson(m)).toList());
          notFoundText.value = json['data']['errorMessage'];
          if (terminal.isNotEmpty) {
            currentTerminal.value = terminal[0];
          } else {
            currentTerminal.value = null;
          }
        } else {
          currentTerminal.value = null;
          notFoundText.value = 'nearest_terminal_not_found';
        }
      }
    }

    List<Widget> getSheetColumns() {
      if (isShowForm.value) {
        return [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.only(top: 3, bottom: 6),
                height: 3,
                width: 45,
                decoration: BoxDecoration(color: Colors.grey),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ListTile(
                  // contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  leading: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.yellow.shade600, width: 1),
                        borderRadius: BorderRadius.circular(40)),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.yellow.shade600),
                        margin: EdgeInsets.all(3),
                        width: 10,
                        height: 10),
                  ),
                  title: Text(geoData.value?.title ?? ''),
                  subtitle: Text(geoData.value?.description ?? ''),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: 1),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15), child: Divider()),
          Form(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormBuilderTextField(
                      name: 'house',
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Дом'),
                      initialValue: houseText.value,
                    ),
                    FormBuilderTextField(
                      name: 'flat',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Квартира'),
                      initialValue: flatText.value,
                    ),
                    FormBuilderTextField(
                      name: 'entrance',
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Подъезд'),
                      initialValue: entranceText.value,
                    ),
                    FormBuilderTextField(
                      name: 'doorCode',
                      // keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Домофон'),
                      initialValue: doorCodeText.value,
                    ),
                    FormBuilderTextField(
                      name: 'addressLabel',
                      // keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Название адреса'),
                      initialValue: addressLabel.value,
                    ),
                  ],
                )),
          )),
          Container(
            padding: EdgeInsets.all(15),
            child: DefaultStyledButton(
              width: MediaQuery.of(context).size.width,
              onPressed: () async {
                _formKey.currentState!.save();
                var formValue = _formKey.currentState!.value;
                DeliveryLocationData deliveryData = DeliveryLocationData(
                    house: formValue['house'] ?? '',
                    flat: formValue['flat'] ?? '',
                    entrance: formValue['entrance'] ?? '',
                    doorCode: formValue['doorCode'] ?? '',
                    label: formValue['addressLabel'] ?? '',
                    lat: currentPoint.latitude,
                    lon: currentPoint.longitude,
                    address: geoData.value?.formatted ?? '');

                geoData.value?.addressItems?.forEach((item) async {
                  if (item.kind == 'province' || item.kind == 'area') {
                    Map<String, String> requestHeaders = {
                      'Content-type': 'application/json',
                      'Accept': 'application/json'
                    };
                    var url =
                        Uri.https('api.choparpizza.uz', '/api/cities/public');
                    var response = await http.get(url, headers: requestHeaders);
                    if (response.statusCode == 200) {
                      var json = jsonDecode(response.body);
                      List<City> cityList = List<City>.from(
                          json['data'].map((m) => City.fromJson(m)).toList());
                      for (var element in cityList) {
                        if (element.name == item.name) {
                          Hive.box<City>('currentCity')
                              .put('currentCity', element);
                        }
                      }
                    }
                  }
                });
                deliveryLocationBox.put('deliveryLocationData', deliveryData);
                Map<String, String> requestHeaders = {
                  'Content-type': 'application/json',
                  'Accept': 'application/json'
                };

                var url = Uri.https(
                    'api.choparpizza.uz', 'api/terminals/find_nearest', {
                  'lat': currentPoint.latitude.toString(),
                  'lon': currentPoint.longitude.toString()
                });
                var response = await http.get(url, headers: requestHeaders);
                if (response.statusCode == 200) {
                  var json = jsonDecode(response.body);
                  List<Terminals> terminal = List<Terminals>.from(json['data']
                          ['items']
                      .map((m) => new Terminals.fromJson(m))
                      .toList());
                  Box<Terminals> transaction =
                      Hive.box<Terminals>('currentTerminal');
                  transaction.put('currentTerminal', terminal[0]);

                  var stockUrl = Uri.https(
                      'api.choparpizza.uz',
                      'api/terminals/get_stock',
                      {'terminal_id': terminal[0].id.toString()});
                  var stockResponse =
                      await http.get(stockUrl, headers: requestHeaders);
                  if (stockResponse.statusCode == 200) {
                    var json = jsonDecode(stockResponse.body);
                    Stock newStockData = new Stock(
                        prodIds: new List<int>.from(json[
                            'data']) /* json['data'].map((id) => id as int).toList()*/);
                    Box<Stock> box = Hive.box<Stock>('stock');
                    box.put('stock', newStockData);
                  }

                  Box<DeliveryType> box =
                      Hive.box<DeliveryType>('deliveryType');
                  DeliveryType newDeliveryType = new DeliveryType();
                  newDeliveryType.value = DeliveryTypeEnum.deliver;
                  box.put('deliveryType', newDeliveryType);

                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop();
                }

                Box box = Hive.box<User>('user');
                User currentUser = box.get('user');
                if (currentUser != null) {
                  Map<String, String> requestHeaders = {
                    'Content-type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': 'Bearer ${currentUser.userToken}'
                  };
                  var url = Uri.https('api.choparpizza.uz', '/api/address/new');
                  var formData = {
                    'lat': currentPoint.latitude.toString(),
                    'lon': currentPoint.longitude.toString(),
                    "label": formValue['addressLabel'] ?? '',
                    "addressId": '',
                    "house": formValue['house'] ?? '',
                    "flat": formValue['flat'] ?? '',
                    "entrance": formValue['entrance'] ?? '',
                    "door_code": formValue['doorCode'] ?? '',
                    "address": geoData.value?.formatted ?? ''
                  };
                  var response = await http.post(url,
                      headers: requestHeaders, body: jsonEncode(formData));
                  // if (response.statusCode == 200) {
                  //   var json = jsonDecode(response.body);
                  // } else {
                  //   print(response.body);
                  // }
                }
              },
              text: 'Готово',
            ),
          )
        ];
      } else {
        return [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.only(top: 3, bottom: 6),
                height: 3,
                width: 45,
                decoration: BoxDecoration(color: Colors.grey),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ListTile(
                  // contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  leading: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.yellow.shade600, width: 1),
                        borderRadius: BorderRadius.circular(40)),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.yellow.shade600),
                        margin: EdgeInsets.all(3),
                        width: 10,
                        height: 10),
                  ),
                  title: Text(currentTerminal.value == null
                      ? terminalFoundErrors[notFoundText.value]!
                      : geoData.value!.title!),
                  subtitle: Text(currentTerminal.value == null
                      ? ''
                      : geoData.value!.description!),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: 1),
          Container(
            margin: EdgeInsets.all(15),
            child: DefaultStyledButton(
                width: MediaQuery.of(context).size.width,
                onPressed: () {
                  if (currentTerminal.value == null) {
                    return;
                  }
                  houseText.value = '';
                  flatText.value = '';
                  entranceText.value = '';
                  doorCodeText.value = '';
                  addressLabel.value = '';
                  geoData.value!.addressItems!.forEach((element) {
                    if (element.kind == 'house') {
                      houseText.value = element.name;
                    }
                  });
                  isShowForm.value = true;
                },
                text: 'Я здесь'),
          ),
        ];
      }
    }

    useEffect(() {
      getPointData();
    }, []);

    return Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [...getSheetColumns()],
            ),
          ),
        ));
  }
}
