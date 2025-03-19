import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'dart:io';
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

// show AssetLoader;

// abstract class AssetLoader {
//   const AssetLoader();

//   Future<Map<String, dynamic>> load(String path, Locale locale);
// }

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

// Custom HTTP client with retry logic for localization
class LocalizationHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      // Add retry logic for connection issues
      int retries = 3;
      while (retries > 0) {
        try {
          // Create a fresh copy of the request for each attempt
          // This prevents "Can't finalize a finalized Request" errors
          http.BaseRequest newRequest;

          if (request is http.Request) {
            final originalRequest = request as http.Request;
            final newRequest =
                http.Request(originalRequest.method, originalRequest.url)
                  ..headers.addAll(originalRequest.headers);

            if (originalRequest.bodyBytes.isNotEmpty) {
              newRequest.bodyBytes = originalRequest.bodyBytes;
            }

            return await _inner.send(newRequest).timeout(Duration(seconds: 10));
          } else if (request is http.MultipartRequest) {
            // Handle multipart requests if needed
            final originalRequest = request as http.MultipartRequest;
            final newRequest = http.MultipartRequest(
                originalRequest.method, originalRequest.url)
              ..headers.addAll(originalRequest.headers)
              ..fields.addAll(originalRequest.fields);

            for (final file in originalRequest.files) {
              newRequest.files.add(file);
            }

            return await _inner.send(newRequest).timeout(Duration(seconds: 10));
          } else {
            // For other request types, we'll need to create a new request
            return await _inner.send(request).timeout(Duration(seconds: 10));
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
        } on StateError catch (e) {
          // Handle "Bad state: Can't finalize a finalized Request" error
          retries--;
          if (retries == 0) rethrow;
          await Future.delayed(Duration(milliseconds: 500));
        }
      }
      throw Exception("Failed after retries");
    } catch (e) {
      throw e;
    }
  }

  // Helper methods to simplify making requests
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final request = http.Request('GET', url);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    final response = await send(request);
    return http.Response.fromStream(await response);
  }

  @override
  void close() {
    _inner.close();
  }
}

class HttpAssetLoader extends AssetLoader {
  const HttpAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    log('easy localization loader: load http $path');
    LocalizationHttpClient? client;

    try {
      var url = Uri.parse(path);
      url = url.replace(queryParameters: {"lang": locale.toString()});

      try {
        // Check internet connectivity first
        final result = await InternetAddress.lookup('google.com')
            .timeout(Duration(seconds: 5));

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          // Create a client with retry logic
          client = LocalizationHttpClient();

          try {
            final response =
                await client.get(url).timeout(Duration(seconds: 15));

            if (response.statusCode == 200) {
              final jsonData = json.decode(response.body.toString());
              return jsonData['result'] ?? {};
            } else {
              log('HTTP error: ${response.statusCode}');
              return {};
            }
          } catch (httpError) {
            log('HTTP request error: $httpError');
            return {};
          }
        }
      } on SocketException catch (e) {
        log('Network connectivity error: $e');
        return {};
      } on TimeoutException catch (e) {
        log('Network timeout error: $e');
        return {};
      } finally {
        // Ensure client is closed properly
        client?.close();
      }

      return {};
    } catch (e) {
      log('Localization loader error: $e');
      // Ensure client is closed even if an exception occurs
      client?.close();
      return {};
    }
  }
}
