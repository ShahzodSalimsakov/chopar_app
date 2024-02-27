import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/stock.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/widgets/delivery/terminals_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:dart_date/dart_date.dart';

class Pickup extends HookWidget {
  late YandexMapController controller;
  late YandexMap map;

  @override
  Widget build(BuildContext context) {
    final terminals = useState<List<Terminals>>(List<Terminals>.empty());
    City? currentCity = Hive.box<City>('currentCity').get('currentCity');

    Future<void> getTerminals() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      bool serviceEnabled;
      LocationPermission permission;
      var formData = {'city_id': currentCity?.id.toString()};
      var url =
          Uri.https('api.choparpizza.uz', 'api/terminals/pickup', formData);
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Terminals> terminal = List<Terminals>.from(
            json['data'].map((m) => new Terminals.fromJson(m)).toList());
        DateTime currentTime = DateTime.now();
        List<Terminals> resultTerminals = [];
        terminal.forEach((t) {
          if (currentTime.weekday >= 1 && currentTime.weekday < 5) {
            if (t.openWork == null) {
              return null;
            } else {
              DateTime openWork = Date.parse(t.openWork!);
              openWork = openWork.toLocal();
              openWork = openWork.setDay(currentTime.day);
              openWork = openWork.setMonth(currentTime.month);
              openWork = openWork.setYear(currentTime.year);
              DateTime closeWork = Date.parse(t.closeWork!);
              closeWork = closeWork.toLocal();
              closeWork = closeWork.setDay(currentTime.day);
              closeWork = closeWork.setMonth(currentTime.month);
              closeWork = closeWork.setYear(currentTime.year);

              if (closeWork.getHours < openWork.getHours) {
                if (currentTime < openWork && currentTime > closeWork) {
                  t.isWorking = false;
                } else {
                  t.isWorking = true;
                }
              } else {
                if (currentTime < openWork || currentTime > closeWork) {
                  t.isWorking = false;
                } else {
                  t.isWorking = true;
                }
              }
            }
          } else {
            if (t.openWeekend == null) {
              return null;
            } else {
              DateTime openWork = Date.parse(t.openWeekend!);
              openWork = openWork.toLocal();
              openWork = openWork.setDay(currentTime.day);
              openWork = openWork.setMonth(currentTime.month);
              openWork = openWork.setYear(currentTime.year);
              DateTime closeWork = Date.parse(t.closeWeekend!);
              closeWork = closeWork.toLocal();
              closeWork = closeWork.setDay(currentTime.day);
              closeWork = closeWork.setMonth(currentTime.month);
              closeWork = closeWork.setYear(currentTime.year);

              if (closeWork.getHours < openWork.getHours) {
                if (currentTime < openWork && currentTime > closeWork) {
                  t.isWorking = false;
                } else {
                  t.isWorking = true;
                }
              } else {
                if (currentTime < openWork || currentTime > closeWork) {
                  t.isWorking = false;
                } else {
                  t.isWorking = true;
                }
              }
            }
          }
          resultTerminals.add(t);
        });

        terminals.value = resultTerminals;
      }

      bool isLocationSet = true;

      final Box<DeliveryLocationData> deliveryLocationBox =
          Hive.box<DeliveryLocationData>('deliveryLocationData');
      DeliveryLocationData? deliveryData =
          deliveryLocationBox.get('deliveryLocationData');

      if (deliveryData == null) {
        isLocationSet = false;
      } else if (deliveryData.lat == null) {
        isLocationSet = false;
      }
      var currentPosition;

      if (!isLocationSet) {
        // Test if location services are enabled.
        serviceEnabled = await Geolocator.isLocationServiceEnabled();

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          serviceEnabled = false;
        }

        if (permission == LocationPermission.deniedForever) {
          serviceEnabled = false;
        }

        if (!serviceEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Включите геолокацию, чтобы увидеть ближайшие филиалы первыми')));
        }
        try {
          if (serviceEnabled) {
            currentPosition = await Geolocator.getCurrentPosition();
          }
        } catch (e) {}
      } else {
        currentPosition = new Position(
            longitude: deliveryData!.lon!,
            latitude: deliveryData!.lat!,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0, altitudeAccuracy: 0.0, headingAccuracy: 0.0);
      }

      if (currentPosition != null) {
        formData = {
          'city_id': currentCity?.id.toString(),
          'lat': currentPosition.latitude.toString(),
          'lon': currentPosition.longitude.toString()
        };
      }

      url = Uri.https('api.choparpizza.uz', 'api/terminals/pickup', formData);
      response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Terminals> terminal = List<Terminals>.from(
            json['data'].map((m) => new Terminals.fromJson(m)).toList());
        DateTime currentTime = DateTime.now();
        List<Terminals> resultTerminals = [];
        terminal.forEach((t) {
          if (currentTime.weekday >= 1 && currentTime.weekday < 5) {
            if (t.openWork == null) {
              return null;
            } else {
              DateTime openWork = Date.parse(t.openWork!);
              openWork = openWork.toLocal();
              openWork = openWork.setDay(currentTime.day);
              openWork = openWork.setMonth(currentTime.month);
              openWork = openWork.setYear(currentTime.year);
              DateTime closeWork = Date.parse(t.closeWork!);
              closeWork = closeWork.toLocal();
              closeWork = closeWork.setDay(currentTime.day);
              closeWork = closeWork.setMonth(currentTime.month);
              closeWork = closeWork.setYear(currentTime.year);

              if (closeWork.getHours < openWork.getHours) {
                if (currentTime < openWork && currentTime > closeWork) {
                  t.isWorking = false;
                } else {
                  t.isWorking = true;
                }
              } else {
                if (currentTime < openWork || currentTime > closeWork) {
                  t.isWorking = false;
                } else {
                  t.isWorking = true;
                }
              }
            }
          } else {
            if (t.openWeekend == null) {
              return null;
            } else {
              DateTime openWork = Date.parse(t.openWeekend!);
              openWork = openWork.toLocal();
              openWork = openWork.setDay(currentTime.day);
              openWork = openWork.setMonth(currentTime.month);
              openWork = openWork.setYear(currentTime.year);
              DateTime closeWork = Date.parse(t.closeWeekend!);
              closeWork = closeWork.toLocal();
              closeWork = closeWork.setDay(currentTime.day);
              closeWork = closeWork.setMonth(currentTime.month);
              closeWork = closeWork.setYear(currentTime.year);

              if (closeWork.getHours < openWork.getHours) {
                if (currentTime < openWork && currentTime > closeWork) {
                  t.isWorking = false;
                } else {
                  t.isWorking = true;
                }
              } else {
                if (currentTime < openWork || currentTime > closeWork) {
                  t.isWorking = false;
                } else {
                  t.isWorking = true;
                }
              }
            }
          }
          resultTerminals.add(t);
        });

        terminals.value = resultTerminals;
      }
    }

    useEffect(() {
      getTerminals();
    }, []);

    return ValueListenableBuilder<Box<Terminals>>(
        valueListenable: Hive.box<Terminals>('currentTerminal').listenable(),
        builder: (context, box, _) {
          Terminals? currentTerminal =
              Hive.box<Terminals>('currentTerminal').get('currentTerminal');
          return SafeArea(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              width: 1.0,
                                              color: Colors.yellow.shade600)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      25.0)))),
                                  child: Text(
                                    'Списком',
                                    style: TextStyle(
                                        color: Colors.yellow.shade600),
                                  ))),
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                              child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TerminalsModal(
                                                    terminals:
                                                        terminals.value)));
                                  },
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              width: 1.0, color: Colors.grey)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      25.0)))),
                                  child: Text(
                                    'На карте',
                                    style: TextStyle(color: Colors.grey),
                                  )))
                        ],
                      ),
                      Expanded(
                          child: Container(
                        child: ListView.builder(
                            itemCount: terminals.value.length,
                            itemBuilder: (context, index) {
                              var terminal = terminals.value[index];
                              return InkWell(
                                  onTap: () async {
                                    if (!terminal.isWorking!) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Данный терминал сейчас не работает')));
                                      return;
                                    }
                                    Box<Terminals> transaction =
                                        Hive.box<Terminals>('currentTerminal');
                                    transaction.put(
                                        'currentTerminal', terminal);

                                    Map<String, String> requestHeaders = {
                                      'Content-type': 'application/json',
                                      'Accept': 'application/json'
                                    };

                                    var stockUrl = Uri.https(
                                        'api.choparpizza.uz',
                                        'api/terminals/get_stock', {
                                      'terminal_id': terminal.id.toString()
                                    });
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
                                  },
                                  child: Opacity(
                                    opacity: terminal.isWorking! ? 1 : 0.5,
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: currentTerminal?.id ==
                                                      terminal.id
                                                  ? Colors.yellow.shade600
                                                  : Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: currentTerminal
                                                                      ?.id ==
                                                                  terminal.id
                                                              ? Colors.yellow
                                                                  .shade600
                                                              : Colors.grey,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(40),
                                                          color: currentTerminal
                                                                      ?.id ==
                                                                  terminal.id
                                                              ? Colors.yellow
                                                                  .shade600
                                                              : Colors.grey),
                                                      margin: EdgeInsets.all(3),
                                                      width: 10,
                                                      height: 10),
                                                ),
                                                SizedBox(
                                                  width: 12,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      terminals.value[index]
                                                              .name ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                            terminals
                                                                    .value[
                                                                        index]
                                                                    .desc ??
                                                                '',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                            overflow:
                                                                TextOverflow
                                                                    .clip,
                                                            softWrap: false,
                                                          )),
                                                        ],
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        )),
                                  ));
                            }),
                      ))
                    ],
                  )));
        });
  }
}
