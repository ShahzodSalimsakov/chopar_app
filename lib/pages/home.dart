import 'package:chopar_app/cubit/user/cubit.dart';
import 'package:chopar_app/cubit/user/state.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:chopar_app/widgets/auth/modal.dart';
import 'package:chopar_app/widgets/home/ChooseAddress.dart';
import 'package:chopar_app/widgets/home/ChooseCity.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/home/ProductsList.dart';
import 'package:chopar_app/widgets/home/StoriesList.dart';
import 'package:chopar_app/widgets/profile/PagesList.dart';
import 'package:chopar_app/widgets/profile/UserName.dart';
import 'package:chopar_app/widgets/profile/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final userRepository = UserRepository();
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
          ProductsList()
        ],
      ),
    ),
    Center(
      child: Text('Sale'),
    ),
    ProfileIndex(),
    // Container(
    //   margin: EdgeInsets.all(20.0),
    //   child: Column(
    //     children: <Widget>[/*ChooseCity(), UserName(), PagesList()*/ LoginView()],
    //   ),
    // ),
    Center(
      child: Text('Basket'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocProvider<UserCubit>(
      create: (context) => UserCubit(userRepository),
      child: BlocBuilder<UserCubit, UserAuthState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(child: tabs[_selectedIndex]),
              bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 0))
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: BottomNavigationBar(
                        backgroundColor: Colors.white,
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
                        onTap: (int index) {
                          var _userBloc = BlocProvider.of<UserCubit>(context);
                          print(_userBloc.state);
                          if (index >= 2 && _userBloc.state is UserUnauthorizedState) {
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthModal(),
                                fullscreenDialog: true,
                              ),
                            );
                          } else {
                            setState(() {
                              _selectedIndex = index;
                            });
                          }
                        },
                      ))));
        },
      ),
    );
  }
}
