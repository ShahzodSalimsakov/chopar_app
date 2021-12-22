import 'dart:convert';
import 'package:chopar_app/models/order.dart';
import 'package:chopar_app/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class OrderDetail extends HookWidget {
  final String orderId;

  OrderDetail({required this.orderId});

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
                          width: MediaQuery.of(context).size.width - 30,
                        ))
                  ],
                )),
            Expanded(
                child: Stack(
                  children: [
                    Positioned(
                        right: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 30,
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
    final order = useState<Order?>(null);

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
          ));
    } else {
      var t = AppLocalizations.of(context);
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
          '${order.value!.billingAddress}${house}${flat}${entrance}${doorCode}';

      return Scaffold(
        appBar: AppBar(
          title: Text('Заказ №${order.value!.id}'),
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
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '№ ${order.value!.id}',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                  Text(tr('order_status_${order.value!.status}'),
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
                height: 8,
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
                        Lines lineItem = order.value!.basket!.lines![index];
                        return ListTile(
                          title: Text(lineItem.variant?.product?.attributeData
                              ?.name?.chopar?.ru ??
                              ''),
                          leading: renderProductImage(context, lineItem),
                          trailing: Text(
                              '${double.parse(order.value!.basket!.lines![index].total) > 0 ? lineItem.quantity.toString() + 'X' : ''} ${formatCurrency.format(double.parse(order.value!.basket!.lines![index].total))}'),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: order.value!.basket?.lines?.length ?? 0)),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Общая сумма:", style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              )),
                  // Text(
                  //   t!.prodCount(order.basket?.lines?.length ?? 0),
                  //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  // ),
                  Text(formatCurrency.format(order.value!.orderTotal / 100),
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
      );
    }
  }
}
