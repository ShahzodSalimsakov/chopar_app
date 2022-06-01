import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:chopar_app/models/order.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/pages/order_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Orders extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final orders = useState<List<Order>>(List<Order>.empty());
    var t = AppLocalizations.of(context);
    //is loading
    var isLoading = useState(true);

    Future<void> getMyOrders() async {
      Box box = Hive.box<User>('user');
      User currentUser = box.get('user');
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${currentUser.userToken}'
      };
      var url = Uri.https('api.choparpizza.uz', '/api/my-orders');
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Order> orderList = List<Order>.from(
            json['data'].map((m) => new Order.fromJson(m)).toList());
        orders.value = orderList;
        isLoading.value = false;
      }
    }

    useEffect(() {
      initializeDateFormatting();
      getMyOrders();
      return null;
    }, []);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Text('Мои заказы',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        ),
        body: SafeArea(
            child: Container(
          // padding: EdgeInsets.all(15),
          // color: Colors.grey.shade300,
          child: isLoading.value
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: orders.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime createdAt =
                        DateTime.parse(orders.value[index].createdAt ?? '')
                            .toLocal();
                    DateFormat createdAtFormat =
                        DateFormat('MMM d, y, H:m', 'ru');
                    Order order = orders.value[index];
                    String house =
                        order.house != null ? ', дом: ${order.house}' : '';
                    String flat =
                        order.flat != null ? ', кв.: ${order.flat}' : '';
                    String entrance = order.entrance != null
                        ? ', подъезд: ${order.entrance}'
                        : '';
                    String doorCode = order.doorCode != null
                        ? ', код на двери: ${order.doorCode}'
                        : '';
                    String address =
                        '${order.billingAddress}${house}${flat}${entrance}${doorCode}';

                    final hashids = HashIds(
                      salt: 'order',
                      minHashLength: 15,
                      alphabet: 'abcdefghijklmnopqrstuvwxyz1234567890',
                    );

                    final formatCurrency = new NumberFormat.currency(
                        locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
                    return Container(
                      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '№ ${order.id}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              Text(tr('order_status_${order.status}'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: order.status == 'cancelled'
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
                          SizedBox(
                            height: 10,
                          ),
                          order.deliveryType == 'deliver'
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
                              : order.terminalData != null
                                  ? Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                                'Филиал: ${order.terminalData?.name ?? ''}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                ))),
                                      ],
                                    )
                                  : SizedBox(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   t!.prodCount(order.basket?.lines?.length ?? 0),
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.w400, fontSize: 16),
                              // ), // TODO: fix plural data
                              Text(
                                  formatCurrency.format(order.orderTotal / 100),
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
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    context.router.pushNamed(
                                        'order/${hashids.encode(order.id)}');
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => OrderDetail(
                                    //         orderId: hashids.encode(order.id)),
                                    //   ),
                                    // );
                                  },
                                  child: Text(
                                    'Детали заказа',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade600),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey.shade300),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.0),
                                      )))))
                        ],
                      ),
                    );
                  }),
        )));
  }
}
