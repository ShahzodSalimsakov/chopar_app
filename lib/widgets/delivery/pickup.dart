import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/widgets/delivery/control_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Pickup extends HookWidget {
  late YandexMapController controller;
  late YandexMap map;

  final Placemark _placemarkWithDynamicIcon = Placemark(
    point: Point(latitude: 41.311081, longitude: 69.240562),
    onTap: (Placemark self, Point point) => print('Tapped me at $point'),
    style: PlacemarkStyle(
      opacity: 0.95,
      iconName: 'assets/images/place.png',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final terminals = useState<List<Terminals>>(List<Terminals>.empty());
    City? currentCity = Hive.box<City>('currentCity').get('currentCity');

    Future<void> getTerminals() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.hq.fungeek.net', 'api/terminals/pickup', {
        'city_id': currentCity?.id.toString()
      });
      print('api/terminals/pickup?city_id=${currentCity?.id}');
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Terminals> terminal = List<Terminals>.from(
            json['data'].map((m) => new Terminals.fromJson(m)).toList());
        print(terminal);
        terminals.value = terminal;
      }
    }

    useEffect(() {
      getTerminals();
    }, []);

    print(terminals.value);
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
                                side: MaterialStateProperty.all(BorderSide(
                                    width: 1.0, color: Colors.yellow.shade600)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)))),
                            child: Text(
                              'Списком',
                              style: TextStyle(color: Colors.yellow.shade600),
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
                                      builder: (context) => Scaffold(
                                              body: Stack(children: [
                                            Expanded(
                                                child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: YandexMap())),
                                            Positioned(
                                                top: 50,
                                                child: RawMaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  elevation: 2.0,
                                                  fillColor: Colors.white,
                                                  child: Icon(Icons.close,
                                                      size: 14.0,
                                                      color: Colors.black),
                                                  padding: EdgeInsets.all(10.0),
                                                  shape: CircleBorder(),
                                                )),
                                            Positioned(
                                                right: 0,
                                                bottom: 40,
                                                child: RawMaterialButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        context: context,
                                                        builder: (context) {
                                                          return Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          33),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .control_point,
                                                                        color: Colors
                                                                            .yellow
                                                                            .shade700,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            19,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Максим Горький-Фэмили',
                                                                            style:
                                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'улица Буюк Ипак Йули, 2 Ориентир: Davr Bank',
                                                                            style:
                                                                                TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            'График работы: 10:00 - 03:00',
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.green),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Divider(
                                                                    height: 1,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child: ElevatedButton(
                                                                          onPressed: () {},
                                                                          child: Text(
                                                                            'Забрать здесь',
                                                                            style:
                                                                                TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                                          ),
                                                                          style: ButtonStyle(
                                                                              backgroundColor: MaterialStateProperty.all(Colors.yellow.shade700),
                                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(22.0),
                                                                              )))))
                                                                ],
                                                              ));
                                                        });
                                                  },
                                                  elevation: 2.0,
                                                  fillColor: Colors.white,
                                                  child: Icon(Icons.navigation,
                                                      size: 23.0,
                                                      color: Colors
                                                          .yellow.shade700),
                                                  padding: EdgeInsets.all(10.0),
                                                  shape: CircleBorder(),
                                                )),

                                            // Expanded(
                                            //     child: SingleChildScrollView(
                                            //         child: Column(
                                            //           mainAxisSize: MainAxisSize.min,
                                            //             crossAxisAlignment: CrossAxisAlignment.center,
                                            //             children: <Widget>[
                                            //               const Text('Placemark with Binary Icon:'),
                                            //               Row(
                                            //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            //                 children: <Widget>[
                                            //                   ControlButton(
                                            //                       onPressed: () async {
                                            //                         await controller.addPlacemark(_placemarkWithDynamicIcon);
                                            //                       },
                                            //                       title: 'Add'
                                            //                   ),
                                            //                   ControlButton(
                                            //                       onPressed: () async {
                                            //                         await controller.removePlacemark(_placemarkWithDynamicIcon);
                                            //                       },
                                            //                       title: 'Remove'
                                            //                   ),ControlButton(
                                            //                       onPressed: () async {
                                            //                         final point = await controller.getUserTargetPoint();
                                            //                         print(point);
                                            //                       },
                                            //                       title: 'Get location'
                                            //                   ),
                                            //                 ],
                                            //               )
                                            //             ]
                                            //         )
                                            //     )
                                            // )
                                          ]))));
                            },
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    BorderSide(width: 1.0, color: Colors.grey)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)))),
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
                        return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          terminals.value[index].name ?? '',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(terminals.value[index].desc ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ));
                      }),
                ))
              ],
            )));
  }
}
