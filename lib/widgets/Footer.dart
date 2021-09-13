import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Меню',
      style: optionStyle,
    ),
    Text(
      'Index 1: Акции',
      style: optionStyle,
    ),
    Text(
      'Index 2: Профиль',
      style: optionStyle,
    ),
    Text(
      'Index 3: Корзина',
      style: optionStyle,
    ),
  ];

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
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
            )));
  }
}
