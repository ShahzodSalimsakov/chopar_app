import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/delivery_type.dart';
import 'ProductScrollableTabList.dart';

class ProductListListen extends StatelessWidget {
  final ScrollController parentScrollController;
  const ProductListListen({Key? key, required this.parentScrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<DeliveryType>>(
        valueListenable: Hive.box<DeliveryType>('deliveryType').listenable(),
        builder: (context, box, _) {
          return ProductScrollableTabList(
              parentScrollController: parentScrollController);
        });
  }
}
