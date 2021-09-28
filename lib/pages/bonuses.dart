import 'package:flutter/material.dart';

class Bonuses extends StatelessWidget {
  const Bonuses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("XXXXXXXXXX", textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        child: Text('tetts'),
      )),
    );
  }
}
