import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:chopar_app/models/order.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../models/registered_review.dart';

class OrderDetail extends HookWidget {
  final String orderId;

  OrderDetail({Key? key, @PathParam() required this.orderId}) : super(key: key);

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
                        child: Image.network(
                          'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
                          height: 50,
                        ),
                        width: 50,
                      )),
                  ...lineItem.child!.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var e = entry.value;
                    print(((idx + 1) * 15).toDouble());
                    return Positioned(
                        left: ((idx + 1) * 10).toDouble(),
                        child: Container(
                          child: Image.network(
                            'https://api.choparpizza.uz/storage/${e.variant?.product?.assets![0].location}/${e.variant?.product?.assets![0].filename}',
                            height: 50,
                          ),
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
                        child: Image.network(
                          'https://api.choparpizza.uz/storage/${lineItem.variant?.product?.assets![0].location}/${lineItem.variant?.product?.assets![0].filename}',
                          height: 50,
                        ),
                        // width: MediaQuery.of(context).size.width - 30,
                      ))
                ],
              )),
              Expanded(
                  child: Stack(
                children: [
                  Positioned(
                      right: 0,
                      child: Container(
                        // width: MediaQuery.of(context).size.width - 30,
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
      }
    } else if (lineItem.variant?.product?.assets != null) {
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

  Widget build(BuildContext context) {
    final order = useState<Order?>(null);
    final product = useState(0.0);
    final equipment = useState(0.0);
    final delivery = useState(0.0);

    Future<void> loadOrder() async {
      Box<User> transaction = Hive.box<User>('user');
      User currentUser = transaction.get('user')!;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${currentUser.userToken}'
      };
      var url = Uri.https('api.choparpizza.uz', '/api/orders', {'id': orderId});
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        order.value = Order.fromJson(json);
      }
    }

    useEffect(() {
      loadOrder();
      return null;
    }, []);

    if (order.value == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Загрузка...'),
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
          locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);

      String house =
          order.value!.house != null ? ', дом: ${order.value!.house}' : '';
      String flat =
          order.value!.flat != null ? ', кв.: ${order.value!.flat}' : '';
      String entrance = order.value!.entrance != null
          ? ', подъезд: ${order.value!.entrance}'
          : '';
      String doorCode = order.value!.doorCode != null
          ? ', код на двери: ${order.value!.doorCode}'
          : '';
      String address =
          '${order.value!.billingAddress}$house$flat$entrance$doorCode';

      return Scaffold(
        appBar: AppBar(
          title: Text('Заказ №${order.value!.id}'),
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '№ ${order.value!.id}',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                        Text(tr('order_status_${order.value!.status}'),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: order.value!.status == 'cancelled'
                                    ? Colors.red
                                    : Colors.green))
                      ],
                    ),
                    Row(
                      children: [
                        Text(createdAtFormat.format(createdAt),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.grey)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
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
                            ? Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                          'Филиал: ${order.value?.terminalData?.name ?? ''}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ))),
                                ],
                              )
                            : SizedBox(),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
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
                              return ListTile(
                                title: Text(
                                    "${lineItem.child != null && lineItem.child!.length > 1 ? "${lineItem.variant?.product?.attributeData?.name?.chopar?.ru ?? ''} + ${lineItem.child![0].variant?.product?.customName} + ${lineItem.child![1].variant!.product!.customName}" : lineItem.variant?.product?.attributeData?.name?.chopar?.ru ?? ''}"),
                                leading: renderProductImage(context, lineItem),
                                trailing: Text(
                                    '${double.parse(order.value!.basket!.lines![index].total) > 0 ? lineItem.quantity.toString() + 'X' : ''} '
                                    '${formatCurrency.format(totalPrice)}'),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemCount:
                                order.value!.basket?.lines?.length ?? 0)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Общая сумма:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                        // Text(
                        //   t!.prodCount(order.basket?.lines?.length ?? 0),
                        //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                        // ),
                        Text(
                            formatCurrency
                                .format(order.value!.orderTotal / 100),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey,
                    )
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
                              child: Text("Оставьте отзыв",
                                  style: const TextStyle(fontSize: 20)),
                            ),
                            Text("Продукт",
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
                            Text("Комплектация",
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
                                ? Text("Доставка",
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
                                            content:
                                                Text(tr("Сначала выберите"))));
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
                                                  Text(tr("Отзыв отправлен"))));
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
                          child: Text('Ваш отзыв успешно принят'),
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
                // context.router.popUntil((route) => route.name == 'HomeRoute');
                // context.router.popUntilRouteWithName('HomePage');
                // context.router.popUntilRoot();
                // context.navigateNamedTo('HomePage');

                // Navigator.pushNamed(context, '/');
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(
                  '/',
                );
              },
              text: "Главная"),
        ),
      );
    }
  }
}
