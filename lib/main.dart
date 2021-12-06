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
import 'package:chopar_app/services/PushNotificationService.dart';
import 'package:chopar_app/store/city.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chopar_app/pages/home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

import 'models/basket.dart';
import 'models/delivery_time.dart';
import 'utils/http_locale_loader.dart';


Future<void> backgroundHandler(RemoteMessage message) async {

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService().setupInteractedMessage();
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
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data['view'];
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

      print(routeFromMessage);
    });
  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(primaryColor: Colors.white, fontFamily: 'Ubuntu'),
          home: Home(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
