import 'dart:convert';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/basket_data.dart';
import 'package:chopar_app/models/related_product.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/pages/order_registration.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:chopar_app/widgets/profile/unautorised_user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class BasketWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Box<Basket> basketBox = Hive.box<Basket>('basket');
    Basket? basket = basketBox.get('basket');
    final basketData = useState<BasketData?>(null);
    final relatedData =
        useState<List<RelatedProduct>>(List<RelatedProduct>.empty());
    final hashids = HashIds(
      salt: 'basket',
      minHashLength: 15,
      alphabet: 'abcdefghijklmnopqrstuvwxyz1234567890',
    );
    final _isBasketLoading = useState<bool>(false);

    Future<void> destroyLine(int lineId) async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      var url = Uri.https(
          'api.choparpizza.uz', '/api/basket-lines/${hashids.encode(lineId)}');
      var response = await http.delete(url, headers: requestHeaders);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        url = Uri.https(
            'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
        response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          BasketData newBasket = BasketData.fromJson(json['data']);
          if (newBasket!.lines == null) {
            basket.lineCount = 0;
          } else {
            basket.lineCount = newBasket!.lines!.length ?? 0;
          }

          basketBox.put('basket', basket);
          // await Future.delayed(Duration(milliseconds: 50));
          basketData.value = newBasket;
        }
      }
    }

    Future<void> decreaseQuantity(Lines line) async {
      if (line.quantity == 1) {
        return;
      }

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      var url = Uri.https(
          'api.choparpizza.uz',
          '/api/v1/basket-lines/${hashids.encode(line.id.toString())}/remove',
          {'quantity': '1'});
      var response = await http.put(url, headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        url = Uri.https(
            'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
        response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          json = jsonDecode(response.body);
          basketData.value = BasketData.fromJson(json['data']);
        }
      }
    }

    Future<void> increaseQuantity(Lines line) async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      var url = Uri.https(
          'api.choparpizza.uz',
          '/api/v1/basket-lines/${hashids.encode(line.id.toString())}/add',
          {'quantity': '1'});
      var response = await http.post(url, headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        url = Uri.https(
            'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
        response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          json = jsonDecode(response.body);
          basketData.value = BasketData.fromJson(json['data']);
        }
      }
    }

    String totalPrice = useMemoized(() {
      String result = '0';
      if (basketData.value != null) {
        result = basketData.value!.total.toString();
      }

      final formatCurrency = NumberFormat.currency(
          locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);

      result = formatCurrency.format(double.tryParse(result));
      return result;
    }, [basketData.value]);

    Widget renderProductImage(BuildContext context, Lines lineItem) {
      if (lineItem.child != null &&
          lineItem.child!.length > 0 &&
          lineItem.child![0].variant?.product?.id !=
              lineItem.variant?.product?.boxId) {
        return Container(
          height: 50.0,
          width: 50,
          // margin: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                  child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                      left: 0,
                      child: Container(
                        child: Image.network(
                          'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
                          height: 50,
                        ),
                        width: 50,
                      ))
                ],
              )),
              Expanded(
                  child: Stack(
                children: [
                  Positioned(
                      right: 0,
                      child: Container(
                        width: 50,
                        child: Image.network(
                          'https://api.choparpizza.uz/storage/${lineItem.child![0].variant?.product?.assets![0].location}/${lineItem.child![0].variant?.product?.assets![0].filename}',
                          height: 50,
                        ),
                      ))
                ],
              ))
            ],
          ),
        );
      } else if (lineItem.variant?.product?.assets != null &&
          lineItem.variant!.product!.assets!.isNotEmpty) {
        return Image.network(
          'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
          width: 50.0,
          height: 50.0,
          // width: MediaQuery.of(context).size.width / 2.5,
        );
      } else {
        return SvgPicture.network(
          'https://choparpizza.uz/no_photo.svg',
          width: 100.0,
          height: 73.0,
        );
      }
    }

    Widget basketItems(Lines lines) {
      final formatCurrency = new NumberFormat.currency(
          locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
      String? productName = '';
      var productTotalPrice = 0;
      if (lines.child != null && lines.child!.length > 1) {
        productName = lines.variant!.product!.attributeData!.name!.chopar!.ru;
        productTotalPrice = (int.parse(
                    double.parse(lines.total ?? '0.0000').toStringAsFixed(0)) +
                int.parse(double.parse(lines.child![0].total ?? '0.0000')
                    .toStringAsFixed(0))) *
            lines.quantity;
        String childsName = lines.child!
            .where((Child child) =>
                lines.variant!.product!.boxId != child.variant!.product!.id)
            .map((Child child) =>
                child.variant!.product!.attributeData!.name!.chopar!.ru)
            .join(' + ')
            .toString();
        if (childsName.length > 0) {
          productName = '$productName + $childsName';
        }
      } else {
        productName = lines.variant!.product!.attributeData!.name!.chopar!.ru;
        productTotalPrice =
            int.parse(double.parse(lines.total ?? '0.0000').toStringAsFixed(0));
      }
      return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          // padding: EdgeInsets.symmetric(
          //   horizontal: 15,
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  renderProductImage(context, lines),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        child: Text(
                          productName ?? '',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      lines.bonusId != null
                          ? Text(
                              tr('bonus'),
                              style: TextStyle(
                                  fontSize: 18, color: Colors.yellow.shade600),
                            )
                          : SizedBox()
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    formatCurrency.format(productTotalPrice),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  lines.bonusId == null
                      ? Container(
                          height: 30.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.yellow.shade600,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.remove,
                                    size: 20.0, color: Colors.yellow.shade600),
                                onPressed: () {
                                  decreaseQuantity(lines);
                                },
                              ),
                              Text(
                                lines.quantity.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.yellow.shade600,
                                    fontWeight: FontWeight.w700),
                              ),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.add,
                                      size: 20.0,
                                      color: Colors.yellow.shade600),
                                  onPressed: () {
                                    increaseQuantity(lines);
                                  })
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              lines.quantity == 1
                  ? IconButton(
                      icon: Icon(
                        Icons.close_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        destroyLine(lines.id);
                      },
                    )
                  : SizedBox(
                      width: 0,
                    )
            ],
          ));
    }

    Widget renderPage() {
      final formatCurrency = new NumberFormat.currency(
          locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
      Basket? basket = basketBox.get('basket');
      if (basket == null) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/empty_cart.png'),
              Text(
                'Корзина пуста',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        );
      } else if (basket != null && basket.lineCount == 0) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/empty_cart.png'),
              Text(
                'Корзина пуста',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        );
      } else if (basketData.value != null && basketData.value?.lines == null) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/empty_cart.png'),
              Text(
                'Корзина пуста',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        );
      } else if (basketData.value != null) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text("Проведите пальцем влево, чтобы удалить продукт"), ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: basketData.value!.lines!.length ?? 0,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemBuilder: (context, index) {
                                final item = basketData.value!.lines![index];
                                return item.bonusId != null
                                    ? basketItems(item)
                                    : Dismissible(
                                        direction: DismissDirection.endToStart,
                                        key: Key(item.id.toString()),
                                        child: basketItems(item),
                                        background: Container(
                                          color: Colors.red,
                                        ),
                                        onDismissed:
                                            (DismissDirection direction) {
                                          destroyLine(item.id);
                                        },
                                        secondaryBackground: Container(
                                          color: Colors.red,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.white),
                                                Text('Удалить',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                              }),
                        relatedData.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 45,
                                  bottom: 10,
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        'Рекомендуем к Вашему заказу',
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500))),
                              )
                            : const SizedBox(),
                        relatedData.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: SizedBox(
                                  height: 240,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: relatedData.value.length,
                                      itemBuilder: (context, index) {
                                        final formatCurrency =
                                            NumberFormat.currency(
                                                locale: 'ru_RU',
                                                symbol: 'сум',
                                                decimalDigits: 0);
                                        String productPrice = '';

                                        productPrice =
                                            relatedData.value[index].price;

                                        productPrice = formatCurrency.format(
                                            double.tryParse(productPrice));
                                        return Container(
                                            width: 130,
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.network(
                                                        relatedData
                                                            .value[index].image,
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                      const Spacer(
                                                        flex: 1,
                                                      ),
                                                      Text(
                                                        relatedData.value[index]
                                                            .customName,
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const Spacer(
                                                        flex: 1,
                                                      ),
                                                      SizedBox(
                                                        height: 50,
                                                        width: 144,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            List<
                                                                    Map<String,
                                                                        int>>?
                                                                selectedModifiers;
                                                            _isBasketLoading
                                                                .value = true;

                                                            int selectedProdId =
                                                                relatedData
                                                                    .value[
                                                                        index]
                                                                    .id;

                                                            Box userBox =
                                                                Hive.box<User>(
                                                                    'user');
                                                            User? user = userBox
                                                                .get('user');
                                                            Box basketBox = Hive
                                                                .box<Basket>(
                                                                    'basket');
                                                            Basket? basket =
                                                                basketBox.get(
                                                                    'basket');

                                                            if (basket !=
                                                                    null &&
                                                                basket.encodedId
                                                                    .isNotEmpty &&
                                                                basket.encodedId
                                                                    .isNotEmpty) {
                                                              Map<String,
                                                                      String>
                                                                  requestHeaders =
                                                                  {
                                                                'Content-type':
                                                                    'application/json',
                                                                'Accept':
                                                                    'application/json'
                                                              };

                                                              if (user !=
                                                                  null) {
                                                                requestHeaders[
                                                                        'Authorization'] =
                                                                    'Bearer ${user.userToken}';
                                                              }

                                                              var url = Uri.https(
                                                                  'api.choparpizza.uz',
                                                                  '/api/baskets-lines');
                                                              var formData = {
                                                                'basket_id': basket
                                                                    .encodedId,
                                                                'variants': [
                                                                  {
                                                                    'id':
                                                                        selectedProdId,
                                                                    'quantity':
                                                                        1,
                                                                    'modifiers':
                                                                        selectedModifiers
                                                                  }
                                                                ]
                                                              };
                                                              var response = await http.post(
                                                                  url,
                                                                  headers:
                                                                      requestHeaders,
                                                                  body: jsonEncode(
                                                                      formData));
                                                              if (response.statusCode ==
                                                                      200 ||
                                                                  response.statusCode ==
                                                                      201) {
                                                                var json =
                                                                    jsonDecode(
                                                                        response
                                                                            .body);
                                                                BasketData
                                                                    basketLocalData =
                                                                    BasketData
                                                                        .fromJson(
                                                                            json['data']);
                                                                Basket newBasket = Basket(
                                                                    encodedId:
                                                                        basketLocalData.encodedId ??
                                                                            '',
                                                                    lineCount: basketLocalData
                                                                            .lines
                                                                            ?.length ??
                                                                        0,
                                                                    totalPrice:
                                                                        basketLocalData
                                                                            .total);
                                                                basketBox.put(
                                                                    'basket',
                                                                    newBasket);
                                                                basketData
                                                                        .value =
                                                                    basketLocalData;
                                                              }
                                                            } else {
                                                              Map<String,
                                                                      String>
                                                                  requestHeaders =
                                                                  {
                                                                'Content-type':
                                                                    'application/json',
                                                                'Accept':
                                                                    'application/json'
                                                              };

                                                              if (user !=
                                                                  null) {
                                                                requestHeaders[
                                                                        'Authorization'] =
                                                                    'Bearer ${user.userToken}';
                                                              }

                                                              var url = Uri.https(
                                                                  'api.choparpizza.uz',
                                                                  '/api/baskets');
                                                              var formData = {
                                                                'variants': [
                                                                  {
                                                                    'id':
                                                                        selectedProdId,
                                                                    'quantity':
                                                                        1,
                                                                    'modifiers':
                                                                        selectedModifiers
                                                                  }
                                                                ]
                                                              };
                                                              var response = await http.post(
                                                                  url,
                                                                  headers:
                                                                      requestHeaders,
                                                                  body: jsonEncode(
                                                                      formData));
                                                              if (response.statusCode ==
                                                                      200 ||
                                                                  response.statusCode ==
                                                                      201) {
                                                                var json =
                                                                    jsonDecode(
                                                                        response
                                                                            .body);
                                                                BasketData
                                                                    basketLocalData =
                                                                    BasketData
                                                                        .fromJson(
                                                                            json['data']);
                                                                Basket newBasket = Basket(
                                                                    encodedId:
                                                                        basketLocalData.encodedId ??
                                                                            '',
                                                                    lineCount: basketLocalData
                                                                            .lines
                                                                            ?.length ??
                                                                        0,
                                                                    totalPrice:
                                                                        basketLocalData
                                                                            .total);
                                                                basketBox.put(
                                                                    'basket',
                                                                    newBasket);
                                                                basketData
                                                                        .value =
                                                                    basketLocalData;
                                                              }
                                                            }
                                                            _isBasketLoading
                                                                .value = true;

                                                            return;
                                                          },
                                                          child: Text(
                                                              productPrice),
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0),
                                                            )),
                                                            backgroundColor:
                                                                MaterialStateProperty.all<
                                                                        Color>(
                                                                    Colors
                                                                        .yellow
                                                                        .shade700),
                                                          ),
                                                        ),
                                                      )
                                                    ])));
                                      }),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      // Container(
                      //   height: 60,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         '${basket.lineCount} товар',
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w400, fontSize: 18),
                      //       ),
                      //       Text(
                      //           formatCurrency
                      //               .format(basketData.value?.total ?? 0),
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w400, fontSize: 18))
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   height: 60,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         'Доставка',
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w400, fontSize: 18),
                      //       ),
                      //       Text('10 000 сум',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w400, fontSize: 18))
                      //     ],
                      //   ),
                      // ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Итого:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
                            ),
                            Text(
                                formatCurrency
                                    .format(basketData.value?.total ?? 0),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderRegistration(),
                                  ),
                                );
                              },
                              child: Text(
                                'Оформить заказ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.yellow.shade700),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                  )))))
                    ],
                  ),
                )
              ],
            ));
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    }

    Future<void> getBasket() async {
      if (basket != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        var url = Uri.https(
            'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          BasketData basketLocalData = BasketData.fromJson(json['data']);
          if (basketLocalData.lines != null) {
            basket.lineCount = basketLocalData.lines!.length;
            basketBox.put('basket', basket);
          }
          basketData.value = basketLocalData;
        }
      }
    }

    Future<void> fetchRecomendedItems() async {
      if (basket != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        var url = Uri.https(
            'api.choparpizza.uz', '/api/baskets/related/${basket.encodedId}');
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          List<RelatedProduct> localRelatedProduct = List<RelatedProduct>.from(
              json['data'].map((m) => RelatedProduct.fromJson(m)).toList());

          relatedData.value = localRelatedProduct;
        }
      }
    }

    useEffect(() {
      getBasket();
      fetchRecomendedItems();
    }, []);

    return ValueListenableBuilder<Box<User>>(
        valueListenable: Hive.box<User>('user').listenable(),
        builder: (context, box, _) {
          bool isUserAuthorized = UserRepository().isAuthorized();
          if (isUserAuthorized) {
            return ValueListenableBuilder(
                valueListenable: Hive.box<Basket>('basket').listenable(),
                builder: (context, box, _) {
                  return Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 50,
                      title: Text('Корзина'),
                      titleTextStyle:
                          TextStyle(fontSize: 20, color: Colors.black),
                      centerTitle: true,
                      backgroundColor: Colors.white,
                      // actions: <Widget>[
                      //   IconButton(
                      //     icon: Icon(
                      //       Icons.delete,
                      //       color: Colors.grey,
                      //     ),
                      //     onPressed: () {
                      //       // do something
                      //     },
                      //   )
                      // ],
                    ),
                    body: renderPage(),
                  );
                });
          } else {
            return UnAuthorisedUserPage(
              title: 'Корзина',
            );
          }
        });
  }
}
