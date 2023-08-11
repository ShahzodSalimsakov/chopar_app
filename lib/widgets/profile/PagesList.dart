import 'package:chopar_app/pages/about_us.dart';
import 'package:chopar_app/pages/bonuses.dart';
import 'package:chopar_app/pages/order_registration.dart';
import 'package:chopar_app/pages/orders.dart';
import 'package:chopar_app/pages/personal_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PagesList extends StatelessWidget {
  const PagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        // wrap in Expanded
        child: ListView(
      shrinkWrap: true,
      children: [
        // ListTile(
        //   contentPadding: EdgeInsets.all(0.00),
        //   leading: Icon(Icons.map),
        //   title: Text('Бонусы'),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => Bonuses(),
        //       ),
        //     );
        //   },
        // ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          // leading: FaIcon(FontAwesomeIcons.shoppingBasket),
          leading: Icon(Icons.shopping_basket_outlined),
          title: Text('Мои заказы'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersPage(),
              ),
            );
          },
        ),
        // ListTile(
        //   contentPadding: EdgeInsets.all(0.00),
        //   leading: Icon(Icons.map),
        //   title: Text('Мои адреса'),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        // ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.person_outline),
          title: Text('Личные данные'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalDataPage(),
              ),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.info_outline),
          title: Text('О нас'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutUs(),
              ),
            );
          },
        ),
        // ListTile(
        //   contentPadding: EdgeInsets.all(0.00),
        //   leading: Icon(Icons.info_outline),
        //   title: Text('Оформление заказа'),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => OrderRegistration(),
        //       ),
        //     );
        //   },
        // ),
      ],
    ));
  }
}
