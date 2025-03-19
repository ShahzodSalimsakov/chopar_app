import 'dart:convert';

import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../models/basket.dart';
import '../../models/basket_data.dart';
import '../../models/delivery_type.dart';
import '../../models/stock.dart';
import '../../models/user.dart';

class ThreePizzaWidget extends HookWidget {
  final formatCurrency = new NumberFormat.currency(
      locale: 'ru_RU', symbol: tr('sum'), decimalDigits: 0);
  final List<Items>? items;

  ThreePizzaWidget(this.items);

  // Widget modifierImage(Modifiers mod) {
  //   if (mod.assets != null && mod.assets!.isNotEmpty) {
  //     // print('https://api.choparpizza.uz/storage/${mod.assets![0].location}/${mod.assets![0].filename}');
  //     return Image.network(
  //       'https://api.choparpizza.uz/storage/${mod.assets![0].location}/${mod.assets![0].filename}',
  //       width: 100.0,
  //       height: 73.0,
  //       // width: MediaQuery.of(context).size.width / 2.5,
  //     );
  //   } else {
  //     if (mod.xmlId.isNotEmpty) {
  //       return ClipOval(
  //         child: SvgPicture.network(
  //           'https://choparpizza.uz/no_photo.svg',
  //           width: 100.0,
  //           height: 73.0,
  //         ),
  //       );
  //     } else {
  //       return Image.network(
  //         'https://choparpizza.uz/sausage_modifier.png',
  //         width: 100.0,
  //         height: 73.0,
  //         // width: MediaQuery.of(context).size.width / 2.5,
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final rightSelectedProduct = useState<List<int>>([]);
    final newRender = useState<bool>(false);
    final isBasketLoading = useState<bool>(false);
    final configData = useState<Map<String, dynamic>?>(null);

    // changeToSecondPage() {
    //   if (leftSelectedProduct.value == null ||
    //       rightSelectedProduct.value == null) {
    //     return;
    //   }

    //   isSecondPage.value = true;
    // }

    final customNames = useMemoized(() {
      Map<String, String> names = {};
      items!.forEach((Items item) {
        names[item.customName] = item.customName;
      });
      return names.keys.toList();
    }, [items]);

    final activeCustomName = useState<String>(customNames[0]);

    final readyProductList = useMemoized(() {
      Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
      DeliveryType? deliveryType = box.get('deliveryType');

      Terminals? currentTerminal =
          Hive.box<Terminals>('currentTerminal').get('currentTerminal');
      return items?.map((Items item) {
        item.variants?.forEach((Variants vars) {
          if (vars.customName == activeCustomName.value) {
            item.price = vars.price;
          }
        });

        item.beforePrice = null;
        if (configData.value?["discount_end_date"] != null &&
            deliveryType?.value == DeliveryTypeEnum.pickup &&
            currentTerminal != null &&
            configData.value?["discount_catalog_sections"]
                .split(',')
                .map((i) => int.parse(i))
                .contains(item.categoryId)) {
          if (DateTime.now().weekday.toString() !=
              configData.value?["discount_disable_day"]) {
            if (DateTime.now().isBefore(
                DateTime.parse(configData.value?["discount_end_date"]))) {
              if (configData.value?["discount_value"] != null) {
                item.beforePrice = int.parse(
                    double.parse(item.price ?? '0.0000').toStringAsFixed(0));
                item.price = (double.parse(item.price) *
                        ((100 -
                                double.parse(
                                    configData.value!["discount_value"])) /
                            100))
                    .toString();
              }
            }
          }
        }

        return item;
      }).toList();
    }, [items, activeCustomName.value, configData.value]);

    void selectProduct(int productId) {
      // if productId exists in rightSelectedProduct.value
      // then remove it
      // else add it
      List<int> currentSelected = rightSelectedProduct.value;

      if (rightSelectedProduct.value.contains(productId)) {
        currentSelected.remove(productId);
      } else {
        if (rightSelectedProduct.value.length < 3) {
          currentSelected.add(productId);
        } else {
          currentSelected.removeAt(2);
          currentSelected.add(productId);
        }
      }

      rightSelectedProduct.value = currentSelected;

      newRender.value = !newRender.value;
    }

    Future<void> fetchConfig() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.choparpizza.uz', 'api/configs/public');
      var response = await http.get(url, headers: requestHeaders);

      var json = jsonDecode(response.body);
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      configData.value = jsonDecode(stringToBase64.decode(json['data']));
    }

    useEffect(() {
      activeCustomName.value = customNames[0];
      fetchConfig();
      return null;
    }, [customNames]);

    Future<void> addToBasket() async {
      isBasketLoading.value = true;
      List<int> selectedProductIds = rightSelectedProduct.value;

      if (selectedProductIds.length < 3) {
        return;
      }

      Box userBox = Hive.box<User>('user');
      User? user = userBox.get('user');
      Box basketBox = Hive.box<Basket>('basket');
      Basket? basket = basketBox.get('basket');

      int firstProductId = selectedProductIds[0];
      selectedProductIds.removeAt(0);
      if (basket != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        if (user != null) {
          requestHeaders['Authorization'] = 'Bearer ${user.userToken}';
        }

        var url = Uri.https('api.choparpizza.uz', '/api/baskets-lines');
        var formData = {
          'basket_id': basket.encodedId,
          'sourceType': "app",
          'variants': [
            {
              'id': firstProductId,
              'quantity': 1,
              'modifiers': null,
              'three': selectedProductIds
            }
          ],
        };
        var response = await http.post(url,
            headers: requestHeaders, body: jsonEncode(formData));
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          BasketData basketData = new BasketData.fromJson(json['data']);
          Basket newBasket = new Basket(
              encodedId: basketData.encodedId ?? '',
              lineCount: basketData.lines?.length ?? 0);
          basketBox.put('basket', newBasket);
        }
      } else {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        if (user != null) {
          requestHeaders['Authorization'] = 'Bearer ${user.userToken}';
        }

        var url = Uri.https('api.choparpizza.uz', '/api/baskets');
        var formData = {
          'variants': [
            {
              'id': firstProductId,
              'quantity': 1,
              'modifiers': null,
              'three': selectedProductIds
            }
          ],
        };
        var response = await http.post(url,
            headers: requestHeaders, body: jsonEncode(formData));
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          BasketData basketData = new BasketData.fromJson(json['data']);
          Basket newBasket = new Basket(
              encodedId: basketData.encodedId ?? '',
              lineCount: basketData.lines?.length ?? 0);
          basketBox.put('basket', newBasket);
        }
      }
      isBasketLoading.value = false;
      Navigator.of(context).pop();
    }

    Widget renderPage(BuildContext context) {
      Box<Stock> stockBox = Hive.box<Stock>('stock');
      Stock? stock = stockBox.get('stock');
      return Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(readyProductList?.length ?? 0, (index) {
                bool isInStock = false;
                if (stock != null) {
                  if (stock.prodIds.length > 0) {
                    if (readyProductList?[index].variants != null) {
                      readyProductList?[index].variants!.forEach((element) {
                        if (stock.prodIds.indexOf(element.id) >= 0) {
                          isInStock = true;
                        }
                      });
                    } else {
                      if (stock.prodIds.indexOf(readyProductList![index].id) >=
                          0) {
                        isInStock = true;
                      }
                    }
                  }
                }
                return GestureDetector(
                  onTap: () {
                    if (isInStock) {
                      return;
                    } else {
                      selectProduct(readyProductList?[index].id ?? 0);
                    }
                  },
                  child: Opacity(
                    opacity: isInStock ? 0.25 : 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23.0),
                          border: Border.all(
                              color: rightSelectedProduct.value.contains(
                                      readyProductList?[index].id ?? 0)
                                  ? Colors.yellow.shade600
                                  : Colors.transparent,
                              width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  readyProductList?[index].image ?? '',
                                  width: 110,
                                  height: 110,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  readyProductList?[index]
                                          .attributeData
                                          ?.name
                                          ?.chopar
                                          ?.ru
                                          ?.toUpperCase() ??
                                      '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            child: rightSelectedProduct.value
                                    .contains(readyProductList![index].id)
                                ? Icon(Icons.check_circle_outline,
                                    color: Colors.yellow.shade600)
                                : SizedBox(width: 0.0),
                            width: 10.0,
                            height: 10.0,
                            top: 10.0,
                            right: 25.0,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: DefaultStyledButton(
              text: '${tr('to_cart')}',
              onPressed: () {
                addToBasket();
              },
              width: MediaQuery.of(context).size.width,
              color: rightSelectedProduct.value == null
                  ? [Colors.grey.shade300, Colors.grey.shade300]
                  : null,
            ),
          )
        ],
      );
    }

    Future<bool> _onBackPressed() {
      Navigator.of(context).pop();
      return Future.value(false);
    }

    print(rightSelectedProduct.value);

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back), onPressed: _onBackPressed),
            title: Text(
              tr('choose_product'),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: renderPage(context),
          ),
        ));
  }
}
