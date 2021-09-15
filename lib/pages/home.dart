import 'package:chopar_app/widgets/ChooseAddress.dart';
import 'package:chopar_app/widgets/ChooseCity.dart';
import 'package:chopar_app/widgets/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/StoriesList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final tabs = [
    Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          ChooseCity(),
          ChooseTypeDelivery(),
          ChooseAddress(),
          StoriesList()
        ],
      ),
    ),
    Center(
      child: Text('Sale'),
    ),
    Center(
      child: Text('Profile'),
    ),
    Center(
      child: Text('Basket'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        backgroundColor: Colors.white,
        body: tabs[_selectedIndex],
        bottomNavigationBar: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: BottomNavigationBar(
                  backgroundColor: Colors.black,
                  selectedItemColor: Colors.orange,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.local_pizza),
                      label: 'Меню',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.ac_unit),
                      label: 'Акции',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Профиль',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_bag),
                      label: 'Корзина',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ))));
  }
}
