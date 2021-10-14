import 'package:chopar_app/app.dart';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/store/city.dart';
import 'package:flutter/material.dart';
import 'package:chopar_app/pages/home.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'models/basket.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CityAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BasketAdapter());
  await Hive.openBox<City>('currentCity');
  await Hive.openBox<User>('user');
  await Hive.openBox<Basket>('basket');

  runApp(
    MainApp()
  );
}


class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(primaryColor: Colors.white, fontFamily: 'Ubuntu'),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

