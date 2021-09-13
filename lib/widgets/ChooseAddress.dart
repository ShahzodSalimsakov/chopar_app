import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseAddress extends StatelessWidget {
  const ChooseAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Укажите адрес доставки'),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {},
        )
      ],
    );
  }
}
