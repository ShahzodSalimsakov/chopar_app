import 'dart:convert';
import 'package:chopar_app/models/additional_phone_number.dart';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/deliver_later_time.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/delivery_notes.dart';
import 'package:chopar_app/models/delivery_time.dart';
import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/order.dart';
import 'package:chopar_app/models/pay_cash.dart';
import 'package:chopar_app/models/pay_type.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/pages/home.dart';
import 'package:chopar_app/pages/order_detail.dart';
import 'package:chopar_app/widgets/order_registration/additional_phone_number.dart';
import 'package:chopar_app/widgets/order_registration/comment.dart';
import 'package:chopar_app/widgets/order_registration/delivery_time.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/order_registration/pay_type.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class OrderRegistration extends HookWidget {
  const OrderRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var startTime = DateTime.now();
    final _isOrderLoading = useState<bool>(false);
    return ValueListenableBuilder<Box<Terminals>>(
        valueListenable: Hive.box<Terminals>('currentTerminal').listenable(),
        builder: (context, box, _) {
          Terminals? currentTerminal =
              Hive.box<Terminals>('currentTerminal').get('currentTerminal');
          return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
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
                    title: Text('Оформление заказа',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400)),
                  ),
                  body: (startTime.hour < 3 || startTime.hour >= 10)
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                                color: Colors.grey.shade200,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        color: Colors.white,
                                        child: ChooseTypeDelivery()),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    DeliveryTimeWidget(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    PayTypeWidget(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    AdditionalPhoneNumberWidget(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    OrderCommentWidget(),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                ))),
                            Positioned(
                                width: MediaQuery.of(context).size.width,
                                bottom: 0,
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: DefaultStyledButton(
                                    color: [
                                      Colors.yellow.shade700,
                                      Colors.yellow.shade700
                                    ],
                                    isLoading: _isOrderLoading.value == true
                                        ? _isOrderLoading.value
                                        : null,
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    text: 'Оформить заказ',
                                    onPressed: () async {
                                      _isOrderLoading.value = true;
                                      final hashids = HashIds(
                                        salt: 'order',
                                        minHashLength: 15,
                                        alphabet:
                                            'abcdefghijklmnopqrstuvwxyz1234567890',
                                      );

                                      Box<DeliveryType> box =
                                          Hive.box<DeliveryType>(
                                              'deliveryType');
                                      DeliveryType? deliveryType =
                                          box.get('deliveryType');
                                      DeliveryLocationData?
                                          deliveryLocationData =
                                          Hive.box<DeliveryLocationData>(
                                                  'deliveryLocationData')
                                              .get('deliveryLocationData');
                                      Terminals? currentTerminal =
                                          Hive.box<Terminals>('currentTerminal')
                                              .get('currentTerminal');
                                      DeliverLaterTime? deliverLaterTime =
                                          Hive.box<DeliverLaterTime>(
                                                  'deliveryLaterTime')
                                              .get('deliveryLaterTime');
                                      DeliveryTime? deliveryTime =
                                          Hive.box<DeliveryTime>('deliveryTime')
                                              .get('deliveryTime');
                                      PayType? payType =
                                          Hive.box<PayType>('payType')
                                              .get('payType');
                                      PayCash? payCash =
                                          Hive.box<PayCash>('payCash')
                                              .get('payCash');
                                      DeliveryNotes? deliveryNotes =
                                          Hive.box<DeliveryNotes>(
                                                  'deliveryNotes')
                                              .get('deliveryNotes');
                                      AdditionalPhoneNumber?
                                          additionalPhoneNumber =
                                          Hive.box<AdditionalPhoneNumber>(
                                                  'additionalPhoneNumber')
                                              .get('additionalPhoneNumber');
                                      // Check deliveryType is chosen
                                      if (deliveryType == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Не выбран способ доставки')));
                                        return;
                                      }

                                      //Check pickup terminal
                                      if (deliveryType != null &&
                                          deliveryType.value ==
                                              DeliveryTypeEnum.pickup) {
                                        if (currentTerminal == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Не выбран филиал самовывоза')));
                                          return;
                                        }
                                      }

                                      // Check delivery address
                                      if (deliveryType != null &&
                                          deliveryType.value ==
                                              DeliveryTypeEnum.deliver) {
                                        if (deliveryLocationData == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Не указан адрес доставки')));
                                          return;
                                        } else if (deliveryLocationData
                                                .address ==
                                            null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Не указан адрес доставки')));
                                          return;
                                        }
                                      }

                                      // Check delivery time selected

                                      if (deliveryTime == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Не указано время доставки')));
                                        return;
                                      } else if (deliveryTime.value ==
                                          DeliveryTimeEnum.later) {
                                        if (deliverLaterTime == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Не указано время доставки')));
                                          return;
                                        } else if (deliverLaterTime.value ==
                                                null ||
                                            deliverLaterTime.value.length ==
                                                0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Не указано время доставки')));
                                          return;
                                        }
                                      }

                                      if (payType == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Не указан способ оплаты')));
                                        return;
                                      }

                                      Basket? basket =
                                          Hive.box<Basket>('basket')
                                              .get('basket');
                                      Box userBox = Hive.box<User>('user');
                                      User? user = userBox.get('user');

                                      Map<String, String> requestHeaders = {
                                        'Content-type': 'application/json',
                                        'Accept': 'application/json'
                                      };

                                      if (user != null) {
                                        requestHeaders['Authorization'] =
                                            'Bearer ${user.userToken}';
                                      }

                                      var url = Uri.https(
                                          'api.choparpizza.uz', '/api/orders');
                                      Map<String, dynamic> formData = {
                                        'basket_id': basket!.encodedId,
                                        'formData': <String, dynamic>{
                                          'address': '',
                                          'flat': '',
                                          'house': '',
                                          'entrance': '',
                                          'door_code': '',
                                          'deliveryType': '',
                                          'sourceType': "app"
                                        }
                                      };
                                      if (deliveryType!.value ==
                                          DeliveryTypeEnum.deliver) {
                                        formData['formData']['address'] =
                                            deliveryLocationData!.address;
                                        formData['formData']['flat'] =
                                            deliveryLocationData.flat ?? '';
                                        formData['formData']['house'] =
                                            deliveryLocationData.house ?? '';
                                        formData['formData']['entrance'] =
                                            deliveryLocationData.entrance ?? '';
                                        formData['formData']['door_code'] =
                                            deliveryLocationData.doorCode ?? '';
                                        formData['formData']['deliveryType'] =
                                            'deliver';
                                        formData['formData']['location'] = [
                                          deliveryLocationData.lat,
                                          deliveryLocationData.lon
                                        ];
                                      } else {
                                        formData['formData']['deliveryType'] =
                                            'pickup';
                                      }

                                      formData['formData']['terminal_id'] =
                                          currentTerminal!.id.toString();
                                      formData['formData']['name'] = user!.name;
                                      formData['formData']['phone'] =
                                          user!.phone;
                                      formData['formData']['email'] = '';
                                      formData['formData']['change'] = '';
                                      formData['formData']['notes'] = '';
                                      formData['formData']['delivery_day'] = '';
                                      formData['formData']['delivery_time'] =
                                          '';
                                      formData['formData']
                                          ['delivery_schedule'] = 'now';
                                      formData['formData']['sms_sub'] = false;
                                      formData['formData']['email_sub'] = false;
                                      formData['formData']['additionalPhone'] =
                                          additionalPhoneNumber
                                                  ?.additionalPhoneNumber ??
                                              '';
                                      if (deliveryTime.value ==
                                          DeliveryTimeEnum.later) {
                                        formData['formData']
                                            ['delivery_schedule'] = 'later';
                                        formData['formData']['delivery_time'] =
                                            deliveryTime.value;
                                      }

                                      if (payCash != null) {
                                        formData['formData']['change'] =
                                            payCash.value;
                                      }

                                      if (deliverLaterTime != null) {
                                        formData['formData']['notes'] =
                                            deliveryNotes!.deliveryNotes;
                                      }

                                      if (payType != null) {
                                        formData['formData']['pay_type'] =
                                            payType.value;
                                      } else {
                                        formData['formData']['pay_type'] =
                                            'offline';
                                      }

                                      var response = await http.post(url,
                                          headers: requestHeaders,
                                          body: jsonEncode(formData));
                                      if (response.statusCode == 200 ||
                                          response.statusCode == 201) {
                                        var json = jsonDecode(response.body);

                                        Map<String, String> requestHeaders = {
                                          'Content-type': 'application/json',
                                          'Accept': 'application/json'
                                        };

                                        if (user != null) {
                                          requestHeaders['Authorization'] =
                                              'Bearer ${user.userToken}';
                                        }

                                        url = Uri.https(
                                            'api.choparpizza.uz',
                                            '/api/orders',
                                            {'id': json['order']['id']});

                                        response = await http.get(url,
                                            headers: requestHeaders);
                                        if (response.statusCode == 200 ||
                                            response.statusCode == 201) {
                                          json = jsonDecode(response.body);
                                          Order order = Order.fromJson(json);
                                          await Hive.box<Basket>('basket')
                                              .delete('basket');
                                          await Hive.box<DeliveryType>(
                                                  'deliveryType')
                                              .delete('deliveryType');
                                          await Hive.box<DeliveryLocationData>(
                                                  'deliveryLocationData')
                                              .delete('deliveryLocationData');
                                          await Hive.box<Terminals>(
                                                  'currentTerminal')
                                              .delete('currentTerminal');
                                          await Hive.box<DeliverLaterTime>(
                                                  'deliveryLaterTime')
                                              .delete('deliveryLaterTime');
                                          await Hive.box<DeliveryTime>(
                                                  'deliveryTime')
                                              .delete('deliveryTime');
                                          await Hive.box<PayType>('payType')
                                              .delete('payType');
                                          await Hive.box<PayCash>('payCash')
                                              .delete('payCash');
                                          await Hive.box<DeliveryNotes>(
                                                  'deliveryNotes')
                                              .delete('deliveryNotes');

                                          // Navigator.of(context)..pop();

                                          showPlatformDialog(
                                              context: context,
                                              builder: (_) =>
                                                  PlatformAlertDialog(
                                                    title: Text(
                                                      tr("order_is_accepted"),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    content: Text(
                                                      tr("order_is_accepted_content"),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ));
                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 2000), () {
                                            _isOrderLoading.value = false;
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderDetail(
                                                        orderId: hashids
                                                            .encode(order.id)),
                                              ),
                                            );
                                          });
                                        }
                                        // BasketData basketData = new BasketData.fromJson(json['data']);
                                        // Basket newBasket = new Basket(
                                        //     encodedId: basketData.encodedId ?? '',
                                        //     lineCount: basketData.lines?.length ?? 0);
                                        // basketBox.put('basket', newBasket);
                                      }
                                    },
                                  ),
                                ))
                          ],
                        )
                      : Center(
                          child: Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Извините, в данный момент мы не можем принять Ваш заказ. Режим работы: 10:00 - 03:00',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        )));
        });
  }
}
