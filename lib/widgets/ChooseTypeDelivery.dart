import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseTypeDelivery extends StatelessWidget {
  const ChooseTypeDelivery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(50))),
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.white,
                minimumSize: Size(182, 30)),
            child: Text(
              'Доставка',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.grey,
                minimumSize: Size(182, 30)),
            child: Text('Самовывоз',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
