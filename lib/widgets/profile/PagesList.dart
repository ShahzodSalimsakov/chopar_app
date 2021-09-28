import 'package:chopar_app/pages/bonuses.dart';
import 'package:flutter/material.dart';

class PagesList extends StatelessWidget {
  const PagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded( // wrap in Expanded
        child: ListView(
          shrinkWrap: true,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.map),
          title: Text('Бонусы'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Bonuses(),
              ),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.map),
          title: Text('Мои заказы'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.map),
          title: Text('Мои адреса'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.map),
          title: Text('Личные данные'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.map),
          title: Text('О нас'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ],
    ));
  }
}
