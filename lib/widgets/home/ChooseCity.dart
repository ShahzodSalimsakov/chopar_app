import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:chopar_app/models/city.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';

// Custom HTTP client with better error handling for SSL issues
class CitiesHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      // Add retry logic for connection issues
      int retries = 3;
      while (retries > 0) {
        try {
          // Create a fresh copy of the request for each attempt
          http.BaseRequest newRequest;

          if (request is http.Request) {
            final originalRequest = request as http.Request;
            final newRequest =
                http.Request(originalRequest.method, originalRequest.url)
                  ..headers.addAll(originalRequest.headers);

            if (originalRequest.bodyBytes.isNotEmpty) {
              newRequest.bodyBytes = originalRequest.bodyBytes;
            }

            return await _inner.send(newRequest).timeout(Duration(seconds: 15));
          } else {
            // For other request types
            return await _inner.send(request).timeout(Duration(seconds: 15));
          }
        } on SocketException catch (e) {
          retries--;
          if (retries == 0) rethrow;
          await Future.delayed(Duration(milliseconds: 500));
        } on TimeoutException catch (e) {
          retries--;
          if (retries == 0) rethrow;
          await Future.delayed(Duration(milliseconds: 500));
        } on HandshakeException catch (e) {
          retries--;
          if (retries == 0) rethrow;
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
      throw Exception("Failed after multiple retries");
    } catch (e) {
      throw e;
    }
  }

  @override
  void close() {
    _inner.close();
  }
}

class ChooseCity extends HookWidget {
  // Helper method to get the appropriate city name based on current locale
  String getCityName(City city, BuildContext context) {
    final currentLocale = context.locale.languageCode;
    // Use nameUz for Uzbek language, otherwise use name (Russian)
    return currentLocale == 'uz' ? city.nameUz : city.name;
  }

  Widget cityModal(BuildContext context, List<City> cities) {
    City? currentCity = Hive.box<City>('currentCity').get('currentCity');
    return Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                tr('select_city'),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      getCityName(cities[index], context),
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: currentCity != null &&
                            currentCity.id == cities[index].id
                        ? const Icon(
                            Icons.check,
                            color: Colors.yellow,
                          )
                        : null,
                    selected: currentCity != null &&
                        currentCity.id == cities[index].id,
                    onTap: () {
                      Box<City> transaction = Hive.box<City>('currentCity');
                      transaction.put('currentCity', cities[index]);
                      Navigator.of(context).pop();
                    },
                  );
                }),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final cities = useState<List<City>>(List<City>.empty());
    final isMounted = useValueNotifier<bool>(true);
    final isLoading = useState<bool>(false);
    final errorMessage = useState<String?>(null);
    // Initialize httpClient immediately
    final httpClient = useMemoized(() => CitiesHttpClient(), []);

    // Dispose the HTTP client when the widget is disposed
    useEffect(() {
      return () {
        httpClient.close();
        isMounted.value = false;
      };
    }, []);

    Future<void> loadCities() async {
      if (isLoading.value) return;

      isLoading.value = true;
      errorMessage.value = null;

      try {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        var url = Uri.https('api.choparpizza.uz', '/api/cities/public');
        var response = await httpClient.get(url, headers: requestHeaders);

        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          if (isMounted.value) {
            List<City> cityList = List<City>.from(
                json['data'].map((m) => new City.fromJson(m)).toList());
            cities.value = cityList;
            City? currentCity =
                Hive.box<City>('currentCity').get('currentCity');
            if (currentCity == null && cityList.isNotEmpty) {
              Hive.box<City>('currentCity').put('currentCity', cityList[0]);
            }
          }
        } else {
          errorMessage.value =
              'Failed to load cities: HTTP ${response.statusCode}';
        }
      } catch (e) {
        if (isMounted.value) {
          errorMessage.value = 'Failed to connect to server: ${e.toString()}';
          print('Error loading cities: $e');
        }
      } finally {
        if (isMounted.value) {
          isLoading.value = false;
        }
      }
    }

    useEffect(() {
      loadCities();
      return () {
        isMounted.value = false;
      };
    }, []);

    return ValueListenableBuilder<Box<City>>(
        valueListenable: Hive.box<City>('currentCity').listenable(),
        builder: (context, box, _) {
          City? currentCity = box.get('currentCity');
          return ListTile(
              contentPadding: EdgeInsets.only(left: 2),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isLoading.value)
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                  SizedBox(width: isLoading.value ? 8 : 0),
                  Text(
                    currentCity != null
                        ? getCityName(currentCity, context)
                        : tr('your_city'),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
              onTap: () {
                if (errorMessage.value != null) {
                  // If there was an error, try loading again when tapped
                  loadCities();
                }

                if (!isLoading.value && cities.value.isNotEmpty) {
                  showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => cityModal(context, cities.value),
                  );
                }
              });
        });
  }
}
