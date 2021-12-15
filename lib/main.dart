import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chopar_app/app.dart';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/deliver_later_time.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/delivery_notes.dart';
import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/pay_cash.dart';
import 'package:chopar_app/models/pay_type.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/pages/order_detail.dart';
import 'package:chopar_app/route_generator.dart';
import 'package:chopar_app/store/city.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chopar_app/pages/home.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart';
import 'authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'models/basket.dart';
import 'models/delivery_time.dart';
import 'models/stock.dart';
import 'models/yandex_geo_data.dart';
import 'utils/http_locale_loader.dart';
import 'package:http/http.dart' as http;

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Awesome notifications
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CityAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BasketAdapter());
  Hive.registerAdapter(TerminalsAdapter());
  Hive.registerAdapter(DeliveryLocationDataAdapter());
  Hive.registerAdapter(DeliveryTypeAdapter());
  Hive.registerAdapter(DeliveryTypeEnumAdapter());
  Hive.registerAdapter(DeliveryTimeAdapter());
  Hive.registerAdapter(DeliveryTimeEnumAdapter());
  Hive.registerAdapter(DeliverLaterTimeAdapter());
  Hive.registerAdapter(PayTypeAdapter());
  Hive.registerAdapter(DeliveryNotesAdapter());
  Hive.registerAdapter(PayCashAdapter());
  Hive.registerAdapter(StockAdapter());
  await Hive.openBox<City>('currentCity');
  await Hive.openBox<User>('user');
  await Hive.openBox<Basket>('basket');
  await Hive.openBox<Terminals>('currentTerminal');
  await Hive.openBox<DeliveryLocationData>('deliveryLocationData');
  await Hive.openBox<DeliveryType>('deliveryType');
  await Hive.openBox<DeliveryTime>('deliveryTime');
  await Hive.openBox<DeliverLaterTime>('deliveryLaterTime');
  await Hive.openBox<PayType>('payType');
  await Hive.openBox<DeliveryNotes>('deliveryNotes');
  await Hive.openBox<PayCash>('payCash');
  await Hive.openBox<Stock>('stock');

  runApp(EasyLocalization(
      supportedLocales: [Locale('ru'), Locale('uz')],
      path: 'https://api.choparpizza.uz/api/get_langs',
      fallbackLocale: Locale('ru'),
      assetLoader: HttpAssetLoader(),
      useOnlyLangCode: true,
      child: MainApp()));
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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

      location.enableBackgroundMode(enable: true);
      location.changeSettings(distanceFilter: 50, interval: 20000);
      _locationData = await location.getLocation();
      setLocation(_locationData);
      location.onLocationChanged.listen((LocationData currentLocation) {
        setLocation(currentLocation);
      });
    }();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data['view'];
        if (routeFromMessage == 'order') {
          Navigator.pushNamed(
            navigatorKey.currentState!.context,
            '/order',
            arguments: message.data['id'],
          );
        }
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['view'];

      if (routeFromMessage == 'order') {
        Navigator.pushNamed(
          navigatorKey.currentState!.context,
          '/order',
          arguments: message.data['id'],
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> setLocation(LocationData location) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.https('api.choparpizza.uz', 'api/geocode', {
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString()
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
          lat: location.latitude,
          lon: location.longitude,
          address: geoData.formatted ?? '');
      final Box<DeliveryLocationData> deliveryLocationBox =
          Hive.box<DeliveryLocationData>('deliveryLocationData');
      deliveryLocationBox.put('deliveryLocationData', deliveryData);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      url = Uri.https('api.choparpizza.uz', 'api/terminals/find_nearest', {
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString()
      });
      response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Terminals> terminal = List<Terminals>.from(json['data']['items']
            .map((m) => new Terminals.fromJson(m))
            .toList());
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
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.light // Dark == white status bar -- for IOS.
        ));
    return Container(
      child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: MaterialApp(
            navigatorKey: navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(primaryColor: Colors.white, fontFamily: 'Ubuntu'),
            // home: Home(),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          )),
    );
  }
}
