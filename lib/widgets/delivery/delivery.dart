import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/my_address.dart';
import 'package:chopar_app/models/stock.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/models/yandex_geo_data.dart';
import 'package:chopar_app/utils/debouncer.dart';
import 'package:chopar_app/widgets/delivery/delivery_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:easy_localization/easy_localization.dart';

class DeliveryWidget extends HookWidget {
  final _debouncer = Debouncer(milliseconds: 500);
  final TextEditingController queryController = TextEditingController();
  late Point currentPoint;

  @override
  Widget build(BuildContext context) {
    final currentCity = Hive.box<City>('currentCity').get('currentCity');
    final suggestedData =
        useState<List<YandexGeoData>>(List<YandexGeoData>.empty());
    final queryText = useState<String>('');
    final myAddresses = useState<List<MyAddress>>(List<MyAddress>.empty());
    useState<YandexGeoData?>(null);
    final loading = useState(false);
    Future<void> getMyAddresses() async {
      Box box = Hive.box<User>('user');
      User? currentUser = box.get('user');
      if (currentUser != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${currentUser.userToken}'
        };
        var url = Uri.https('api.choparpizza.uz', '/api/address/my_addresses');
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          List<MyAddress> addressList = List<MyAddress>.from(
              json['data'].map((m) => new MyAddress.fromJson(m)).toList());
          myAddresses.value = addressList;
        }
      }
    }

    Future<void> getSuggestions(String query) async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      String prefix = '${currentCity!.name}, ';
      query = '${query}${prefix}';
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
        if (myAddresses.value.length == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16),
                Text(
                  'Введите текст запроса',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () async {
                      loading.value = true;
                      MyAddress address = myAddresses.value[index];
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => DeliveryModal(
                      //           geoData: suggestedData.value[index],
                      //         )));
                      if (address.lat != null) {
                        Map<String, String> requestHeaders = {
                          'Content-type': 'application/json',
                          'Accept': 'application/json'
                        };
                        var url = Uri.https('api.choparpizza.uz', 'api/geocode',
                            {'lat': address.lat, 'lon': address.lon});
                        var response =
                            await http.get(url, headers: requestHeaders);
                        if (response.statusCode == 200) {
                          var json = jsonDecode(response.body);
                          YandexGeoData geoData =
                              YandexGeoData.fromJson(json['data']);

                          geoData.addressItems?.forEach((item) async {
                            if (item.kind == 'province' ||
                                item.kind == 'area') {
                              Map<String, String> requestHeaders = {
                                'Content-type': 'application/json',
                                'Accept': 'application/json'
                              };
                              var url = Uri.https(
                                  'api.choparpizza.uz', '/api/cities/public');
                              var response =
                                  await http.get(url, headers: requestHeaders);
                              if (response.statusCode == 200) {
                                var json = jsonDecode(response.body);
                                List<City> cityList = List<City>.from(
                                    json['data']
                                        .map((m) => City.fromJson(m))
                                        .toList());
                                for (var element in cityList) {
                                  if (element.name == item.name) {
                                    Hive.box<City>('currentCity')
                                        .put('currentCity', element);
                                  }
                                }
                              }
                            }
                          });
                        }

                        DeliveryLocationData deliveryData =
                            DeliveryLocationData(
                                house: address.house ?? '',
                                flat: address.flat ?? '',
                                entrance: address.entrance ?? '',
                                doorCode: address.doorCode ?? '',
                                lat: double.parse(address.lat!),
                                lon: double.parse(address.lon!),
                                address: address.address ?? '');
                        final Box<DeliveryLocationData> deliveryLocationBox =
                            Hive.box<DeliveryLocationData>(
                                'deliveryLocationData');
                        deliveryLocationBox.put(
                            'deliveryLocationData', deliveryData);
                        Box<DeliveryType> box =
                            Hive.box<DeliveryType>('deliveryType');
                        DeliveryType newDeliveryType = new DeliveryType();
                        newDeliveryType.value = DeliveryTypeEnum.deliver;
                        box.put('deliveryType', newDeliveryType);

                        // Map<String, String> requestHeaders = {
                        //   'Content-type': 'application/json',
                        //   'Accept': 'application/json'
                        // };

                        url = Uri.https('api.choparpizza.uz',
                            'api/terminals/find_nearest', {
                          'lat': address.lat!.toString(),
                          'lon': address.lon!.toString()
                        });
                        response = await http.get(url, headers: requestHeaders);
                        if (response.statusCode == 200) {
                          var json = jsonDecode(response.body);
                          List<Terminals> terminal = List<Terminals>.from(
                              json['data']['items']
                                  .map((m) => new Terminals.fromJson(m))
                                  .toList());
                          Box<Terminals> transaction =
                              Hive.box<Terminals>('currentTerminal');
                          if (terminal.length > 0) {
                            transaction.put('currentTerminal', terminal[0]);

                            var stockUrl = Uri.https(
                                'api.choparpizza.uz',
                                'api/terminals/get_stock',
                                {'terminal_id': terminal[0].id.toString()});
                            var stockResponse = await http.get(stockUrl,
                                headers: requestHeaders);
                            if (stockResponse.statusCode == 200) {
                              var json = jsonDecode(stockResponse.body);
                              Stock newStockData = new Stock(
                                  prodIds: new List<int>.from(json[
                                      'data']) /* json['data'].map((id) => id as int).toList()*/);
                              Box<Stock> box = Hive.box<Stock>('stock');
                              box.put('stock', newStockData);
                            }
                          }
                          loading.value = false;
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    title: loading.value == false
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.bookmark_border_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 15),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    myAddresses.value[index].label != null
                                        ? Text(
                                            myAddresses.value[index].label
                                                    ?.toUpperCase() ??
                                                '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ))
                                        : SizedBox(height: 3),
                                    SizedBox(height: 4),
                                    Text(myAddresses.value[index].address ?? '',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: myAddresses
                                                        .value[index].label !=
                                                    null
                                                ? Colors.grey.shade700
                                                : Colors.black)),
                                    SizedBox(height: 2),
                                    Text(
                                      myAddresses.value[index].house != null &&
                                              myAddresses.value[index].house!
                                                  .isNotEmpty
                                          ? "Дом ${myAddresses.value[index].house}" +
                                              (myAddresses.value[index].flat !=
                                                          null &&
                                                      myAddresses.value[index]
                                                          .flat!.isNotEmpty
                                                  ? ", кв. ${myAddresses.value[index].flat}"
                                                  : "")
                                          : "",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber[700],
                            ),
                          ));
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: loading.value == true ? 1 : myAddresses.value.length);
        }
      } else if (suggestedData.value.length == 0) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 48,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16),
              Text(
                'Ничего не найдено',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Попробуйте изменить запрос',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      } else {
        return ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliveryModal(
                                geoData: suggestedData.value[index],
                              )));
                },
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  suggestedData.value[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  suggestedData.value[index].description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: suggestedData.value.length);
      }
    }

    useEffect(() {
      getMyAddresses();
      return null;
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
        title: Text(tr('delivery_address'), style: TextStyle(fontSize: 20)),
      ),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.yellow.shade600,
                    size: 24,
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
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                        prefixIcon: Container(
                          padding: EdgeInsets.only(right: 5),
                          child: Text(
                            '${currentCity!.name}, ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(minWidth: 0, minHeight: 0),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 24,
                    child: VerticalDivider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                      width: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryModal()));
                    },
                    child: Text(
                      'Карта',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
