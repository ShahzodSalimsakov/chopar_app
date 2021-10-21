import 'package:flutter/material.dart';

class PayType extends StatefulWidget {
  const PayType({Key? key}) : super(key: key);

  @override
  State<PayType> createState() => _PayTypeState();
}

class _PayTypeState extends State<PayType> with SingleTickerProviderStateMixin {
  final myTabs = [

    Container(
      height: 30,
      child: Tab(text: 'Наличными'),
    ),Container(
      height: 30,
      child: Tab(text: 'Онлайн'),
    ),
    Container(
        height: 30,
        child: Tab(
          text: 'Картой',
        ))

  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите способ оплаты',
              style: TextStyle(fontSize: 18),
            ),
            DefaultTabController(
                length: 2,
                child: TabBar(
                  labelColor: Colors.white,
                  labelStyle: TextStyle(fontWeight: FontWeight.w700),
                  tabs: myTabs,
                  controller: _tabController,
                  // unselectedLabelStyle: TextStyle(backgroundColor: Colors.grey),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.yellow.shade700,
                  ),
                  unselectedLabelColor: Colors.grey,
                )),
          ],
        ));
  }
}
