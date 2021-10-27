import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/widgets/order_registration/comment.dart';
import 'package:chopar_app/widgets/order_registration/delivery_time.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/order_registration/pay_type.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderRegistration extends StatelessWidget {
  const OrderRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var startTime = DateTime.now();
    print(startTime.hour);
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
                  body: (startTime.hour < 3 || startTime.hour > 10)
                      ? Stack(
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
                                    OrderCommentWidget(),
                                    SizedBox(height: 50,)
                                  ],
                                ))),
                            Positioned(
                                bottom: 0,
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: DefaultStyledButton(
                                    width: MediaQuery.of(context).size.width - 30,
                                    text: 'Оформить заказ',
                                    onPressed: () {
                                      Box<DeliveryType> box = Hive.box<DeliveryType>(
                                          'deliveryType');
                                      DeliveryType? deliveryType = box.get('deliveryType');
                                      if (deliveryType == null) {
                                        // ScaffoldMessenger
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
