import 'package:chopar_app/widgets/ChooseAddress.dart';
import 'package:chopar_app/widgets/ChooseCity.dart';
import 'package:chopar_app/widgets/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/Footer.dart';
import 'package:chopar_app/widgets/StoriesList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
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
        bottomNavigationBar: Footer()
    );
  }
}
