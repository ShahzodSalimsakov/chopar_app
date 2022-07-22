import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/yandex_geo_data.dart';
import 'package:chopar_app/widgets/delivery/delivery_modal_sheet.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:http/http.dart' as http;

class DeliveryModal extends StatefulWidget {
  final YandexGeoData? geoData;

  DeliveryModal({this.geoData});

  @override
  _DeliveryModalState createState() => _DeliveryModalState();
}

class _DeliveryModalState extends State<DeliveryModal> {
  late YandexMapController controller;
  final MapObjectId placemarkId = const MapObjectId('delivery_placemark');
  final MapObjectId mapObjectCollectionId =
      const MapObjectId('map_object_collection');
  final animation =
      const MapAnimation(type: MapAnimationType.smooth, duration: 1.5);

  List<MapObject> mapObjects = [];

  bool zoomGesturesEnabled = true;

  bool isLookingLocation = false;

  showBottomSheet(Point point) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => DeliveryModalSheet(currentPoint: point),
    );
  }

  @override
  Widget build(BuildContext context) {
    Terminals? currentTerminal =
        Hive.box<Terminals>('currentTerminal').get('currentTerminal');

    Future<void> lookForLocation() async {
      setState(() {
        isLookingLocation = true;
      });

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
              content: Text('Недостаточно прав для получения локации')));
          return;
        }

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Недостаточно прав для получения локации')));
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Недостаточно прав для получения локации')));
          return;
        }

        currentPosition = await Geolocator.getCurrentPosition();
      } else {
        currentPosition = new Position(
            longitude: deliveryData!.lon!,
            latitude: deliveryData!.lat!,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0);
      }

      var _placemark = PlacemarkMapObject(
        mapId: placemarkId,
        point: Point(
            latitude: currentPosition.latitude,
            longitude: currentPosition.longitude),
        // onTap: (Placemark self, Point point) =>
        //     setCurrentTerminal(element),
        icon: PlacemarkIcon.single(PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
                'assets/images/chosen_point.png'),
            rotationType: RotationType.noRotation,
            scale: 2,
            anchor: Offset.fromDirection(1.1, 1))),
      );
      List<MapObject> mapsList = <MapObject>[];
      mapsList.add(_placemark);
      setState(() {
        mapObjects = mapsList;
      });

      await controller.moveCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: Point(
                  latitude: currentPosition!.latitude,
                  longitude: currentPosition.longitude),
              zoom: 17)),
          animation: animation);
      showBottomSheet(Point(
          latitude: currentPosition.latitude,
          longitude: currentPosition.longitude));
      setState(() {
        isLookingLocation = false;
      });
    }

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
                setState(() {
                  isLookingLocation = true;
                });
                Box<City> box = Hive.box<City>('currentCity');
                City? currentCity = box.get('currentCity');
                await controller.moveCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: Point(
                            latitude: double.parse(currentCity!.lat),
                            longitude: double.parse(currentCity.lon)),
                        zoom: 12)),
                    animation: animation);

                if (widget.geoData != null) {
                  var _placemark = PlacemarkMapObject(
                    mapId: placemarkId,
                    point: Point(
                        latitude: double.parse(widget.geoData!.coordinates.lat),
                        longitude:
                            double.parse(widget.geoData!.coordinates.long)),
                    // onTap: (Placemark self, Point point) =>
                    //     setCurrentTerminal(element),
                    icon: PlacemarkIcon.single(PlacemarkIconStyle(
                        image: BitmapDescriptor.fromAssetImage(
                            'assets/images/chosen_point.png'),
                        rotationType: RotationType.noRotation,
                        scale: 2,
                        anchor: Offset.fromDirection(1.1, 1))),
                  );
                  List<MapObject> mapsList = <MapObject>[];
                  mapsList.add(_placemark);
                  setState(() {
                    mapObjects = mapsList;
                  });

                  await controller.moveCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: Point(
                              latitude:
                                  double.parse(widget.geoData!.coordinates.lat),
                              longitude: double.parse(
                                  widget.geoData!.coordinates.long)),
                          zoom: 17)),
                      animation: animation);
                } else {
                  bool serviceEnabled;
                  bool hasPermission = true;
                  LocationPermission permission;

                  // Test if location services are enabled.
                  serviceEnabled = await Geolocator.isLocationServiceEnabled();
                  if (!serviceEnabled) {
                    hasPermission = true;
                  }

                  permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                      hasPermission = false;
                    }
                  }

                  if (permission == LocationPermission.deniedForever) {
                    hasPermission = false;
                  }

                  if (hasPermission) {
                    Position currentPosition =
                        await Geolocator.getCurrentPosition();
                    List<PlacemarkMapObject> mapsList = <PlacemarkMapObject>[];

                    var _placemark = PlacemarkMapObject(
                      mapId: placemarkId,
                      point: Point(
                          latitude: currentPosition.latitude,
                          longitude: currentPosition.longitude),
                      // onTap: (Placemark self, Point point) =>
                      //     setCurrentTerminal(element),
                      icon: PlacemarkIcon.single(PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                              'assets/images/chosen_point.png'),
                          rotationType: RotationType.noRotation,
                          scale: 2,
                          anchor: Offset.fromDirection(1.1, 1))),
                    );
                    List<MapObject> mapsLists = <MapObject>[];
                    mapsLists.add(_placemark);
                    setState(() {
                      mapObjects = mapsLists;
                    });

                    await controller.moveCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: Point(
                                latitude: currentPosition.latitude,
                                longitude: currentPosition.longitude),
                            zoom: 17)),
                        animation: animation);
                    showBottomSheet(Point(
                        latitude: currentPosition.latitude,
                        longitude: currentPosition.longitude));
                  } else {
                    await controller.moveCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: Point(
                                latitude: double.parse(currentCity.lat),
                                longitude: double.parse(currentCity.lon)),
                            zoom: 17)),
                        animation: animation);
                  }
                }
                setState(() {
                  isLookingLocation = false;
                });
              },
              onMapTap: (point) async {
                var _placemark = PlacemarkMapObject(
                  mapId: placemarkId,
                  point: point,
                  // onTap: (Placemark self, Point point) =>
                  //     setCurrentTerminal(element),
                  icon: PlacemarkIcon.single(PlacemarkIconStyle(
                      image: BitmapDescriptor.fromAssetImage(
                          'assets/images/chosen_point.png'),
                      rotationType: RotationType.noRotation,
                      scale: 2,
                      anchor: Offset.fromDirection(1.1, 1))),
                );
                List<MapObject> mapsLists = <MapObject>[];
                mapsLists.add(_placemark);
                setState(() {
                  mapObjects = mapsLists;
                });

                await controller.moveCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(target: point, zoom: 17)),
                    animation: animation);
                showBottomSheet(point);
              },
            )) /*)*/,
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
                lookForLocation();
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: isLookingLocation
                  ? CircularProgressIndicator(
                      color: Colors.yellow.shade700,
                    )
                  : Icon(Icons.navigation,
                      size: 23.0, color: Colors.yellow.shade700),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            )),
      ]),
    ));
  }
}
