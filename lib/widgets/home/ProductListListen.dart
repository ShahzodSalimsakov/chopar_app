import 'package:chopar_app/widgets/home/ProductsList.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/delivery_type.dart';

class ProductListListen extends StatelessWidget {
  const ProductListListen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<DeliveryType>>(
        valueListenable: Hive.box<DeliveryType>('deliveryType').listenable(),
        builder: (context, box, _) {
          return ProductsList();
        });
  }
}
