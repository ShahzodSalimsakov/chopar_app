import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chopar_app/models/basket_item_quantity.dart';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/deliver_later_time.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/delivery_notes.dart';
import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/home_is_scrolled.dart';
import 'package:chopar_app/models/pay_cash.dart';
import 'package:chopar_app/models/pay_type.dart';
import 'package:chopar_app/models/registered_review.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/routes/router.dart';
import 'package:chopar_app/utils/http_locale_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'models/additional_phone_number.dart';
import 'models/basket.dart';
import 'models/delivery_time.dart';
import 'models/home_scroll_position.dart';
import 'models/stock.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Awesome notifications
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
            channelGroupKey: 'basic_channel_group',
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
  getIt.registerSingleton<AppRouter>(AppRouter());
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
  Hive.registerAdapter(AdditionalPhoneNumberAdapter());
  Hive.registerAdapter(HomeIsScrolledAdapter());
  Hive.registerAdapter(HomeScrollPositionAdapter());
  Hive.registerAdapter(RegisteredReviewAdapter());
  Hive.registerAdapter(BasketItemQuantityAdapter());
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
  await Hive.openBox<AdditionalPhoneNumber>('additionalPhoneNumber');
  await Hive.openBox<HomeIsScrolled>('homeIsScrolled');
  await Hive.openBox<HomeScrollPosition>('homeScrollPosition');
  await Hive.openBox<RegisteredReview>('registeredReview');
  await Hive.openBox<BasketItemQuantity>('basketItemQuantity');

  runApp(EasyLocalization(
      supportedLocales: [Locale('ru'), Locale('uz')],
      path: 'https://api.choparpizza.uz/api/get_langs',
      fallbackLocale: Locale('ru'),
      useOnlyLangCode: true,
      assetLoader: HttpAssetLoader(),
      child: MainApp()));
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _appRouter = AppRouter();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   if (message != null) {
    //     final routeFromMessage = message.data['view'];
    //     if (routeFromMessage == 'order') {
    //       Navigator.pushNamed(
    //         navigatorKey.currentState!.context,
    //         '/order',
    //         arguments: message.data['id'],
    //       );
    //     }
    //   }
    // });

    // FirebaseMessaging.onMessage.listen((message) {
    //   if (message.notification != null) {
    //     print(message.notification!.title);
    //     print(message.notification!.body);
    //   }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   final routeFromMessage = message.data['view'];

    //   if (routeFromMessage == 'order') {
    //     Navigator.pushNamed(
    //       navigatorKey.currentState!.context,
    //       '/order',
    //       arguments: message.data['id'],
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color.fromRGBO(47, 94, 142, 1), // Color for Android
        statusBarBrightness:
            Brightness.light // Dark == white status bar -- for IOS.
        ));
    final router = getIt<AppRouter>();
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Chopar',
      theme: ThemeData(primaryColor: Colors.white, fontFamily: 'Ubuntu'),
      routerDelegate: AutoRouterDelegate(router),
      routeInformationParser: router.defaultRouteParser(),
    );
  }
}
