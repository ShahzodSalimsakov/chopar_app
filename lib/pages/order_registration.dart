import 'package:chopar_app/widgets/order_registration/delivery_time.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/order_registration/pay_type.dart';
import 'package:flutter/material.dart';

class OrderRegistration extends StatelessWidget {
  const OrderRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          title: Text('Оформление заказа',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        ),
        body: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: [
              SizedBox(
                height: 6,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  color: Colors.white,
                  child: ChooseTypeDelivery()),
              SizedBox(
                height: 5,
              ),
              DeliveryTime(),
              SizedBox(
                height: 5,
              ),
              PayType()
            ],
          ),
        ));
  }
}
