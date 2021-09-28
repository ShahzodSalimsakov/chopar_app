import 'package:flutter/material.dart';

class ProductsList extends StatelessWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
      height: 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: 60,
          itemBuilder: (context, index) {
            return  Text('asdasd');
          }),
    );
  }
}
