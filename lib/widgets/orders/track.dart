import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/track_point.dart';
import '../../models/user.dart';
import '../ui/styled_button.dart';

class TrackOrder extends StatefulWidget {
  final int orderId;
  TrackOrder({Key? key, required this.orderId}) : super(key: key);

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  late YandexMapController controller;
  final animation =
      const MapAnimation(type: MapAnimationType.smooth, duration: 1.5);

  TrackPoint? trackPoint = null;
  List<MapObject> mapObjects = [];
  late Timer myTimer;

  Future<void> loadLocation(Timer timer) async {
    Box<User> transaction = Hive.box<User>('user');
    User currentUser = transaction.get('user')!;
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${currentUser.userToken}'
    };
    var url = Uri.https('api.choparpizza.uz', '/api/orders/track/',
        {'id': widget.orderId.toString()});
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var localOrder = TrackPoint.fromJson(response.body);
      if (localOrder.success == false) {
        timer.cancel();
      }

      if (localOrder.data != null &&
          trackPoint != null &&
          trackPoint?.data != null) {
        if (localOrder.data!.latitude != null &&
            localOrder.data!.longitude != null &&
            localOrder.data!.latitude != trackPoint!.data!.latitude &&
            localOrder.data!.longitude != trackPoint!.data!.longitude) {
          controller.moveCamera(
              CameraUpdate.newCameraPosition(CameraPosition(
                  target: Point(
                      latitude: localOrder!.data!.latitude,
                      longitude: localOrder!.data!.longitude),
                  zoom: 15)),
              animation: animation);
        }
      }

      setState(() {
        trackPoint = localOrder;
      });

      if (localOrder.fromLocation != null) {
        setState(() {
          mapObjects = [
            PlacemarkMapObject(
                mapId: MapObjectId('from'),
                point: Point(
                  latitude: localOrder.fromLocation!.lat,
                  longitude: localOrder.fromLocation!.lon,
                ),
                opacity: 1,
                icon: PlacemarkIcon.single(PlacemarkIconStyle(
                    isFlat: true,
                    image: BitmapDescriptor.fromAssetImage(
                        'assets/images/from_location.png')))),
            PlacemarkMapObject(
              mapId: MapObjectId('point'),
              point: Point(
                latitude: localOrder.data!.latitude,
                longitude: localOrder.data!.longitude,
              ),
              opacity: 1,
              zIndex: 2,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/images/map_placemark-courier.png'))),
            ),
            PlacemarkMapObject(
                mapId: MapObjectId('to'),
                point: Point(
                  latitude: localOrder.toLocation!.lat,
                  longitude: localOrder.toLocation!.lon,
                ),
                opacity: 1,
                icon: PlacemarkIcon.single(PlacemarkIconStyle(
                    image: BitmapDescriptor.fromAssetImage(
                        'assets/images/to_location.png')))),
          ];
        });
      }
    } else {
      timer.cancel();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTimer = Timer.periodic(const Duration(seconds: 5), loadLocation);
    loadLocation(myTimer);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: trackPoint == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : trackPoint!.success == false
                ? Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40)),
                                child: CloseButton())
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr('error_label').toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tr(trackPoint!.message!),
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DefaultStyledButton(
                          width: double.infinity,
                          onPressed: () {
                            loadLocation(myTimer);
                          },
                          text: 'Обновить'.toUpperCase(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                : Stack(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: YandexMap(
                          mapObjects: mapObjects,
                          zoomGesturesEnabled: true,
                          onMapCreated:
                              (YandexMapController yandexMapController) async {
                            controller = yandexMapController;

                            if (trackPoint != null) {
                              controller.moveCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: Point(
                                          latitude: trackPoint!.data!.latitude,
                                          longitude:
                                              trackPoint!.data!.longitude),
                                      zoom: 15)),
                                  animation: animation);
                            }
                          }),
                    ),
                    Positioned(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40)),
                            child: CloseButton()),
                        top: 40,
                        right: 10),
                    trackPoint!.courier != null &&
                            trackPoint!.courier!.first_name != null
                        ? Positioned(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow.shade700,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 5)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Курьер".toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                  Icons.person_2_outlined,
                                                  size: 30,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  "${trackPoint!.courier!.first_name!} ${trackPoint!.courier!.last_name!}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                  Icons.phone_enabled_outlined,
                                                  size: 30,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(
                                                  trackPoint!.courier!.phone!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            bottom: 10,
                            left: 10)
                        : const SizedBox(),
                  ]));
  }
}
