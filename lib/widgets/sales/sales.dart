import 'package:chopar_app/widgets/news/newsList.dart';
import 'package:chopar_app/widgets/sales/banner.dart';
import 'package:chopar_app/widgets/sales/salesList.dart';
import 'package:flutter/material.dart';

class Sales extends StatefulWidget {
  const Sales({Key? key}) : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> with SingleTickerProviderStateMixin {
  final myTabs = [
    Container(
      height: 30,
      child: Tab(text: 'Акции'),
    ),
    Container(
        height: 30,
        child: Tab(
          text: 'Новости',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Акции',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            BannerWidget(),
            SizedBox(
              height: 30,
            ),
            DefaultTabController(
                length: 2,
                child: TabBar(
                  labelColor: Colors.white,
                  tabs: myTabs,
                  controller: _tabController,
                  // unselectedLabelStyle: TextStyle(backgroundColor: Colors.grey),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.yellow.shade700,
                  ),
                  unselectedLabelColor: Colors.grey,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerHeight: 0,
                  overlayColor: MaterialStatePropertyAll(Colors.white),
                )),
            SizedBox(
              height: 30,
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [SalesList(), NewsList()]))
          ],
        ),
      ),
    );
  }
}
