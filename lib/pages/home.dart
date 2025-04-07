import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/stock.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/yandex_geo_data.dart';
import 'package:chopar_app/pages/main_page.dart';
import 'package:chopar_app/services/app_update_service.dart';
import 'package:chopar_app/widgets/basket/basket.dart';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/widgets/home/WorkTime.dart';
import 'package:chopar_app/widgets/profile/index.dart';
import 'package:chopar_app/widgets/sales/sales.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../models/city.dart';

OverlayEntry? _previousEntry;

@RoutePage()
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int selectedIndex = 0;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final AppUpdateService _appUpdateService = AppUpdateService();
  AppUpdateInfo? _updateInfo;

  Future<void> setLocation(Position location, DeliveryLocationData deliveryData,
      String house, List<AddressItems>? addressItems) async {
    final Box<DeliveryLocationData> deliveryLocationBox =
        Hive.box<DeliveryLocationData>('deliveryLocationData');
    deliveryLocationBox.put('deliveryLocationData', deliveryData);

    Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
    DeliveryType? currentDeliver = box.get('deliveryType');
    if (currentDeliver == null) {
      DeliveryType deliveryType = DeliveryType();
      deliveryType.value = DeliveryTypeEnum.deliver;
      Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
      box.put('deliveryType', deliveryType);
    }

    addressItems?.forEach((item) async {
      if (item.kind == 'province' || item.kind == 'area') {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };
        var url = Uri.https('api.choparpizza.uz', '/api/cities/public');
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          List<City> cityList = List<City>.from(
              json['data'].map((m) => City.fromJson(m)).toList());
          for (var element in cityList) {
            if (element.name == item.name) {
              Hive.box<City>('currentCity').put('currentCity', element);
            }
          }
        }
      }
    });

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

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    setState(() {
      _connectionStatus =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
    });
  }

  void _instanceId() async {
    var token = await FirebaseMessaging.instance.getToken();
    print("Print Instance Token ID: " + token!);
  }

  @override
  void initState() {
    super.initState();

    // Register observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Initialize connectivity
    initConnectivity();

    // We'll check for updates in the didChangeDependencies method

    _instanceId();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // bool _serviceEnabled;
      //PermissionStatus _permissionGranted;
      //final _locationData = await getLocation();
      bool serviceEnabled;
      bool hasPermission = true;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('enable_location_services')),
            action: SnackBarAction(
              label: tr('settings'),
              onPressed: () {
                Geolocator.openLocationSettings();
              },
            ),
          ),
        );
        hasPermission = false;
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr('insufficient_location_rights')),
              action: SnackBarAction(
                label: tr('allow'),
                onPressed: () async {
                  permission = await Geolocator.requestPermission();
                },
              ),
            ),
          );
          hasPermission = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('insufficient_location_rights')),
            action: SnackBarAction(
              label: tr('settings'),
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
          ),
        );
        hasPermission = false;
        return;
      }

      if (hasPermission) {
        Position _locationData = await Geolocator.getCurrentPosition();

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

          setLocation(_locationData, deliveryData, house, geoData.addressItems);
        }
      }
    });
    () async {}();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check for app updates after the context is available
    _checkForUpdates();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check for updates when app resumes from background
      _checkForUpdates();
    }
  }

  // Check for app updates
  Future<void> _checkForUpdates() async {
    // Only check for updates on Android
    if (Theme.of(context).platform == TargetPlatform.android) {
      try {
        _updateInfo = await _appUpdateService.checkForUpdateInfo();

        if (_updateInfo != null &&
            _updateInfo!.updateAvailability ==
                UpdateAvailability.updateAvailable) {
          // If flexible update is allowed, start it
          if (_updateInfo!.flexibleUpdateAllowed) {
            _appUpdateService.startFlexibleUpdate(context);
          }
          // If immediate update is allowed, perform it
          else if (_updateInfo!.immediateUpdateAllowed) {
            _appUpdateService.performImmediateUpdate();
          }
        } else if (_updateInfo != null &&
            _updateInfo!.updateAvailability ==
                UpdateAvailability.updateAvailable &&
            _updateInfo!.installStatus == InstallStatus.downloaded) {
          // If update is downloaded but not installed, show restart dialog
          _appUpdateService.showRestartDialog(context);
        }
      } catch (e) {
        debugPrint('Ошибка при проверке обновлений: $e');
      }
    }
  }

  @override
  void dispose() {
    // Remove observer
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
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
        body: _connectionStatus == ConnectivityResult.none
            ? SafeArea(
                child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.wifi,
                      size: 100,
                      color: Colors.yellow.shade800,
                    ),
                    Center(
                        child: Text(
                      tr('no_internet'),
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    )),
                  ],
                ),
              ))
            : SafeArea(
                child: Column(
                children: [
                  WorkTimeWidget(),
                  Expanded(child: tabs[selectedIndex])
                ],
              )),
        floatingActionButton: kDebugMode
            ? FloatingActionButton(
                backgroundColor: Colors.yellow.shade700,
                child: Icon(Icons.system_update, size: 28),
                onPressed: () {
                  // Directly start the emulation without confirmation dialog for simplicity
                  _appUpdateService.emulateUpdate(context);
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: Container(
            height: 70.0,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey, blurRadius: 5, offset: Offset(0, 0))
              ],
            ),
            child: ClipRRect(
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
                              padding: EdgeInsets.only(bottom: 5, top: 5),
                              child: FaIcon(FontAwesomeIcons.pizzaSlice,
                                  size: 25,
                                  color: selectedIndex != 0
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                              // SvgPicture.asset('assets/images/menu.svg',
                              //     color: selectedIndex != 0
                              //         ? Colors.grey
                              //         : Colors.yellow.shade700),
                            ),
                            label: tr('nav_menu'),
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 5, top: 5),
                              child: FaIcon(FontAwesomeIcons.percent,
                                  size: 25,
                                  color: selectedIndex != 1
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                              // SvgPicture.asset(
                              //     'assets/images/discount.svg',
                              //     color: selectedIndex != 1
                              //         ? Colors.grey
                              //         : Colors.yellow.shade700),
                            ),
                            label: tr('nav_sales'),
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 5, top: 5),
                              child: FaIcon(FontAwesomeIcons.user,
                                  size: 25,
                                  color: selectedIndex != 2
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                              // SvgPicture.asset(
                              //     'assets/images/profile.svg',
                              //     color: selectedIndex != 2
                              //         ? Colors.grey
                              //         : Colors.yellow.shade700),
                            ),
                            label: tr('nav_profile'),
                          ),
                          BottomNavigationBarItem(
                            icon: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5, top: 5),
                                  child: FaIcon(FontAwesomeIcons.cartPlus,
                                      size: 25,
                                      color: selectedIndex != 3
                                          ? Colors.grey
                                          : Colors.yellow.shade700),
                                  // SvgPicture.asset(
                                  //     'assets/images/bag.svg',
                                  //     color: selectedIndex != 3
                                  //         ? Colors.grey
                                  //         : Colors.yellow.shade700),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: basket != null &&
                                            basket.lineCount > 0
                                        ? Container(
                                            // color: Colors.yellow.shade600,
                                            width: 20,
                                            height: 20,
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
                            label: tr('nav_cart'),
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
