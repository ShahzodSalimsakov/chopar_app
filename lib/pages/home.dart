import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/home_is_scrolled.dart';
import 'package:chopar_app/models/stock.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/models/yandex_geo_data.dart';
import 'package:chopar_app/pages/main_page.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:chopar_app/widgets/auth/modal.dart';
import 'package:chopar_app/widgets/basket/basket.dart';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/widgets/bonus/modal.dart';
import 'package:chopar_app/widgets/delivery/delivery_modal.dart';
import 'package:chopar_app/widgets/home/ChooseCity.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/home/ProductsList.dart';
import 'package:chopar_app/widgets/home/StoriesList.dart';
import 'package:chopar_app/widgets/order_status/index.dart';
import 'package:chopar_app/widgets/profile/PagesList.dart';
import 'package:chopar_app/widgets/profile/UserName.dart';
import 'package:chopar_app/widgets/profile/index.dart';
import 'package:chopar_app/widgets/sales/sales.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:overlay_dialog/overlay_dialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

OverlayEntry? _previousEntry;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  var workTimeModalOpened = false;
  late Flushbar _closeWorkModal;

  // showAlertOnChangeLocation(LocationData currentLocation,
  //     DeliveryLocationData deliveryData, String house, String location) async {
  //   await Future.delayed(Duration(milliseconds: 50));
  //   String deliveryText = '';
  //   if (deliveryData != null) {
  //     deliveryText = deliveryData?.address ?? '';
  //     String house =
  //         deliveryData.house != null ? ', дом: ${deliveryData.house}' : '';
  //     String flat =
  //         deliveryData.flat != null ? ', кв.: ${deliveryData.flat}' : '';
  //     String entrance = deliveryData.entrance != null
  //         ? ', подъезд: ${deliveryData.entrance}'
  //         : '';
  //     deliveryText = '${deliveryText}${house}${flat}${entrance}';
  //   }
  //   PlatformAlertDialog alert = PlatformAlertDialog(
  //     title: Text("Изменилось местоположение"),
  //     content: Text("Ваш адрес: ${deliveryText}?"),
  //     actions: [
  //       TextButton(
  //           onPressed: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (context) => DeliveryModal()));
  //           },
  //           child: Text("Да")),
  //       TextButton(
  //           onPressed: () {
  //             return Navigator.pop(context, true);
  //           },
  //           child: Text("Нет"))
  //     ],
  //   );
  //   showPlatformDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  Future<void> setLocation(LocationData location,
      DeliveryLocationData deliveryData, String house) async {
    final Box<DeliveryLocationData> deliveryLocationBox =
        Hive.box<DeliveryLocationData>('deliveryLocationData');
    deliveryLocationBox.put('deliveryLocationData', deliveryData);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    var url = Uri.https('api.choparpizza.uz', 'api/terminals/find_nearest', {
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString()
    });
    var response = await http.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<Terminals> terminal = List<Terminals>.from(
          json['data']['items'].map((m) => new Terminals.fromJson(m)).toList());
      Box<Terminals> transaction = Hive.box<Terminals>('currentTerminal');
      if (terminal.length > 0) {
        transaction.put('currentTerminal', terminal[0]);

        var stockUrl = Uri.https(
            'api.choparpizza.uz',
            'api/terminals/get_stock',
            {'terminal_id': terminal[0].id.toString()});
        var stockResponse = await http.get(stockUrl, headers: requestHeaders);
        if (stockResponse.statusCode == 200) {
          var json = jsonDecode(stockResponse.body);
          Stock newStockData = new Stock(
              prodIds: new List<int>.from(json[
                  'data']) /* json['data'].map((id) => id as int).toList()*/);
          Box<Stock> box = Hive.box<Stock>('stock');
          box.put('stock', newStockData);
        }
      }
    }
  }

  workTimeDialog() async {
    var startTime = DateTime.now();
    DateTime dateC = DateTime.now();
    startTime.minute;

    DateTime dateA = DateTime(dateC.year, dateC.month, dateC.day, 2, 45);
    DateTime dateB = DateTime(dateC.year, dateC.month, dateC.day, 10);
    if (dateA.isBefore(dateC) && dateB.isAfter(dateC)) {
      await Future.delayed(Duration(milliseconds: 50));
      if (!workTimeModalOpened) {
        _closeWorkModal = Flushbar(
            message: "Откроемся в 10:00",
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundColor: Colors.black87,
            isDismissible: false,
            duration: Duration(days: 4),
            icon: Container(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.lock_clock,
                color: Colors.white,
                size: 40,
              ),
            ),
            messageText: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Откроемся в 10:00",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: "ShadowsIntoLightTwo"),
              ),
            ),
            margin: EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10));
        setState(() {
          workTimeModalOpened = true;
        });
        _closeWorkModal.show(context);
      }
    } else {
      if (workTimeModalOpened && _closeWorkModal != null) {
        _closeWorkModal.dismiss();
      }
      setState(() {
        workTimeModalOpened = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(new Duration(seconds: 1), (timer) {
      workTimeDialog();
    });
    () async {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      // location.enableBackgroundMode(enable: true);
      // location.changeSettings(distanceFilter: 100, interval: 60000, accuracy: LocationAccuracy.balanced);
      _locationData = await location.getLocation();
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.choparpizza.uz', 'api/geocode', {
        'lat': _locationData.latitude.toString(),
        'lon': _locationData.longitude.toString()
      });
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var geoData = YandexGeoData.fromJson(json['data']);
        var house = '';
        geoData.addressItems?.forEach((element) {
          if (element.kind == 'house') {
            house = element.name;
          }
        });
        DeliveryLocationData deliveryData = DeliveryLocationData(
            house: house ?? '',
            flat: '',
            entrance: '',
            doorCode: '',
            lat: _locationData.latitude,
            lon: _locationData.longitude,
            address: geoData.formatted ?? '');

        setLocation(_locationData, deliveryData, house);
      }
      // location.onLocationChanged.listen((LocationData currentLocation) async {
      //   DeliveryLocationData? deliveryLocationData =
      //       Hive.box<DeliveryLocationData>('deliveryLocationData')
      //           .get('deliveryLocationData');
      //   if ("${currentLocation.latitude.toString()}${currentLocation.longitude.toString()}" !=
      //       "${deliveryLocationData?.lat?.toString()}${deliveryLocationData?.lon?.toString()}") {
      //     Map<String, String> requestHeaders = {
      //       'Content-type': 'application/json',
      //       'Accept': 'application/json'
      //     };
      //     var url = Uri.https('api.choparpizza.uz', 'api/geocode', {
      //       'lat': _locationData.latitude.toString(),
      //       'lon': _locationData.longitude.toString()
      //     });
      //     var response = await http.get(url, headers: requestHeaders);
      //     if (response.statusCode == 200) {
      //       var json = jsonDecode(response.body);
      //       var geoData = YandexGeoData.fromJson(json['data']);
      //       var house = '';
      //       geoData.addressItems?.forEach((element) {
      //         if (element.kind == 'house') {
      //           house = element.name;
      //         }
      //       });
      //       DeliveryLocationData deliveryData = DeliveryLocationData(
      //           house: house ?? '',
      //           flat: '',
      //           entrance: '',
      //           doorCode: '',
      //           lat: _locationData.latitude,
      //           lon: _locationData.longitude,
      //           address: geoData.formatted ?? '');
      //
      //       showAlertOnChangeLocation(currentLocation, deliveryData, house,
      //           "${currentLocation.latitude.toString()},${currentLocation.longitude.toString()} ${deliveryLocationData?.lat?.toString()},${deliveryLocationData?.lon?.toString()}");
      //       setLocation(currentLocation, deliveryData, house);
      //     }
      //   }
      // });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      MainPage(),
      Sales(),
      ProfileIndex(),
      // Container(
      //   margin: EdgeInsets.all(20.0),
      //   child: Column(
      //     children: <Widget>[/*ChooseCity(), UserName(), PagesList()*/ LoginView()],
      //   ),
      // ),
      BasketWidget()
    ];
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: tabs[selectedIndex]),
        bottomNavigationBar: Container(
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey, blurRadius: 5, offset: Offset(0, 0))
              ],
            ),
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: ValueListenableBuilder<Box<Basket>>(
                    valueListenable: Hive.box<Basket>('basket').listenable(),
                    builder: (context, box, _) {
                      Basket? basket = box.get('basket');
                      return BottomNavigationBar(
                        backgroundColor: Colors.white,
                        selectedItemColor: Colors.yellow.shade700,
                        unselectedItemColor: Colors.grey,
                        type: BottomNavigationBarType.fixed,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 10),
                              child: SvgPicture.asset('assets/images/menu.svg',
                                  color: selectedIndex != 0
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                            ),
                            label: tr('headerMenuMenu'),
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 10),
                              child: SvgPicture.asset(
                                  'assets/images/discount.svg',
                                  color: selectedIndex != 1
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                            ),
                            label: 'Акции',
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 10),
                              child: SvgPicture.asset(
                                  'assets/images/profile.svg',
                                  color: selectedIndex != 2
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                            ),
                            label: 'Профиль',
                          ),
                          BottomNavigationBarItem(
                            icon: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 6, top: 10),
                                  child: SvgPicture.asset(
                                      'assets/images/bag.svg',
                                      color: selectedIndex != 3
                                          ? Colors.grey
                                          : Colors.yellow.shade700),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: basket != null &&
                                            basket.lineCount > 0
                                        ? Container(
                                            // color: Colors.yellow.shade600,
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.yellow.shade600),
                                            child: Center(
                                              child: Text(
                                                basket.lineCount.toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : SizedBox())
                              ],
                            ),
                            // activeIcon: Stack(children: [],),
                            label: 'Корзина',
                          ),
                        ],
                        currentIndex: selectedIndex,
                        onTap: (int index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      );
                    }))));
  }
}
