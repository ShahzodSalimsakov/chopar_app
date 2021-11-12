import 'package:chopar_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetail extends HookWidget {
  final Order order;

  OrderDetail({required this.order});

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
                          width:
                          MediaQuery.of(context).size.width -
                              30,
                        ))
                  ],
                )),
            Expanded(
                child: Stack(
                  children: [
                    Positioned(
                        right: 0,
                        child: Container(
                          width:
                          MediaQuery.of(context).size.width -
                              30,
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
    var t = AppLocalizations.of(context);
    DateTime createdAt = DateTime.parse(order.createdAt ?? '');
    DateFormat createdAtFormat = DateFormat('MMM d, y, H:m', 'ru');
    final formatCurrency = new NumberFormat.currency(
        locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);

    String house = order.house != null ? ', дом: ${order.house}' : '';
    String flat = order.flat != null ? ', кв.: ${order.flat}' : '';
    String entrance =
        order.entrance != null ? ', подъезд: ${order.entrance}' : '';
    String doorCode =
        order.doorCode != null ? ', код на двери: ${order.doorCode}' : '';
    String address =
        '${order.billingAddress}${house}${flat}${entrance}${doorCode}';

    String currentStatus(String status) {
      switch (status) {
        case 'not-accepted':
          return t!.orderStatusNotAccepted;
        case 'not-confirmed':
          return t!.orderStatusNotConfirmed;
        case 'awaiting-payment':
          return t!.orderStatusAwaitingPayment;
        case 'accepted':
          return t!.orderStatusAccepted;
        case 'cooking':
          return t!.orderStatusCooking;
        case 'cooked':
          return t!.orderStatusCooked;
        case 'delivering':
          return t!.orderStatusDelivering;
        case 'done':
          return t!.orderStatusDone;
        default:
          return t!.orderStatusAccepted;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ №${order.id}'),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Container(
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '№ ${order.id}',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                ),
                Text(currentStatus(order.status),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.green))
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
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                    child: Text(address,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ))),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      Lines lineItem = order.basket!.lines![index];
                      return ListTile(
                        title: Text(lineItem.variant?.product?.attributeData
                                ?.name?.chopar?.ru ??
                            ''),
                        leading: renderProductImage(context, lineItem),
                        trailing:
                            Text(formatCurrency.format(order.orderTotal / 100)),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: order.basket?.lines?.length ?? 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t!.prodCount(order.basket?.lines?.length ?? 0),
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                Text(formatCurrency.format(order.orderTotal / 100),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
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
    );
  }
}
