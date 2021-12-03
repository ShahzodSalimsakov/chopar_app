import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/yandex_geo_data.dart';
import 'package:chopar_app/utils/debouncer.dart';
import 'package:chopar_app/widgets/delivery/delivery_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class DeliveryWidget extends HookWidget {
  final _debouncer = Debouncer(milliseconds: 500);
  final TextEditingController queryController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentCity = Hive.box<City>('currentCity').get('currentCity');
    final suggestedData =
        useState<List<YandexGeoData>>(List<YandexGeoData>.empty());
    final queryText = useState<String>('');

    Future<void> getSuggestions(String query) async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https(
          'api.choparpizza.uz', 'api/geocode/query', {'query': query});
      queryText.value = query;
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<YandexGeoData> terminal = List<YandexGeoData>.from(
            json['data'].map((m) => new YandexGeoData.fromJson(m)).toList());
        suggestedData.value = terminal;
      }
    }

    Widget renderItems(BuildContext context) {
      if (queryText.value.length == 0) {
        return Center(
          child: Text('Введите текст запроса'),
        );
      } else if (suggestedData.value.length == 0) {
        return Center(
          child: Text('Ничего не найдено'),
        );
      } else {
        return ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliveryModal(
                                geoData: suggestedData.value[index],
                              )));
                },
                title: Text(suggestedData.value[index].title),
                subtitle: Text(suggestedData.value[index].description),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: suggestedData.value.length);
      }
    }

    useEffect((){
      String prefix = '${currentCity!.name}, ';
      queryController.text = prefix;
      queryController.selection = TextSelection.fromPosition(TextPosition(offset: prefix.length));
    }, []);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text('Укажите адрес доставки', style: TextStyle(fontSize: 20)),
      ),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            Container(
              height: 70,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.yellow.shade600,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextField(
                      controller: queryController,

                      onChanged: (String val) {
                        _debouncer.run(() => getSuggestions(val));
                      },
                      decoration: InputDecoration(
                        hintText: 'Введите адрес',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  VerticalDivider(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryModal()));
                    },
                    child: Text('Карта'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(child: renderItems(context))
          ],
        ),
      )),
    );
  }
}
