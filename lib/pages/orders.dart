import 'dart:convert';
import 'package:chopar_app/models/order.dart';
import 'package:chopar_app/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';

class OrdersPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final orders = useState<List<Order>>(List<Order>.empty());
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
          title: Text(tr('my_orders'),
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
                        locale: 'ru_RU', symbol: tr('sum'), decimalDigits: 0);
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '№ ${order.id}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: order.status == 'cancelled'
                                      ? Colors.red.shade50
                                      : order.status == 'delivered'
                                          ? Colors.green.shade50
                                          : Colors.yellow.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tr('order_status_${order.status}'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: order.status == 'cancelled'
                                        ? Colors.red
                                        : order.status == 'delivered'
                                            ? Colors.green
                                            : Colors.yellow.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 4),
                              Text(
                                createdAtFormat.format(createdAt),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Divider(color: Colors.grey.shade200, thickness: 1),
                          SizedBox(height: 12),
                          order.deliveryType == 'deliver'
                              ? Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        address,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : order.terminalData != null
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.store,
                                          color: Colors.grey.shade700,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            '${tr('branch')}: ${order.terminalData?.name ?? ''}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                          SizedBox(height: 12),
                          Divider(color: Colors.grey.shade200, thickness: 1),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                formatCurrency.format(order.orderTotal / 100),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () {
                                print(
                                    "Navigating to order details with ID: ${hashids.encode(order.id)}");
                                Navigator.of(context).pushNamed('/order-detail',
                                    arguments: {
                                      'orderId': hashids.encode(order.id)
                                    });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.grey.shade200),
                                elevation: MaterialStateProperty.all(0),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                tr('order_details'),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
        )));
  }
}
