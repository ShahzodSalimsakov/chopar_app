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
import 'package:chopar_app/pages/order_detail.dart';
import 'package:chopar_app/widgets/order_registration/additional_phone_number.dart';
import 'package:chopar_app/widgets/order_registration/comment.dart';
import 'package:chopar_app/widgets/order_registration/delivery_time.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/order_registration/pay_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hashids2/hashids2.dart';
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
          Hive.box<Terminals>('currentTerminal').get('currentTerminal');
          return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                  backgroundColor: Colors.grey.shade50,
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
                    elevation: 0.5,
                    title: Text(tr('order_registration'),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                  body: (startTime.hour < 3 || startTime.hour >= 10)
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                                color: Colors.grey.shade50,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 10,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              tr('delivery_method'),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.yellow.shade700,
                                              ),
                                            ),
                                            SizedBox(height: 12),
                                            ChooseTypeDelivery(),
                                          ],
                                        )),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    ValueListenableBuilder<Box<DeliveryType>>(
                                      valueListenable:
                                          Hive.box<DeliveryType>('deliveryType')
                                              .listenable(),
                                      builder: (context, deliveryTypeBox, _) {
                                        DeliveryType? deliveryType =
                                            deliveryTypeBox.get('deliveryType');
                                        return ValueListenableBuilder<
                                            Box<Terminals>>(
                                          valueListenable: Hive.box<Terminals>(
                                                  'currentTerminal')
                                              .listenable(),
                                          builder: (context, box, _) {
                                            Terminals? currentTerminal =
                                                box.get('currentTerminal');
                                            if (currentTerminal != null) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.05),
                                                      blurRadius: 10,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      deliveryType?.value ==
                                                              DeliveryTypeEnum
                                                                  .pickup
                                                          ? tr('pickup_branch')
                                                          : tr(
                                                              'delivery_branch'),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .yellow.shade700,
                                                      ),
                                                    ),
                                                    SizedBox(height: 12),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.grey.shade50,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .yellow
                                                                  .shade50,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Icon(
                                                              Icons.store,
                                                              color: Colors
                                                                  .yellow
                                                                  .shade700,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          SizedBox(width: 12),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  currentTerminal
                                                                          .name ??
                                                                      tr('not_selected'),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                if (currentTerminal
                                                                            .desc !=
                                                                        null &&
                                                                    currentTerminal
                                                                        .desc!
                                                                        .isNotEmpty)
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            4.0),
                                                                    child: Text(
                                                                      currentTerminal
                                                                          .desc!,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.05),
                                                      blurRadius: 10,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      deliveryType?.value ==
                                                              DeliveryTypeEnum
                                                                  .pickup
                                                          ? tr('pickup_branch')
                                                          : tr(
                                                              'delivery_branch'),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .yellow.shade700,
                                                      ),
                                                    ),
                                                    SizedBox(height: 12),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.grey.shade50,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .orange
                                                                  .shade50,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .info_outline,
                                                              color:
                                                                  Colors.orange,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          SizedBox(width: 12),
                                                          Expanded(
                                                            child: Text(
                                                              deliveryType?.value ==
                                                                      DeliveryTypeEnum
                                                                          .pickup
                                                                  ? tr(
                                                                      'please_select_pickup_branch')
                                                                  : tr(
                                                                      'delivery_branch_will_be_selected_automatically'),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    ValueListenableBuilder<Box<DeliveryType>>(
                                      valueListenable:
                                          Hive.box<DeliveryType>('deliveryType')
                                              .listenable(),
                                      builder: (context, deliveryTypeBox, _) {
                                        DeliveryType? deliveryType =
                                            deliveryTypeBox.get('deliveryType');
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 10,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                deliveryType?.value ==
                                                        DeliveryTypeEnum.pickup
                                                    ? tr('pickup_time')
                                                    : tr('delivery_time'),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.yellow.shade700,
                                                ),
                                              ),
                                              SizedBox(height: 12),
                                              DeliveryTimeWidget(),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr('payment_method'),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.yellow.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          PayTypeWidget(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr('additional_number'),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.yellow.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          AdditionalPhoneNumberWidget(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr('comment'),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.yellow.shade700,
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          OrderCommentWidget(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 100,
                                    )
                                  ],
                                ))),
                            Positioned(
                                width: MediaQuery.of(context).size.width,
                                bottom: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: Offset(0, -5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.yellow.shade700),
                                          elevation:
                                              MaterialStateProperty.all(0),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ))),
                                      onPressed: _isOrderLoading.value
                                          ? null
                                          : () async {
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
                                                      .get(
                                                          'deliveryLocationData');
                                              Terminals? currentTerminal =
                                                  Hive.box<Terminals>(
                                                          'currentTerminal')
                                                      .get('currentTerminal');
                                              DeliverLaterTime?
                                                  deliverLaterTime =
                                                  Hive.box<DeliverLaterTime>(
                                                          'deliveryLaterTime')
                                                      .get('deliveryLaterTime');
                                              DeliveryTime? deliveryTime =
                                                  Hive.box<DeliveryTime>(
                                                          'deliveryTime')
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
                                                      .get(
                                                          'additionalPhoneNumber');
                                              // Check deliveryType is chosen
                                              if (deliveryType == null) {
                                                _isOrderLoading.value = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(tr(
                                                            'delivery_method_not_selected'))));
                                                return;
                                              }

                                              //Check pickup terminal
                                              if (deliveryType.value ==
                                                  DeliveryTypeEnum.pickup) {
                                                if (currentTerminal == null) {
                                                  _isOrderLoading.value = false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(tr(
                                                              'pickup_branch_not_selected'))));
                                                  return;
                                                }
                                              }

                                              // Check delivery address
                                              if (deliveryType.value ==
                                                  DeliveryTypeEnum.deliver) {
                                                if (deliveryLocationData ==
                                                    null) {
                                                  _isOrderLoading.value = false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(tr(
                                                              'delivery_address_not_selected'))));
                                                  return;
                                                } else if (deliveryLocationData
                                                        .address ==
                                                    null) {
                                                  _isOrderLoading.value = false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(tr(
                                                              'delivery_address_not_selected'))));
                                                  return;
                                                }
                                              }

                                              // Check delivery time selected

                                              if (deliveryTime == null) {
                                                _isOrderLoading.value = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(tr(
                                                            'delivery_time_not_selected'))));
                                                return;
                                              } else if (deliveryTime.value ==
                                                  DeliveryTimeEnum.later) {
                                                if (deliverLaterTime == null) {
                                                  _isOrderLoading.value = false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(tr(
                                                              'delivery_time_not_selected'))));
                                                  return;
                                                } else if (deliverLaterTime
                                                        .value.length ==
                                                    0) {
                                                  _isOrderLoading.value = false;
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(tr(
                                                              'delivery_time_not_selected'))));
                                                  return;
                                                }
                                              }

                                              if (payType == null) {
                                                _isOrderLoading.value = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(tr(
                                                            'payment_method_not_selected'))));
                                                return;
                                              }

                                              Basket? basket =
                                                  Hive.box<Basket>('basket')
                                                      .get('basket');
                                              Box userBox =
                                                  Hive.box<User>('user');
                                              User? user = userBox.get('user');

                                              Map<String, String>
                                                  requestHeaders = {
                                                'Content-type':
                                                    'application/json',
                                                'Accept': 'application/json'
                                              };

                                              if (user != null) {
                                                requestHeaders[
                                                        'Authorization'] =
                                                    'Bearer ${user.userToken}';
                                              }

                                              var url = Uri.https(
                                                  'api.choparpizza.uz',
                                                  '/api/orders');
                                              Map<String, dynamic> formData = {
                                                'basket_id': basket!.encodedId,
                                                'formData': <String, dynamic>{
                                                  'address': '',
                                                  'flat': '',
                                                  'house': '',
                                                  'entrance': '',
                                                  'door_code': '',
                                                  'deliveryType': '',
                                                  'sourceType': "app",
                                                  'label': ''
                                                }
                                              };
                                              if (deliveryType.value ==
                                                  DeliveryTypeEnum.deliver) {
                                                formData['formData']
                                                        ['address'] =
                                                    deliveryLocationData!
                                                        .address;
                                                formData['formData']['flat'] =
                                                    deliveryLocationData.flat ??
                                                        '';
                                                formData['formData']['house'] =
                                                    deliveryLocationData
                                                            .house ??
                                                        '';
                                                formData['formData']
                                                        ['entrance'] =
                                                    deliveryLocationData
                                                            .entrance ??
                                                        '';
                                                formData['formData']
                                                        ['door_code'] =
                                                    deliveryLocationData
                                                            .doorCode ??
                                                        '';
                                                formData['formData']
                                                        ['deliveryType'] =
                                                    'deliver';
                                                formData['formData']
                                                    ['location'] = [
                                                  deliveryLocationData.lat,
                                                  deliveryLocationData.lon
                                                ];
                                                formData['formData']['label'] =
                                                    deliveryLocationData
                                                            .label ??
                                                        '';
                                              } else {
                                                formData['formData']
                                                    ['deliveryType'] = 'pickup';
                                              }

                                              formData['formData']
                                                      ['terminal_id'] =
                                                  currentTerminal!.id
                                                      .toString();
                                              formData['formData']['name'] =
                                                  user!.name;
                                              formData['formData']['phone'] =
                                                  user.phone;
                                              formData['formData']['email'] =
                                                  '';
                                              formData['formData']['change'] =
                                                  '';
                                              formData['formData']['notes'] =
                                                  '';
                                              formData['formData']
                                                  ['delivery_day'] = '';
                                              formData['formData']
                                                  ['delivery_time'] = '';
                                              formData['formData']
                                                  ['delivery_schedule'] = 'now';
                                              formData['formData']['sms_sub'] =
                                                  false;
                                              formData['formData']
                                                  ['email_sub'] = false;
                                              formData['formData']
                                                      ['additionalPhone'] =
                                                  additionalPhoneNumber
                                                          ?.additionalPhoneNumber ??
                                                      '';
                                              if (deliveryTime.value ==
                                                  DeliveryTimeEnum.later) {
                                                formData['formData']
                                                        ['delivery_schedule'] =
                                                    'later';
                                                formData['formData']
                                                        ['delivery_time'] =
                                                    deliverLaterTime?.value;
                                              }

                                              if (payCash != null) {
                                                formData['formData']['change'] =
                                                    payCash.value;
                                              }

                                              if (deliverLaterTime != null) {
                                                formData['formData']['notes'] =
                                                    deliveryNotes
                                                            ?.deliveryNotes ??
                                                        '';
                                              }

                                              formData['formData']['pay_type'] =
                                                  payType.value;

                                              var response = await http.post(
                                                  url,
                                                  headers: requestHeaders,
                                                  body: jsonEncode(formData));
                                              if (response.statusCode == 200 ||
                                                  response.statusCode == 201) {
                                                var json =
                                                    jsonDecode(response.body);

                                                Map<String, String>
                                                    requestHeaders = {
                                                  'Content-type':
                                                      'application/json',
                                                  'Accept': 'application/json'
                                                };

                                                requestHeaders[
                                                        'Authorization'] =
                                                    'Bearer ${user.userToken}';

                                                url = Uri.https(
                                                    'api.choparpizza.uz',
                                                    '/api/orders', {
                                                  'id': json['order']['id']
                                                });

                                                response = await http.get(url,
                                                    headers: requestHeaders);
                                                if (response.statusCode ==
                                                        200 ||
                                                    response.statusCode ==
                                                        201) {
                                                  json =
                                                      jsonDecode(response.body);
                                                  Order order =
                                                      Order.fromJson(json);
                                                  await Hive.box<Basket>(
                                                          'basket')
                                                      .delete('basket');
                                                  await Hive.box<DeliveryType>(
                                                          'deliveryType')
                                                      .delete('deliveryType');
                                                  await Hive.box<
                                                              DeliveryLocationData>(
                                                          'deliveryLocationData')
                                                      .delete(
                                                          'deliveryLocationData');
                                                  await Hive.box<Terminals>(
                                                          'currentTerminal')
                                                      .delete(
                                                          'currentTerminal');
                                                  await Hive.box<
                                                              DeliverLaterTime>(
                                                          'deliveryLaterTime')
                                                      .delete(
                                                          'deliveryLaterTime');
                                                  await Hive.box<DeliveryTime>(
                                                          'deliveryTime')
                                                      .delete('deliveryTime');
                                                  await Hive.box<PayType>(
                                                          'payType')
                                                      .delete('payType');
                                                  await Hive.box<PayCash>(
                                                          'payCash')
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
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .yellow
                                                                    .shade700,
                                                              ),
                                                            ),
                                                            content: Text(
                                                              tr("order_is_accepted_content"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ));
                                                  _isOrderLoading.value = false;
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 2000),
                                                      () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderDetailPage(
                                                                orderId: hashids
                                                                    .encode(order
                                                                        .id)),
                                                      ),
                                                    );
                                                  });
                                                }
                                              } else {
                                                var errResponse =
                                                    jsonDecode(response.body);
                                                _isOrderLoading.value = false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            errResponse['error']
                                                                ['message'])));
                                                return;
                                              }
                                            },
                                      child: _isOrderLoading.value
                                          ? SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.0,
                                              ),
                                            )
                                          : Text(
                                              tr('order_registration'),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            ),
                                    ),
                                  ),
                                ))
                          ],
                        )
                      : Center(
                          child: Container(
                              padding: EdgeInsets.all(24),
                              margin: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 48,
                                    color: Colors.yellow.shade700,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    tr('sorry_we_cant_accept_your_order'),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    tr('working_hours'),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade700),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )),
                        )));
        });
  }
}
