import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:easy_localization_loader/easy_localization_loader.dart';

import 'dart:ui';

// show AssetLoader;

abstract class AssetLoader {
  const AssetLoader();

  Future<Map<String, dynamic>> load(String path, Locale locale);
}

Locale localeFromString(String localeString) {
  final localeList = localeString.split('_');
  switch (localeList.length) {
    case 2:
      return Locale(localeList.first, localeList.last);
    case 3:
      return Locale.fromSubtags(
          languageCode: localeList.first,
          scriptCode: localeList[1],
          countryCode: localeList.last);
    default:
      return Locale(localeList.first);
  }
}

String localeToString(Locale locale, {String separator = '_'}) {
  return locale.toString().split('_').join(separator);
}

class HttpAssetLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    log('easy localization loader: load http $path');
    try {
      var url = Uri.parse(path);
      url = url.replace(queryParameters: {
        "lang": locale.toString()
      });
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          return http.get(url).then((response) {
            return json.decode(response.body.toString())['result'];
          });
        }
      } on SocketException catch (_) {
        return Future.value({});
      }
      return Future.value({});
    } catch (e) {
      //Catch network exceptions
      return Future.value({});
    }
  }
}
