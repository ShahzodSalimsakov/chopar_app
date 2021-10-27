import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:chopar_app/widgets/auth/modal.dart';
import 'package:chopar_app/widgets/basket/basket.dart';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/widgets/home/ChooseCity.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/home/ProductsList.dart';
import 'package:chopar_app/widgets/home/StoriesList.dart';
import 'package:chopar_app/widgets/profile/PagesList.dart';
import 'package:chopar_app/widgets/profile/UserName.dart';
import 'package:chopar_app/widgets/profile/index.dart';
import 'package:chopar_app/widgets/sales/sales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          ChooseCity(),
          ChooseTypeDelivery(),
          // ChooseAddress(),
          // StoriesList(),
          SizedBox(height: 20.0),
          ProductsList()
        ],
      ),
    ),
    Sales(),
    ProfileIndex(),
    // Container(
    //   margin: EdgeInsets.all(20.0),
    //   child: Column(
    //     children: <Widget>[/*ChooseCity(), UserName(), PagesList()*/ LoginView()],
    //   ),
    // ),
    BasketWidget()
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: tabs[_selectedIndex]),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey, blurRadius: 5, offset: Offset(0, 0))
              ],
            ),
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: ValueListenableBuilder<Box<Basket>>(
                    valueListenable: Hive.box<Basket>('basket').listenable(),
                    builder: (context, box, _) {
                      Basket? basket = box.get('basket');
                      return BottomNavigationBar(
                        backgroundColor: Colors.white,
                        selectedItemColor: Colors.yellow.shade700,
                        unselectedItemColor: Colors.grey,
                        type: BottomNavigationBarType.fixed,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 10),
                              child: SvgPicture.asset('assets/images/menu.svg',
                                  color: _selectedIndex != 0
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                            ),
                            label: 'Меню',
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 10),
                              child: SvgPicture.asset(
                                  'assets/images/discount.svg',
                                  color: _selectedIndex != 1
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                            ),
                            label: 'Акции',
                          ),
                          BottomNavigationBarItem(
                            icon: Padding(
                              padding: EdgeInsets.only(bottom: 6, top: 10),
                              child: SvgPicture.asset(
                                  'assets/images/profile.svg',
                                  color: _selectedIndex != 2
                                      ? Colors.grey
                                      : Colors.yellow.shade700),
                            ),
                            label: 'Профиль',
                          ),
                          BottomNavigationBarItem(
                            icon: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 6, top: 10),
                                  child: SvgPicture.asset(
                                      'assets/images/bag.svg',
                                      color: _selectedIndex != 3
                                          ? Colors.grey
                                          : Colors.yellow.shade700),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: basket != null && basket.lineCount > 0
                                        ? Container(
                                            // color: Colors.yellow.shade600,
                                            width: 15,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.yellow.shade600),
                                            child: Center(
                                              child: Text(
                                                basket.lineCount.toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          )
                                        : SizedBox())
                              ],
                            ),
                            // activeIcon: Stack(children: [],),
                            label: 'Корзина',
                          ),
                        ],
                        currentIndex: _selectedIndex,
                        onTap: (int index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      );
                    }))));
  }
}
