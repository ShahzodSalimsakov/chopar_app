import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

class TerminalsModal extends StatefulWidget {
  final List<Terminals> terminals;

  const TerminalsModal({Key? key, required this.terminals}) : super(key: key);

  @override
  _TerminalModalState createState() => _TerminalModalState();
}

class _TerminalModalState extends State<TerminalsModal> {
  Terminals? _currentTerminal;
  late YandexMapController controller;
  final MapObjectId mapObjectCollectionId =
      const MapObjectId('map_object_collection');
  final animation =
      const MapAnimation(type: MapAnimationType.smooth, duration: 1.5);

  List<MapObject> mapObjects = [];

  bool zoomGesturesEnabled = true;

  showBottomSheet(Terminals terminal) {
    showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 33),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.control_point,
                    color: Colors.yellow.shade700,
                  ),
                  SizedBox(
                    width: 19,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        terminal.name ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        terminal.desc ?? '',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
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
                color: Colors.grey,
              ),
              SizedBox(
                height: 15,
              ),
              DefaultStyledButton(
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    Box<Terminals> transaction =
                        Hive.box<Terminals>('currentTerminal');
                    transaction.put('currentTerminal', terminal);
                    Navigator.of(context)
                      ..pop()
                      ..pop()
                      ..pop();
                  },
                  text: 'Забрать здесь')
            ],
          )),
    );
  }

  setCurrentTerminal(Terminals terminal) {
    if (terminal.isWorking!) {
      setState(() {
        _currentTerminal = terminal;
      });
      showBottomSheet(terminal);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Данный терминал сейчас не работает')));
    }
  }

  @override
  Widget build(BuildContext context) {
    Terminals? currentTerminal =
        Hive.box<Terminals>('currentTerminal').get('currentTerminal');
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(fit: StackFit.loose, children: [
        /*Expanded(
            child: */
        Container(
            padding: EdgeInsets.all(8),
            child: YandexMap(
                mapObjects: mapObjects,
                zoomGesturesEnabled: zoomGesturesEnabled,
                onMapCreated: (YandexMapController yandexMapController) async {
                  controller = yandexMapController;
                  Box<City> box = Hive.box<City>('currentCity');
                  City? currentCity = box.get('currentCity');
                  await controller.moveCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: Point(
                              latitude: double.parse(currentCity!.lat),
                              longitude: double.parse(currentCity.lon)),
                          zoom: 12)),
                      animation: animation);

                  List<PlacemarkMapObject> mapsList = <PlacemarkMapObject>[];

                  widget.terminals.forEach((element) async {
                    if (element.latitude != null) {
                      double scale = 2;
                      if (_currentTerminal != null &&
                          _currentTerminal?.id! == element.id) {
                        scale = 4;
                      }
                      if (currentTerminal != null &&
                          currentTerminal.id == element.id) {
                        scale = 4;
                      }

                      var _placemark = PlacemarkMapObject(
                          mapId: MapObjectId(element.id!),
                          point: Point(
                              latitude: double.parse(element.latitude!),
                              longitude: double.parse(element.longitude!)),
                          onTap: (PlacemarkMapObject self, Point point) =>
                              setCurrentTerminal(element),
                          opacity: 0.7,
                          direction: 90,
                          icon: PlacemarkIcon.single(PlacemarkIconStyle(
                              image: BitmapDescriptor.fromAssetImage(
                                  element.isWorking!
                                      ? 'images/place.png'
                                      : 'images/place_disabled.png'),
                              rotationType: RotationType.noRotation,
                              scale: scale,
                              anchor: Offset.fromDirection(1.1, 1))));

                      mapsList.add(_placemark);
                    }
                  });
                })) /*)*/,
        Positioned(
            top: 50,
            child: RawMaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(Icons.close, size: 14.0, color: Colors.black),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            )),
        Positioned(
            right: 0,
            bottom: 40,
            child: RawMaterialButton(
              onPressed: () async {
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
                  bool serviceEnabled;
                  LocationPermission permission;

                  // Test if location services are enabled.
                  serviceEnabled = await Geolocator.isLocationServiceEnabled();
                  if (!serviceEnabled) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Недостаточно прав для получения локации')));
                    return;
                  }

                  permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text('Недостаточно прав для получения локации')));
                      return;
                    }
                  }

                  if (permission == LocationPermission.deniedForever) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Недостаточно прав для получения локации')));
                    return;
                  }

                  currentPosition = await Geolocator.getCurrentPosition();
                } else {
                  currentPosition = new Position(
                      longitude: deliveryData!.lon!,
                      latitude: deliveryData.lat!,
                      timestamp: DateTime.now(),
                      accuracy: 0,
                      altitude: 0,
                      heading: 0,
                      speed: 0,
                      speedAccuracy: 0, altitudeAccuracy: 0.0, headingAccuracy: 0.0);
                }

                Map<String, String> requestHeaders = {
                  'Content-type': 'application/json',
                  'Accept': 'application/json'
                };
                var url = Uri.https(
                    'api.choparpizza.uz', 'api/terminals/find_nearest', {
                  'lat': currentPosition.latitude.toString(),
                  'lon': currentPosition.longitude.toString()
                });
                var response = await http.get(url, headers: requestHeaders);
                if (response.statusCode == 200) {
                  var json = jsonDecode(response.body);
                  List<Terminals> terminal = List<Terminals>.from(json['data']
                          ['items']
                      .map((m) => new Terminals.fromJson(m))
                      .toList());
                  showBottomSheet(terminal[0]);
                }
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: Icon(Icons.navigation,
                  size: 23.0, color: Colors.yellow.shade700),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            )),
      ]),
    ));
  }
}
