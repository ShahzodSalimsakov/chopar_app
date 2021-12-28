import 'dart:convert';
import 'package:chopar_app/models/order.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/pages/order_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderStatus extends HookWidget {
  Widget build(BuildContext context) {
    final orders = useState<List<Order>>(List<Order>.empty());
    var t = AppLocalizations.of(context);

    Future<void> getMyOrders() async {
      Box box = Hive.box<User>('user');
      User? currentUser = box.get('user');
      if (currentUser != null) {
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
          orders.value = orderList.where((s) => s.status == 'cooking').toList();
        }
      }
    }

    useEffect(() {
      getMyOrders();
    }, []);

    return orders.value.length > 0 ? Container(
      padding: EdgeInsets.all(0),
      height: 80,
        child: Card(
          elevation: 2,
          child: Column(
            children: [
              Row(children: [
                Text("Активный заказ", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
              ], mainAxisAlignment: MainAxisAlignment.center,),
              ListView.builder(
                shrinkWrap: true,
                  itemCount: orders.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    final hashids = HashIds(
                      salt: 'order',
                      minHashLength: 15,
                      alphabet: 'abcdefghijklmnopqrstuvwxyz1234567890',
                    );
                    Order order = orders.value[index];
                    return TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetail(orderId: hashids.encode(order.id)),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Статус заказа: № ${order.id}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  Text(tr('order_status_${order.status}'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.green))
                                ],
                              ),
                            ],
                          ),
                        ));
                  }),
            ],
          ),
        )) : SizedBox();
  }
}
