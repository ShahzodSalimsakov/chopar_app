import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopar_app/widgets/home/ThreePizza.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/basket.dart';
import '../../models/basket_data.dart';
import '../../models/city.dart';
import '../../models/delivery_location_data.dart';
import '../../models/delivery_type.dart';
import '../../models/product_section.dart';
import '../../models/stock.dart';
import '../../models/terminals.dart';
import '../../pages/product_detail.dart';
import '../products/50_50.dart';

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

// Custom HTTP client with better error handling
class CustomHttpClient extends http.BaseClient {
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
                  ..headers.addAll(originalRequest.headers)
                  ..bodyBytes = originalRequest.bodyBytes;
            return await _inner.send(newRequest).timeout(Duration(seconds: 15));
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

            return await _inner.send(newRequest).timeout(Duration(seconds: 15));
          } else {
            // For other request types, we'll need to create a new request
            // This is a simplified approach - you might need to handle other request types
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
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final request = http.Request('POST', url);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      }
    }
    if (encoding != null) {
      request.encoding = encoding;
    }
    final response = await send(request);
    return http.Response.fromStream(await response);
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final request = http.Request('PUT', url);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      }
    }
    if (encoding != null) {
      request.encoding = encoding;
    }
    final response = await send(request);
    return http.Response.fromStream(await response);
  }

  @override
  void close() {
    _inner.close();
  }
}

class ProductScrollableTabList extends StatefulWidget {
  final ScrollController parentScrollController;

  const ProductScrollableTabList(
      {Key? key, required this.parentScrollController})
      : super(key: key);

  @override
  State<ProductScrollableTabList> createState() =>
      _ProductScrollableListTabState();
}

class _ProductScrollableListTabState extends State<ProductScrollableTabList> {
  List<GlobalKey> categories = [];
  late ScrollController scrollCont;
  BuildContext? tabContext;

  // ItemScrollController itemScrollController = ItemScrollController();
  // ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  // ItemScrollController verticalScrollController = ItemScrollController();
  // ItemPositionsListener verticalPositionsListener =
  //     ItemPositionsListener.create();
  List<ProductSection> products = List<ProductSection>.empty();
  int scrolledIndex = 0;
  int? collapsedId;
  Map<String, dynamic>? configData;

  // Box<Basket> basketBox = Hive.box<Basket>('basket');
  // Basket? basket = basketBox.get('basket');

  final hashids = HashIds(
    salt: 'basket',
    minHashLength: 15,
    alphabet: 'abcdefghijklmnopqrstuvwxyz1234567890',
  );
  BasketData? basketData;

  bool isLoading = true;
  bool hasNetworkError = false;
  int retryCount = 0;

  // Initialize httpClient immediately instead of using late
  CustomHttpClient httpClient = CustomHttpClient();

  // Future<void> getBasket() async {
  //   Box<Basket> basketBox = Hive.box<Basket>('basket');
  //   Basket? basket = basketBox.get('basket');
  //   if (basket != null) {
  //     Map<String, String> requestHeaders = {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json'
  //     };

  //     var url =
  //         Uri.https('api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
  //     var response = await http.get(url, headers: requestHeaders);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       var json = jsonDecode(response.body);
  //       BasketData basketLocalData = BasketData.fromJson(json['data']);
  //       if (basketLocalData.lines != null) {
  //         basket.lineCount = basketLocalData.lines!.length;
  //         basketBox.put('basket', basket);
  //       }

  //       setState(() {
  //         basketData = basketLocalData;
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState(); // Call super.initState() first

    // Initialize controllers
    scrollCont = ScrollController();

    // Add listeners after initialization
    scrollCont.addListener(() {
      if (mounted) {
        changeTabs();
      }
    });

    // Загрузить кэшированные данные, если они есть
    _loadCachedProducts();

    // Call network methods after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        getBasket();
        getProducts();
        fetchConfig();
      }
    });
  }

  @override
  void dispose() {
    // Clean up resources
    scrollCont.removeListener(changeTabs);
    scrollCont.dispose();
    httpClient.close();
    super.dispose();
  }

  Future<void> getBasket() async {
    if (!mounted) return;

    try {
      Box<Basket> basketBox = Hive.box<Basket>('basket');
      Basket? basket = basketBox.get('basket');
      if (basket != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        var url =
            Uri.https('api.choparpizza.uz', '/api/baskets/${basket.encodedId}');

        try {
          var response = await httpClient.get(url, headers: requestHeaders);

          if ((response.statusCode == 200 || response.statusCode == 201) &&
              response.body.isNotEmpty) {
            var jsonResponse = jsonDecode(response.body);

            if (jsonResponse != null && jsonResponse['data'] != null) {
              BasketData basketLocalData =
                  BasketData.fromJson(jsonResponse['data']);
              if (basketLocalData.lines != null) {
                basket.lineCount = basketLocalData.lines!.length;
                basketBox.put('basket', basket);
              }
              if (mounted) {
                setState(() {
                  basketData = basketLocalData;
                });
              }
            }
          }
        } catch (networkError) {
          // Handle network errors silently without crashing
          print('Network error in getBasket: $networkError');
          // Don't show error to user for this background operation
        }
      }
    } catch (e) {
      print('Error in getBasket: ${e.toString()}');
    }
  }

  Future<void> _loadCachedProducts() async {
    try {
      // Проверяем, есть ли кэшированные данные о продуктах
      final prefs = await SharedPreferences.getInstance();
      final cachedProductsJson = prefs.getString('cached_products');

      if (cachedProductsJson != null && cachedProductsJson.isNotEmpty) {
        final jsonData = jsonDecode(cachedProductsJson);
        List<ProductSection> cachedProducts = List<ProductSection>.from(
            jsonData.map((m) => ProductSection.fromJson(m)).toList());

        if (cachedProducts.isNotEmpty && mounted) {
          List<GlobalKey> localCategories = [];
          for (var i = 0; i < cachedProducts.length; i++) {
            localCategories.add(GlobalKey());
          }

          setState(() {
            products = cachedProducts;
            categories = localCategories;
            isLoading = false;
          });

          // После установки данных из кэша все равно запускаем обновление из сети
          // но уже не показываем пользователю индикатор загрузки
        }
      }
    } catch (e) {
      print('Error loading cached products: ${e.toString()}');
      // Ошибки загрузки кэша не критичны, поэтому просто игнорируем их
    }
  }

  Future<void> _cacheProducts(List<ProductSection> productsToCache) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = productsToCache.map((p) => p.toJson()).toList();
      await prefs.setString('cached_products', jsonEncode(jsonData));
    } catch (e) {
      print('Error caching products: ${e.toString()}');
      // Ошибки сохранения кэша не критичны, поэтому просто игнорируем их
    }
  }

  Future<void> getProducts() async {
    if (!mounted) return;

    // Не показываем индикатор загрузки, если уже есть данные
    if (products.isEmpty) {
      setState(() {
        isLoading = true;
        hasNetworkError = false;
      });
    }

    try {
      City? currentCity = Hive.box<City>('currentCity').get('currentCity');
      String citySlug = 'tashkent';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      try {
        var urlCities = Uri.https('api.choparpizza.uz', '/api/cities/public');
        var responseCity =
            await httpClient.get(urlCities, headers: requestHeaders);

        if (responseCity.statusCode == 200) {
          var json = jsonDecode(responseCity.body);
          json['data'].forEach((element) {
            if (element['id'] == currentCity?.id) {
              citySlug = element['slug'];
            }
          });
        }

        var url = Uri.https('api.choparpizza.uz', '/api/products/public',
            {'perSection': '1', 'city_slug': citySlug});
        var response = await httpClient.get(url, headers: requestHeaders);

        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          List<ProductSection> productSections = List<ProductSection>.from(
              json['data'].map((m) => new ProductSection.fromJson(m)).toList());

          // Сохраняем данные в кэш
          _cacheProducts(productSections);

          List<GlobalKey> localCategories = [];
          for (var i = 0; i < productSections.length; i++) {
            localCategories.add(GlobalKey());
          }
          if (mounted) {
            setState(() {
              products = productSections;
              categories = localCategories;
              scrollCont.addListener(changeTabs);
              isLoading = false;
              hasNetworkError = false;
              retryCount = 0;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
              hasNetworkError = true;
            });
          }
        }
      } catch (networkError) {
        print('Network error in getProducts: $networkError');
        if (mounted) {
          setState(() {
            isLoading = false;
            hasNetworkError = true;
          });

          if (retryCount < 2) {
            // Auto-retry up to 2 times but with delay
            retryCount++;
            await Future.delayed(Duration(seconds: 2));
            getProducts();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(tr('product_unavailable')),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
                action: SnackBarAction(
                  label: tr('retry'),
                  onPressed: () {
                    setState(() {
                      retryCount = 0;
                    });
                    getProducts();
                  },
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error in getProducts: ${e.toString()}');
      if (mounted) {
        setState(() {
          isLoading = false;
          hasNetworkError = true;
        });
      }
    }
  }

  Future<void> fetchConfig() async {
    if (!mounted) return;

    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.choparpizza.uz', 'api/configs/public');

      try {
        var response = await httpClient.get(url, headers: requestHeaders);

        if (mounted && response.statusCode == 200) {
          var json = jsonDecode(response.body);
          Codec<String, String> stringToBase64 = utf8.fuse(base64);
          setState(() {
            configData = jsonDecode(stringToBase64.decode(json['data']));
          });
        }
      } catch (networkError) {
        print('Network error in fetchConfig: $networkError');
        // Config is not critical, so we don't show an error to the user
      }
    } catch (e) {
      print('Error in fetchConfig: ${e.toString()}');
    }
  }

  // scrollListening() {
  //   // print('listened');
  //   // print(verticalPositionsListener.itemPositions.value);
  //   verticalPositionsListener.itemPositions.addListener(() {
  //     ItemPosition min;
  //     print(verticalPositionsListener.itemPositions.value);
  //     if (verticalPositionsListener.itemPositions.value.isNotEmpty) {
  //       min = verticalPositionsListener.itemPositions.value.first;
  //       // print('Min Index $min');
  //       // print('Products count ${products.length}');
  //       // print(widget.parentScrollController.position.pixels);
  //       // print(widget.parentScrollController.position.maxScrollExtent);
  //       if (min.itemLeadingEdge < 0 &&
  //           widget.parentScrollController.position.maxScrollExtent !=
  //               widget.parentScrollController.position.pixels) {
  //         widget.parentScrollController.animateTo(
  //             widget.parentScrollController.position.maxScrollExtent,
  //             duration: Duration(milliseconds: 200),
  //             curve: Curves.easeIn);
  //       } else if (min.itemLeadingEdge == 0 &&
  //           min.index == 0 &&
  //           widget.parentScrollController.position.pixels != 0.0) {
  //         widget.parentScrollController.animateTo(0.0,
  //             duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  //       }
  //
  //       itemScrollController.scrollTo(
  //           index: min.index,
  //           duration: Duration(milliseconds: 200),
  //           curve: Curves.easeInOutCubic,
  //           alignment: 0.02);
  //
  //       if (scrolledIndex != min.index) {
  //         Future.delayed(const Duration(milliseconds: 200), () {
  //           setState(() {
  //             scrolledIndex = min.index;
  //           });
  //         });
  //       }
  //     }
  //   });
  // }

  Future<void> decreaseQuantity(Lines line) async {
    if (line.quantity == 1) {
      return;
    }

    try {
      Box<Basket> basketBox = Hive.box<Basket>('basket');
      Basket? basket = basketBox.get('basket');
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      try {
        var url = Uri.https(
            'api.choparpizza.uz',
            '/api/v1/basket-lines/${hashids.encode(line.id.toString())}/remove',
            {'quantity': '1'});
        var response = await httpClient.put(url, headers: requestHeaders);

        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);

          url = Uri.https(
              'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
          response = await httpClient.get(url, headers: requestHeaders);

          if (response.statusCode == 200 || response.statusCode == 201) {
            json = jsonDecode(response.body);
            setState(() {
              basketData = BasketData.fromJson(json['data']);
            });
          }
        }
      } catch (networkError) {
        print('Network error in decreaseQuantity: $networkError');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr('product_unavailable')),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('Error in decreaseQuantity: ${e.toString()}');
    }
  }

  Future<void> increaseQuantity(Lines line) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      Box<Basket> basketBox = Hive.box<Basket>('basket');
      Basket? basket = basketBox.get('basket');

      try {
        var url = Uri.https(
            'api.choparpizza.uz',
            '/api/v1/basket-lines/${hashids.encode(line.id.toString())}/add',
            {'quantity': '1'});
        var response = await httpClient.post(url, headers: requestHeaders);

        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);

          url = Uri.https(
              'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
          response = await httpClient.get(url, headers: requestHeaders);

          if (response.statusCode == 200 || response.statusCode == 201) {
            json = jsonDecode(response.body);
            setState(() {
              basketData = BasketData.fromJson(json['data']);
            });
          }
        }
      } catch (networkError) {
        print('Network error in increaseQuantity: $networkError');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tr('product_unavailable')),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('Error in increaseQuantity: ${e.toString()}');
    }
  }

  Widget productImage(String? image) {
    if (image != null && image.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.contain,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.image,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade100,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey.shade400,
              size: 40,
            ),
          ),
        ),
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        memCacheWidth: 800,
        memCacheHeight: 800,
        maxWidthDiskCache: 800,
        maxHeightDiskCache: 800,
        fadeInDuration: Duration(milliseconds: 200),
        cacheKey: image + "_optimized",
      );
    } else {
      return Container(
        color: Colors.grey.shade100,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey.shade400,
            size: 40,
          ),
        ),
      );
    }
  }

  Widget renderCreatePizza(BuildContext context, List<Items>? items) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          showMaterialModalBottomSheet(
            expand: false,
            context: context,
            isDismissible: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CreateOwnPizza(items),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: 'https://choparpizza.uz/createYourPizza.png',
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(
                        Icons.image,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey.shade400,
                      size: 40,
                    ),
                  ),
                ),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                fadeInDuration: Duration(milliseconds: 200),
                cacheKey: "createYourPizza_optimized",
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('create_your_pizza'),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        tr('select_your_favorite_ingredients'),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderThreePizza(BuildContext context, List<Items>? items) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.asset('assets/images/threepizza_new.jpg'),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Text(
                          'Создайте свою комбинацию из 3 пицц',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    isDismissible: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ThreePizzaWidget(items));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget renderGridProduct(BuildContext context, Items? product) {
    // Early safety check to avoid null reference errors
    if (product == null) {
      return SizedBox.shrink(); // Return empty widget if product is null
    }

    Lines? productLine;

    Box<Basket> basketBox = Hive.box<Basket>('basket');
    Basket? basket = basketBox.get('basket');
    if (basket != null) {
      if (basketData != null && basketData!.lines != null) {
        if (basketData!.lines!.length > 0) {
          basketData!.lines!.forEach((element) {
            if (product.variants != null) {
              product.variants!.forEach((variant) {
                if (element.variant != null &&
                    element.variant!.productId == variant.id) {
                  productLine = element;
                }
              });
            } else if (product.productId == element.id) {
              productLine = element;
            }
          });
        }
      }
    }

    Box<Stock> stockBox = Hive.box<Stock>('stock');
    Stock? stock = stockBox.get('stock');
    String? image = product?.image;
    final formatCurrency = new NumberFormat.currency(
        locale: 'ru_RU', symbol: tr('sum'), decimalDigits: 0);
    String productPrice = '';
    String beforePrice = '';

    if (product?.variants != null && product!.variants!.isNotEmpty) {
      productPrice = product.variants!.first.price;
    } else {
      productPrice = product!.price;
    }

    Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
    DeliveryType? deliveryType = box.get('deliveryType');

    Terminals? currentTerminal =
        Hive.box<Terminals>('currentTerminal').get('currentTerminal');

    if (configData?["discount_end_date"] != null &&
        deliveryType?.value == DeliveryTypeEnum.pickup &&
        currentTerminal != null &&
        configData?["discount_catalog_sections"]
            .split(',')
            .map((i) => int.parse(i))
            .contains(product.categoryId)) {
      if (DateTime.now().weekday.toString() !=
          configData?["discount_disable_day"]) {
        if (DateTime.now()
            .isBefore(DateTime.parse(configData?["discount_end_date"]))) {
          if (configData?["discount_value"] != null) {
            productPrice = (double.parse(productPrice) *
                    ((100 - double.parse(configData!["discount_value"])) / 100))
                .toString();

            if (product.variants != null && product.variants!.isNotEmpty) {
              beforePrice = product.variants!.first.price;
            } else {
              beforePrice = product.price;
            }
          }
        }
      }
    }

    productPrice = formatCurrency.format(double.tryParse(productPrice));

    bool isOutOfStock = false;

    if (stock != null) {
      if (stock.prodIds.length > 0) {
        if (product.variants != null) {
          if (product.variants!.isNotEmpty) {
            product.variants!.forEach((element) {
              if (stock.prodIds.indexOf(element.id) >= 0) {
                isOutOfStock = true;
              }
            });
          } else {
            if (stock.prodIds.indexOf(product.id) >= 0) {
              isOutOfStock = true;
            }
          }
        } else {
          if (stock.prodIds.indexOf(product.id) >= 0) {
            isOutOfStock = true;
          }
        }
      }
    }

    return Opacity(
      opacity: isOutOfStock ? 0.3 : 1,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        surfaceTintColor: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (isOutOfStock) {
              // Show message that product is out of stock
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tr('product_unavailable')),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }

            DeliveryLocationData? deliveryLocationData =
                Hive.box<DeliveryLocationData>('deliveryLocationData')
                    .get('deliveryLocationData');

            //Check pickup terminal
            if (deliveryType != null &&
                deliveryType.value == DeliveryTypeEnum.pickup) {
              if (currentTerminal == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr('pickup_branch_not_selected')),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
            }

            // Check delivery address
            if (deliveryType != null &&
                deliveryType.value == DeliveryTypeEnum.deliver) {
              if (deliveryLocationData == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr('delivery_address_not_specified')),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              } else if (deliveryLocationData.address == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr('delivery_address_not_specified')),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
            }

            showMaterialModalBottomSheet(
                expand: false,
                context: context,
                isDismissible: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ProductDetail(
                      detail: product,
                    ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      child: productImage(image),
                    ),
                  ),
                  if (beforePrice.isNotEmpty)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'СКИДКА',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  if (isOutOfStock)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'НЕТ В НАЛИЧИИ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getLocalizedText(product?.attributeData?.name?.chopar),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    RichText(
                      text: HTML.toTextSpan(
                        context,
                        getLocalizedText(
                            product?.attributeData?.description?.chopar),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (beforePrice.isNotEmpty)
                                Text(
                                  double.tryParse(beforePrice)!
                                      .toStringAsFixed(0),
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Text(
                                productPrice,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.yellow.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            width:
                                4), // Add a small gap between price and buttons
                        productLine != null
                            ? Container(
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(14)),
                                  color: Colors.grey.shade200,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize
                                      .min, // Make sure the row takes minimum space
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(14),
                                        onTap: () {
                                          decreaseQuantity(productLine!);
                                        },
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          alignment: Alignment.center,
                                          child: Icon(Icons.remove,
                                              size: 16.0,
                                              color: Colors.grey.shade700),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 28,
                                      alignment: Alignment.center,
                                      child: Text(
                                        productLine!.quantity.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(14),
                                        onTap: () {
                                          increaseQuantity(productLine!);
                                        },
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          alignment: Alignment.center,
                                          child: Icon(Icons.add,
                                              size: 16.0,
                                              color: Colors.grey.shade700),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 28,
                                child: ElevatedButton(
                                  child: Icon(
                                    isOutOfStock
                                        ? Icons.remove_shopping_cart
                                        : Icons.add_shopping_cart,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isOutOfStock
                                        ? Colors.grey.shade400
                                        : Colors.yellow.shade700,
                                    foregroundColor: Colors.white,
                                    elevation: isOutOfStock ? 0 : 0,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6),
                                    minimumSize: Size(28, 28),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: isOutOfStock
                                      ? null
                                      : () {
                                          showMaterialModalBottomSheet(
                                              expand: false,
                                              context: context,
                                              isDismissible: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) =>
                                                  ProductDetail(
                                                    detail: product,
                                                  ));
                                        },
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getSectionsList() {
    List<Widget> sections = [];

    List<Items> theeSomeProducts = [];
    products.asMap().forEach((index, section) {
      section.items?.forEach((element) {
        if (element.variants != null && element.variants!.isNotEmpty) {
          element.variants!.forEach((variant) {
            if (variant.threesome == 1) {
              theeSomeProducts.add(element);
            }
          });
        } else if (element.threesome == 1) {
          theeSomeProducts.add(element);
        }
      });
    });

    if (theeSomeProducts.isNotEmpty) {
      sections.add(ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (_, index) =>
            renderThreePizza(tabContext!, theeSomeProducts),
      ));
    }

    products.asMap().forEach((index, section) {
      sections.add(Container(
        key: categories[index],
        margin: EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getLocalizedText(section.attributeData?.name?.chopar),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ));

      if (section.halfMode == 1) {
        sections.add(ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (_, index) =>
              renderCreatePizza(tabContext!, section.items),
        ));
      } else if (section.threeSale == 1) {
        sections.add(ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (_, index) =>
              renderThreePizza(tabContext!, section.items),
        ));
      } else {
        sections.add(GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 12,
          ),
          itemCount: section.items?.length ?? 0,
          itemBuilder: (_, prodIndex) =>
              renderGridProduct(tabContext!, section.items?[prodIndex]),
        ));
      }
    });

    return sections;
  }

  changeTabs() {
    late RenderBox box;
    int scrolledIndex = 0;
    late Offset position;
    for (var i = 0; i < categories.length; i++) {
      box = categories[i].currentContext!.findRenderObject() as RenderBox;
      position = box.localToGlobal(Offset.zero);
      // print('Scroll ${scrollCont.offset}');
      // print('Position ${position.dy}');
      // Scrollable.of(tabContext!).v
      if (scrollCont.offset >= position.dy && position.dy < 250) {
        scrolledIndex = i;
        position = box.localToGlobal(Offset.zero);
      }
    }
    // print(scrolledIndex);
    // print(scrollCont.offset);
    // print(widget.parentScrollController.position.maxScrollExtent);
    if (scrolledIndex == 0) {
      if (scrollCont.offset == 0) {
        widget.parentScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 100), curve: Curves.easeIn);
      } else {
        widget.parentScrollController.animateTo(
            widget.parentScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn);
      }
    }
    DefaultTabController.of(tabContext!).animateTo(
      scrolledIndex,
      duration: Duration(milliseconds: 100),
    );
  }

  scrollTo(int index) async {
    scrollCont.removeListener(changeTabs);
    final category = categories[index].currentContext!;
    await Scrollable.ensureVisible(
      category,
      duration: Duration(milliseconds: 600),
    );
    scrollCont.addListener(changeTabs);
  }

  Widget _buildNetworkErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              tr('no_internet'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              tr('please_check_your_connection_and_try_again'),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  retryCount = 0;
                });
                getProducts();
              },
              icon: Icon(Icons.refresh),
              label: Text(tr('retry')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CircularProgressIndicator(
                    color: Colors.yellow.shade700,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
          Text(
            tr('loading'),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  double getProductHeight(ProductSection section) {
    double height = 160;

    if (section.halfMode == 1) {
      height = 200;
    } else if (section.threeSale == 1) {
      height = 200;
    } else {
      if (section.items != null && section.items!.length > 0) {
        // Calculate height for grid layout with 2 columns
        int rows = (section.items!.length / 2).ceil();
        height = (rows * 220) + 40;
      }
    }

    return height;
  }

  // Helper method to get localized text
  String getLocalizedText(dynamic chopar) {
    if (chopar == null) return '';

    final languageCode = context.locale.languageCode;

    if (languageCode == 'uz' && chopar.uz != null && chopar.uz.isNotEmpty) {
      return chopar.uz;
    } else if (languageCode == 'ru' &&
        chopar.ru != null &&
        chopar.ru.isNotEmpty) {
      return chopar.ru;
    } else {
      // Fallback to Russian if available
      return chopar.ru ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Stock>>(
        valueListenable: Hive.box<Stock>('stock').listenable(),
        builder: (context, box, _) {
          return ScrollsToTop(
            onScrollsToTop: (ScrollsToTopEvent event) async {
              scrollTo(0);
              DefaultTabController.of(tabContext!).animateTo(
                0,
                duration: Duration(milliseconds: 100),
              );
            },
            child: DefaultTabController(
                length: products.length > 0 ? products.length : 1,
                child: Builder(builder: (BuildContext context) {
                  tabContext = context;
                  return Expanded(
                      child: isLoading
                          ? _buildLoadingWidget()
                          : hasNetworkError
                              ? _buildNetworkErrorWidget()
                              : Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: TabBar(
                                        indicator: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.yellow.shade700,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        labelColor: Colors.white,
                                        unselectedLabelColor:
                                            Colors.grey.shade700,
                                        isScrollable: true,
                                        dividerHeight: 0,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        overlayColor: MaterialStatePropertyAll(
                                            Colors.transparent),
                                        tabAlignment: TabAlignment.center,
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        unselectedLabelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        labelPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        tabs: products.map((section) {
                                          return Tab(
                                            child: Text(
                                              getLocalizedText(section
                                                  .attributeData?.name?.chopar),
                                            ),
                                          );
                                        }).toList(),
                                        onTap: (int index) => scrollTo(index),
                                      ),
                                      height: 50,
                                    ),
                                    Expanded(
                                        child: SingleChildScrollView(
                                            controller: scrollCont,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: getSectionsList()))),
                                  ],
                                ));
                })),
          );
        });
  }
}
