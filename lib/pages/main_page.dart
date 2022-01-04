import 'package:chopar_app/models/home_is_scrolled.dart';
import 'package:chopar_app/models/home_scroll_position.dart';
import 'package:chopar_app/widgets/home/ChooseCity.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/home/ProductsList.dart';
import 'package:chopar_app/widgets/order_status/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';

late final TabController _tabController;
late final ScrollController _scrollController;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder<Box<HomeIsScrolled>>(
          valueListenable:
              Hive.box<HomeIsScrolled>('homeIsScrolled').listenable(),
          builder: (context, box, _) {
            HomeIsScrolled? homeIsScrolled =
            Hive.box<HomeIsScrolled>('homeIsScrolled')
                .get('homeIsScrolled');
            double height = 150;
            if (homeIsScrolled != null) {
              if (homeIsScrolled.value == true) {
                height = 0;
              } else {
                height = 150;
              }
            }

            return Container(
              margin: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(microseconds: 300),height: height, child: Column(
                    children: [
                      OrderStatus(),
                      ChooseCity(),
                      ChooseTypeDelivery(),
                      SizedBox(height: 10.0),
                    ],
                  ),),
                  ProductsList()
                ],
              ),
            );
            return NestedScrollView(
              // controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    toolbarHeight: 150,
                    // title: ,
                    // pinned: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    // bottom: TabBar(
                    //   tabs: <Tab>[
                    //     Tab(text: 'STATISTICS'),
                    //   ],
                    //   controller: _tabController,
                    // ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 5, left: 15.0, right: 15.0, bottom: 15.0),
                    child: Column(
                      children: <Widget>[ProductsList()],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
