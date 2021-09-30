import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseTypeDelivery extends StatefulWidget {
  const ChooseTypeDelivery({Key? key}) : super(key: key);

  @override
  _ChooseTypeDeliveryState createState() => _ChooseTypeDeliveryState();
}

class _ChooseTypeDeliveryState extends State<ChooseTypeDelivery> {
  int _activeWidget = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Colors.grey,
      ),
      child: Wrap(
        spacing: 5.0,
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
            onPressed: () {
              setState(() {
                _activeWidget = 1;
              });
            },
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
            onPressed: () {
              setState(() {
                _activeWidget = 2;
              });
            },
          ),
          Container(
            child: Column(
              children: [ChooseDelivery()],
            ),
          )
        ],
      ),
      // color: Colors.grey,
    );
  }

  Widget ChooseDelivery() {
    switch (_activeWidget) {
      case 1:
        return
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Укажите адрес доставки'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            )
          ],
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Выберите ресторан'),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            )
          ],
        );
      default:
        return Text('asd');
    }
  }
}
