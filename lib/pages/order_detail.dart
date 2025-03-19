import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopar_app/models/order.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/registered_review.dart';
import '../widgets/orders/track.dart';

class OrderDetailPage extends HookWidget {
  final String orderId;

  OrderDetailPage({required this.orderId}) {
    print("OrderDetailPage: Initialized with orderId: $orderId");
  }

  Widget renderProductImage(BuildContext context, Lines lineItem) {
    if (lineItem.child != null &&
        lineItem.child!.length > 0 &&
        lineItem.child![0].variant?.product?.id !=
            lineItem.variant?.product?.boxId) {
      if (lineItem.child!.length > 0) {
        return Container(
          height: 50.0,
          width: 70,
          // margin: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                  child: Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  Positioned(
                      left: 0,
                      child: Container(
                        child: CachedNetworkImage(
                            imageUrl:
                                'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}'),
                        width: 50,
                      )),
                ],
              )),
              Expanded(
                  child: Stack(
                children: [
                  ...lineItem.child!.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var e = entry.value;
                    print(((idx + 1) * 15).toDouble());
                    return Positioned(
                        right: ((idx + 1) * 0).toDouble(),
                        child: Container(
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  'https://api.choparpizza.uz/storage/${e.variant?.product?.assets![0].location}/${e.variant?.product?.assets![0].filename}'),
                          width: 50,
                        ));
                  }).toList()
                ],
              ))
            ],
          ),
        );
      } else {
        return Container(
          height: 50.0,
          width: 50,
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
                                'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}'),
                      ))
                ],
              )),
              Expanded(
                  child: Stack(
                children: [
                  Positioned(
                      right: 0,
                      child: Container(
                        child: CachedNetworkImage(
                            imageUrl:
                                'https://api.choparpizza.uz/storage/${lineItem.child![0].variant?.product?.assets![0].location}/${lineItem.child![0].variant?.product?.assets![0].filename}'),
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
              'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}');
    } else {
      return SvgPicture.network(
        'https://choparpizza.uz/no_photo.svg',
        width: 100.0,
        height: 73.0,
      );
    }
  }

  Widget build(BuildContext context) {
    final order = useState<Order?>(null);
    final product = useState(0.0);
    final equipment = useState(0.0);
    final delivery = useState(0.0);

    Future<void> loadOrder() async {
      print("OrderDetailPage: Loading order with ID: $orderId");
      Box<User> transaction = Hive.box<User>('user');
      User currentUser = transaction.get('user')!;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${currentUser.userToken}'
      };
      var url = Uri.https('api.choparpizza.uz', '/api/orders', {'id': orderId});
      print("OrderDetailPage: Making API request to: $url");
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        order.value = Order.fromJson(json);
        print("OrderDetailPage: Successfully loaded order: ${order.value?.id}");
      } else {
        print(
            "OrderDetailPage: Failed to load order. Status code: ${response.statusCode}");
      }
    }

    useEffect(() {
      loadOrder();
      return null;
    }, []);

    if (order.value == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(tr('loading')),
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      DateTime createdAt =
          DateTime.parse(order.value!.createdAt ?? '').toLocal();
      // createdAt = createdAt.toLocal();
      DateFormat createdAtFormat = DateFormat('MMM d, y, H:m', 'ru');
      final formatCurrency = new NumberFormat.currency(
          locale: 'ru_RU', symbol: tr('sum'), decimalDigits: 0);

      String house = order.value!.house != null
          ? ', ' + tr('house') + ': ${order.value!.house}'
          : '';
      String flat = order.value!.flat != null
          ? ', ' + tr('apartment') + ': ${order.value!.flat}'
          : '';
      String entrance = order.value!.entrance != null
          ? ', ' + tr('entrance') + ': ${order.value!.entrance}'
          : '';
      String doorCode = order.value!.doorCode != null
          ? ', ' + tr('door_code') + ': ${order.value!.doorCode}'
          : '';
      String address =
          '${order.value!.billingAddress}$house$flat$entrance$doorCode';

      return Scaffold(
        appBar: AppBar(
          title: Text(tr('order_number',
              namedArgs: {'id': order.value!.id.toString()})),
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '№ ${order.value!.id}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: order.value!.status == 'cancelled'
                                ? Colors.red.shade50
                                : order.value!.status == 'delivered'
                                    ? Colors.green.shade50
                                    : Colors.yellow.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tr('order_status_${order.value!.status}'),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: order.value!.status == 'cancelled'
                                  ? Colors.red
                                  : order.value!.status == 'delivered'
                                      ? Colors.green
                                      : Colors.yellow.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          createdAtFormat.format(createdAt),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200, thickness: 1),
                    order.value?.deliveryType == 'deliver'
                        ? Row(
                            children: [
                              Flexible(
                                  child: Text(address,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ))),
                            ],
                          )
                        : order.value?.terminalData != null
                            ? Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.store,
                                      color: Colors.grey.shade700,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        '${tr('branch')}: ${order.value?.terminalData?.name ?? ''}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              Lines lineItem =
                                  order.value!.basket!.lines![index];
                              double totalPrice = double.parse(
                                  order.value!.basket!.lines![index].total);
                              if (order.value!.basket!.lines![index].child !=
                                      null &&
                                  order.value!.basket!.lines![index].child!
                                      .isNotEmpty) {
                                if (order.value!.basket!.lines![index].child!
                                        .length ==
                                    1) {
                                  totalPrice = double.parse(order
                                          .value!.basket!.lines![index].total) +
                                      double.parse(order.value!.basket!
                                          .lines![index].child![0].total);
                                } else {
                                  totalPrice = double.parse(order
                                          .value!.basket!.lines![index].total) +
                                      double.parse(order.value!.basket!
                                          .lines![index].child![0].total) +
                                      double.parse(order.value!.basket!
                                          .lines![index].child![1].total);
                                }
                              }
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 6),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child:
                                          renderProductImage(context, lineItem),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${lineItem.child != null && lineItem.child!.length > 0 ? "${lineItem.variant?.product?.attributeData?.name?.chopar?.ru ?? ''} + ${lineItem.child![0].variant!.product!.attributeData?.name?.chopar?.ru}" : lineItem.variant?.product?.attributeData?.name?.chopar?.ru ?? ''}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${double.parse(order.value!.basket!.lines![index].total) > 0 ? lineItem.quantity.toString() + ' ' + tr('pcs') : ''}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${formatCurrency.format(totalPrice)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 2);
                            },
                            itemCount:
                                order.value!.basket?.lines?.length ?? 0)),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(color: Colors.grey.shade200, thickness: 1),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr("total_amount"),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formatCurrency.format(order.value!.orderTotal / 100),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.yellow.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    order.value?.deliveryType == 'deliver'
                        ? DefaultStyledButton(
                            width: double.infinity,
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                  context: context,
                                  enableDrag: false,
                                  bounce: true,
                                  builder: (context) =>
                                      TrackOrder(orderId: order.value!.id));
                            },
                            text: tr('track_order').toUpperCase(),
                          )
                        : const SizedBox(
                            width: double.infinity,
                          ),
                  ],
                ),
              ),
              ValueListenableBuilder<Box<RegisteredReview>>(
                  valueListenable:
                      Hive.box<RegisteredReview>('registeredReview')
                          .listenable(),
                  builder: (context, box, _) {
                    RegisteredReview? registeredView = box.get(order.value!.id);
                    if (registeredView == null) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(26)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Column(
                          children: [
                            Align(
                              heightFactor: 2,
                              alignment: Alignment.topLeft,
                              child: Text(tr("leave_review"),
                                  style: const TextStyle(fontSize: 20)),
                            ),
                            Text(tr("product"),
                                style: const TextStyle(fontSize: 18)),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                product.value = rating;
                              },
                            ),
                            Text(tr("packaging"),
                                style: const TextStyle(fontSize: 18)),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                equipment.value = rating;
                              },
                            ),
                            order.value?.deliveryType == 'deliver'
                                ? Text(tr("delivery"),
                                    style: const TextStyle(fontSize: 18))
                                : SizedBox(),
                            order.value?.deliveryType == 'deliver'
                                ? RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      delivery.value = rating;
                                    },
                                  )
                                : SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            DefaultStyledButton(
                                width: double.infinity,
                                onPressed: () async {
                                  if (product.value == 0.0 ||
                                      equipment.value == 0.0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(tr("select_first"))));
                                  } else {
                                    Map<String, String> requestHeaders = {
                                      'Content-type': 'application/json',
                                      'Accept': 'application/json',
                                    };
                                    var url = Uri.https('crm.choparpizza.uz',
                                        '/rest/1/5boca3dtup3vevqk/new.review.neutral');
                                    var response = await http.post(url,
                                        headers: requestHeaders,
                                        body: jsonEncode({
                                          "phone": order.value!.billingPhone,
                                          "order_id": order.value!.id,
                                          "project": "chopar",
                                          "product": product.value,
                                          "service": equipment.value,
                                          "courier": delivery.value
                                        }));
                                    if (response.statusCode == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text(tr("review_sent"))));
                                      RegisteredReview newRegisteredView =
                                          new RegisteredReview();
                                      newRegisteredView.orderId =
                                          order.value!.id;
                                      box.put(
                                          order.value!.id, newRegisteredView);
                                    }
                                  }
                                },
                                text: tr('send'))
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(26)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Center(
                          child: Text(tr('review_accepted')),
                        ),
                      );
                    }
                  }),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(10),
          child: DefaultStyledButton(
              width: double.infinity,
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              text: tr("main_page")),
        ),
      );
    }
  }
}
