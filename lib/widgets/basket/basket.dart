import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/basket_data.dart';
import 'package:chopar_app/models/related_product.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/pages/order_registration.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:chopar_app/utils/simplified_url.dart';
import 'package:chopar_app/widgets/profile/unautorised_user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../models/delivery_type.dart';

class BasketWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Box<Basket> basketBox = Hive.box<Basket>('basket');
    Basket? basket = basketBox.get('basket');
    final basketData = useState<BasketData?>(null);
    final isMounted = useValueNotifier<bool>(true);
    final relatedData =
        useState<List<RelatedProduct>>(List<RelatedProduct>.empty());
    final relatedBiData =
        useState<List<RelatedProduct>>(List<RelatedProduct>.empty());
    final topProducts =
        useState<List<RelatedProduct>>(List<RelatedProduct>.empty());
    final hashids = HashIds(
      salt: 'basket',
      minHashLength: 15,
      alphabet: 'abcdefghijklmnopqrstuvwxyz1234567890',
    );
    final _isBasketLoading = useState<bool>(false);

    // Future<void> checkBonusBasket() async {
    //   Box userBox = Hive.box<User>('user');
    //   User? user = userBox.get('user');
    //   if (basket != null && user != null) {
    //     Map<String, String> requestHeaders = {
    //       'Content-type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer ${user.userToken}'
    //     };

    //     Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
    //     DeliveryType? deliveryType = box.get('deliveryType');
    //     Map<String, dynamic> queryParameters = {
    //       'basketId': basket!.encodedId,
    //       'sourceType': 'app'
    //     };
    //     if (deliveryType?.value == DeliveryTypeEnum.pickup) {
    //       queryParameters["delivery_type"] = "pickup";
    //     }

    //     var url = Uri.https('api.choparpizza.uz',
    //         '/api/baskets/check-bonus-for-source/', queryParameters);
    //     var response = await http.get(url, headers: requestHeaders);
    //     if (response.statusCode == 200 || response.statusCode == 201) {
    //       var json = jsonDecode(response.body);
    //       BasketData basketLocalData = BasketData.fromJson(json['data']);
    //       if (basketLocalData.lines != null) {
    //         basket.lineCount = basketLocalData.lines!.length;
    //         basketBox.put('basket', basket);
    //       }
    //       basketData.value = basketLocalData;
    //     }
    //   }
    // }

    Future<void> destroyLine(int lineId) async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
      DeliveryType? deliveryType = box.get('deliveryType');
      Map<String, dynamic> queryParameters = {};
      if (deliveryType?.value == DeliveryTypeEnum.pickup) {
        queryParameters = {"delivery_type": "pickup"};
      }

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

        // await checkBonusBasket();
        if (!isMounted.value) return;
        if (isMounted.value) {
          url = Uri.https('api.choparpizza.uz',
              '/api/baskets/${basket!.encodedId}', queryParameters);
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
    }

    Future<void> decreaseQuantity(Lines line) async {
      if (line.quantity == 1) {
        return;
      }

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
      DeliveryType? deliveryType = box.get('deliveryType');
      Map<String, dynamic> queryParameters = {};
      if (deliveryType?.value == DeliveryTypeEnum.pickup) {
        queryParameters = {"delivery_type": "pickup"};
      }

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
        // await checkBonusBasket();

        url = Uri.https('api.choparpizza.uz',
            '/api/baskets/${basket!.encodedId}', queryParameters);
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

      Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
      DeliveryType? deliveryType = box.get('deliveryType');
      Map<String, dynamic> queryParameters = {};
      if (deliveryType?.value == DeliveryTypeEnum.pickup) {
        queryParameters = {"delivery_type": "pickup"};
      }

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
        // await checkBonusBasket();

        url = Uri.https('api.choparpizza.uz',
            '/api/baskets/${basket!.encodedId}', queryParameters);
        response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          json = jsonDecode(response.body);
          basketData.value = BasketData.fromJson(json['data']);
        }
      }
    }

    Widget renderProductImage(BuildContext context, Lines lineItem) {
      if (lineItem.child != null &&
          lineItem.child!.length > 0 &&
          lineItem.child![0].variant?.product?.id !=
              lineItem.variant?.product?.boxId) {
        if (lineItem.child!.length > 1) {
          return Container(
            height: 50.0,
            width: 70,
            // margin: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        child: Container(
                          child: lineItem.variant!.product!.assets!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl:
                                      'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
                                  height: 50,
                                )
                              : SvgPicture.network(
                                  'https://choparpizza.uz/no_photo.svg',
                                  width: 50.0,
                                  height: 50.0,
                                ),
                          // Image.network(
                          //   'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
                          //   height: 50,
                          // ),
                          width: 50,
                        )),
                    ...lineItem.child!.asMap().entries.map((entry) {
                      int idx = entry.key;
                      var e = entry.value;
                      print(((idx + 1) * 15).toDouble());
                      return Positioned(
                          left: ((idx + 1) * 10).toDouble(),
                          child: Container(
                            child: e.variant!.product!.assets!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl:
                                        'https://api.choparpizza.uz/storage/${e.variant?.product?.assets![0].location}/${e.variant?.product?.assets![0].filename}',
                                    height: 50,
                                  )
                                : SvgPicture.network(
                                    'https://choparpizza.uz/no_photo.svg',
                                    width: 50.0,
                                    height: 50.0,
                                  ),
                            // Image.network(
                            //   'https://api.choparpizza.uz/storage/${e.variant?.product?.assets![0].location}/${e.variant?.product?.assets![0].filename}',
                            //   height: 50,
                            // ),
                            width: 50,
                          ));
                    }).toList()
                  ],
                )),
              ],
            ),
          );
        } else {
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
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
                            height: 50,
                          ),
                          // Image.network(
                          //   'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
                          //   height: 50,
                          // ),
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
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://api.choparpizza.uz/storage/${lineItem.child![0].variant?.product?.assets![0].location}/${lineItem.child![0].variant?.product?.assets![0].filename}',
                            height: 50,
                          ),
                          // Image.network(
                          //   'https://api.choparpizza.uz/storage/${lineItem.child![0].variant?.product?.assets![0].location}/${lineItem.child![0].variant?.product?.assets![0].filename}',
                          //   height: 50,
                          // ),
                        ))
                  ],
                ))
              ],
            ),
          );
        }
      } else if (lineItem.variant?.product?.assets != null &&
          lineItem.variant!.product!.assets!.isNotEmpty) {
        return CachedNetworkImage(
            imageUrl:
                'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
            width: 50.0,
            height: 50.0);
        // Image.network(
        //   'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
        //   width: 50.0,
        //   height: 50.0,
        //   // width: MediaQuery.of(context).size.width / 2.5,
        // );
      } else {
        return SvgPicture.network(
          'https://choparpizza.uz/no_photo.svg',
          width: 50.0,
          height: 50.0,
        );
      }
    }

    Widget basketItems(Lines lines) {
      final formatCurrency = new NumberFormat.currency(
          locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
      String? productName = '';
      List? modifier = [];
      if (lines.child != null && lines.child!.length == 1) {
        productName = lines.variant!.product!.attributeData!.name!.chopar!.ru;
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
        if (lines.modifiers != null && lines.modifiers!.length > 1) {
          lines.modifiers!.forEach((element) {
            modifier.add(element.name);
          });
        } else {
          modifier.add(lines.modifiers?[0].name ?? '');
        }
      } else {
        productName = lines.variant!.product!.attributeData!.name!.chopar!.ru;

        if (lines.modifiers != null && lines.modifiers!.length > 1) {
          lines.modifiers!.forEach((element) {
            modifier.add(element.name);
          });
        } else {
          modifier.add(lines.modifiers?[0].name ?? '');
        }
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName!.toUpperCase(),
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              modifier.join(', ').toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.yellow.shade600),
                            ),
                          ],
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
                  lines.discountValue != null && lines.discountValue! > 0
                      ? Text(
                          formatCurrency.format(lines.total),
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.lineThrough),
                        )
                      : SizedBox(),
                  Text(
                    formatCurrency.format(
                      lines.discountValue != null && lines.discountValue! > 0
                          ? lines.total - lines.discountValue!
                          : lines.total,
                    ),
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
                        Center(
                            child: Text(
                          "Проведите пальцем влево, чтобы удалить продукт",
                          style: TextStyle(color: Colors.red),
                        )),
                        ListView.separated(
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
                        relatedBiData.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('С этими продуктами покупают',
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500))),
                              )
                            : const SizedBox(),
                        relatedBiData.value.isNotEmpty
                            ? SizedBox(
                                height: 240,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: relatedBiData.value.length,
                                    itemBuilder: (context, index) {
                                      final formatCurrency =
                                          NumberFormat.currency(
                                              locale: 'ru_RU',
                                              symbol: 'сум',
                                              decimalDigits: 0);
                                      String productPrice = '';

                                      productPrice =
                                          relatedBiData.value[index].price;

                                      productPrice = formatCurrency.format(
                                          double.tryParse(productPrice));
                                      return Container(
                                          width: 130,
                                          margin:
                                              const EdgeInsets.only(right: 10),
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
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: relatedBiData
                                                          .value[index].image,
                                                      height: 100,
                                                      width: 100,
                                                    ),
                                                    // Image.network(
                                                    //   relatedBiData
                                                    //       .value[index].image,
                                                    //   height: 100,
                                                    //   width: 100,
                                                    // ),
                                                    const Spacer(
                                                      flex: 1,
                                                    ),
                                                    Text(
                                                      relatedBiData.value[index]
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
                                                              relatedBiData
                                                                  .value[index]
                                                                  .id;

                                                          Box userBox =
                                                              Hive.box<User>(
                                                                  'user');
                                                          User? user = userBox
                                                              .get('user');
                                                          Box basketBox =
                                                              Hive.box<Basket>(
                                                                  'basket');
                                                          Basket? basket =
                                                              basketBox.get(
                                                                  'basket');

                                                          if (basket != null &&
                                                              basket.encodedId
                                                                  .isNotEmpty &&
                                                              basket.encodedId
                                                                  .isNotEmpty) {
                                                            Map<String, String>
                                                                requestHeaders =
                                                                {
                                                              'Content-type':
                                                                  'application/json',
                                                              'Accept':
                                                                  'application/json'
                                                            };

                                                            if (user != null) {
                                                              requestHeaders[
                                                                      'Authorization'] =
                                                                  'Bearer ${user.userToken}';
                                                            }

                                                            var url = Uri.https(
                                                                'api.choparpizza.uz',
                                                                '/api/baskets-lines');

                                                            Box<DeliveryType>
                                                                box = Hive.box<
                                                                        DeliveryType>(
                                                                    'deliveryType');
                                                            DeliveryType?
                                                                deliveryType =
                                                                box.get(
                                                                    'deliveryType');
                                                            var formData = {
                                                              'basket_id': basket
                                                                  .encodedId,
                                                              'variants': [
                                                                {
                                                                  'id':
                                                                      selectedProdId,
                                                                  'quantity': 1,
                                                                  'modifiers':
                                                                      selectedModifiers
                                                                }
                                                              ]
                                                            };
                                                            if (deliveryType
                                                                    ?.value ==
                                                                DeliveryTypeEnum
                                                                    .pickup) {
                                                              formData[
                                                                      "delivery_type"] =
                                                                  "pickup";
                                                            }

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
                                                                          json[
                                                                              'data']);
                                                              Basket newBasket = Basket(
                                                                  encodedId:
                                                                      basketLocalData
                                                                              .encodedId ??
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
                                                              basketData.value =
                                                                  basketLocalData;
                                                            }
                                                          } else {
                                                            Map<String, String>
                                                                requestHeaders =
                                                                {
                                                              'Content-type':
                                                                  'application/json',
                                                              'Accept':
                                                                  'application/json'
                                                            };

                                                            if (user != null) {
                                                              requestHeaders[
                                                                      'Authorization'] =
                                                                  'Bearer ${user.userToken}';
                                                            }

                                                            var url = Uri.https(
                                                                'api.choparpizza.uz',
                                                                '/api/baskets');

                                                            Box<DeliveryType>
                                                                box = Hive.box<
                                                                        DeliveryType>(
                                                                    'deliveryType');
                                                            DeliveryType?
                                                                deliveryType =
                                                                box.get(
                                                                    'deliveryType');
                                                            var formData = {
                                                              'variants': [
                                                                {
                                                                  'id':
                                                                      selectedProdId,
                                                                  'quantity': 1,
                                                                  'modifiers':
                                                                      selectedModifiers
                                                                }
                                                              ]
                                                            };
                                                            if (deliveryType
                                                                    ?.value ==
                                                                DeliveryTypeEnum
                                                                    .pickup) {
                                                              formData[
                                                                      "delivery_type"] =
                                                                  "pickup" as List<
                                                                      Map<String,
                                                                          Object?>>;
                                                            }
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
                                                                          json[
                                                                              'data']);
                                                              Basket newBasket = Basket(
                                                                  encodedId:
                                                                      basketLocalData
                                                                              .encodedId ??
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
                                                              basketData.value =
                                                                  basketLocalData;
                                                            }
                                                          }
                                                          _isBasketLoading
                                                              .value = true;

                                                          return;
                                                        },
                                                        child: Text(
                                                          productPrice,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                          )),
                                                          padding:
                                                              MaterialStateProperty
                                                                  .all(EdgeInsets
                                                                      .zero),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .yellow
                                                                      .shade700),
                                                        ),
                                                      ),
                                                    )
                                                  ])));
                                    }),
                              )
                            : const SizedBox(),
                        topProducts.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Популярные продукты',
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500))),
                              )
                            : const SizedBox(),
                        topProducts.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: SizedBox(
                                  height: 240,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topProducts.value.length,
                                      itemBuilder: (context, index) {
                                        final formatCurrency =
                                            NumberFormat.currency(
                                                locale: 'ru_RU',
                                                symbol: 'сум',
                                                decimalDigits: 0);
                                        String productPrice = '';

                                        productPrice =
                                            topProducts.value[index].price;

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
                                                      CachedNetworkImage(
                                                        imageUrl: topProducts
                                                            .value[index].image,
                                                        height: 100,
                                                        width: 100,
                                                      ),
                                                      // Image.network(
                                                      //   topProducts
                                                      //       .value[index].image,
                                                      //   height: 100,
                                                      //   width: 100,
                                                      // ),
                                                      const Spacer(
                                                        flex: 1,
                                                      ),
                                                      Text(
                                                        topProducts.value[index]
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
                                                                topProducts
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

                                                              Box<DeliveryType>
                                                                  box =
                                                                  Hive.box<
                                                                          DeliveryType>(
                                                                      'deliveryType');
                                                              DeliveryType?
                                                                  deliveryType =
                                                                  box.get(
                                                                      'deliveryType');
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
                                                              if (deliveryType
                                                                      ?.value ==
                                                                  DeliveryTypeEnum
                                                                      .pickup) {
                                                                formData[
                                                                        "delivery_type"] =
                                                                    "pickup";
                                                              }

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

                                                              Box<DeliveryType>
                                                                  box =
                                                                  Hive.box<
                                                                          DeliveryType>(
                                                                      'deliveryType');
                                                              DeliveryType?
                                                                  deliveryType =
                                                                  box.get(
                                                                      'deliveryType');
                                                              Map<String,
                                                                      dynamic>
                                                                  queryParameters =
                                                                  {};
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
                                                              if (deliveryType
                                                                      ?.value ==
                                                                  DeliveryTypeEnum
                                                                      .pickup) {
                                                                formData[
                                                                        "delivery_type"] =
                                                                    "pickup" as List<
                                                                        Map<String,
                                                                            Object?>>;
                                                              }
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
                                                            productPrice,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
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
                                                            padding:
                                                                MaterialStateProperty
                                                                    .all(EdgeInsets
                                                                        .zero),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.yellow.shade700),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                  ))))),
                      SizedBox(
                        height: 10,
                      ),
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

    Future<void> fetchBiRecomendedItems(BasketData basketData) async {
      if (basket != null) {
        List<String> productIds = [];

        if (basketData?.lines != null) {
          if (basketData!.lines!.length > 0) {
            for (var line in basketData!.lines!) {
              productIds.add(line.variant!.productId.toString());
            }
          }
        }

        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        var url = SimplifiedUri.uri(
            'https://api.choparpizza.uz/api/baskets/bi_related/',
            {"productIds": productIds});
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          if (isMounted.value) {
            if (json['data'] != null) {
              List<RelatedProduct> localBiRelatedProduct =
                  List<RelatedProduct>.from(json['data']['relatedItems']
                      .map((m) => RelatedProduct.fromJson(m))
                      .toList());
              relatedBiData.value = localBiRelatedProduct;
              List<RelatedProduct> topProduct = List<RelatedProduct>.from(
                  json['data']['topItems']
                      .map((m) => RelatedProduct.fromJson(m))
                      .toList());
              topProducts.value = topProduct;
            }
          }
        }
      }
    }

    Future<void> getBasket() async {
      if (basket != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
        DeliveryType? deliveryType = box.get('deliveryType');
        Map<String, dynamic> queryParameters = {};
        if (deliveryType?.value == DeliveryTypeEnum.pickup) {
          queryParameters = {"delivery_type": "pickup"};
        }

        var url = Uri.https('api.choparpizza.uz',
            '/api/baskets/${basket!.encodedId}', queryParameters);
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          if (isMounted.value) {
            BasketData basketLocalData = BasketData.fromJson(json['data']);
            if (basketLocalData.lines != null) {
              basket.lineCount = basketLocalData.lines!.length;
              basketBox.put('basket', basket);
            }
            basketData.value = basketLocalData;
            fetchBiRecomendedItems(basketLocalData);
          }
        }
      }
    }

    // Future<void> fetchRecomendedItems() async {
    //   if (basket != null) {
    //     Map<String, String> requestHeaders = {
    //       'Content-type': 'application/json',
    //       'Accept': 'application/json'
    //     };
    //
    //     var url = Uri.https(
    //         'api.choparpizza.uz', '/api/baskets/related/${basket.encodedId}');
    //     var response = await http.get(url, headers: requestHeaders);
    //     if (response.statusCode == 200 || response.statusCode == 201) {
    //       var json = jsonDecode(response.body);
    //       List<RelatedProduct> localRelatedProduct = List<RelatedProduct>.from(
    //           json['data'].map((m) => RelatedProduct.fromJson(m)).toList());
    //
    //       relatedData.value = localRelatedProduct;
    //     }
    //   }
    // }

    useEffect(() {
      getBasket();
      // fetchRecomendedItems();
      // checkBonusBasket();
      return () {
        isMounted.value = false;
      };
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
