import 'dart:convert';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/yandex_geo_data.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

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
                  ],
                )),
          )),
          Container(
            padding: EdgeInsets.all(15),
            child: DefaultStyledButton(
              width: MediaQuery.of(context).size.width,
              onPressed: () async {
                _formKey.currentState!.save();
                print(_formKey.currentState!.value);
                var formValue = _formKey.currentState!.value;
                DeliveryLocationData deliveryData = DeliveryLocationData(
                    house: formValue['house'] ?? '',
                    flat: formValue['flat'] ?? '',
                    entrance: formValue['entrance'] ?? '',
                    doorCode: formValue['doorCode'] ?? '',
                    lat: currentPoint.latitude,
                    lon: currentPoint.longitude,
                    address: geoData.value?.formatted ?? '');
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
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop();
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
                  title: Text(geoData.value?.title ?? ''),
                  subtitle: Text(geoData.value?.description ?? ''),
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
                  houseText.value = '';
                  flatText.value = '';
                  entranceText.value = '';
                  doorCodeText.value = '';
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
