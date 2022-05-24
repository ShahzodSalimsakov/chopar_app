import 'package:chopar_app/models/home_is_scrolled.dart';
import 'package:chopar_app/models/home_scroll_position.dart';
import 'package:chopar_app/widgets/home/ChooseCity.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/home/ProductsList.dart';
import 'package:chopar_app/widgets/order_status/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:upgrader/upgrader.dart';

import '../models/product_section.dart';
import '../widgets/home/ProductListListen.dart';
import '../widgets/home/productTabListStateful.dart';

// late final ScrollController _scrollController;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  var _tabController;
  ScrollController _parentScrollController = ScrollController();
  List<ProductSection> products = List<ProductSection>.empty();
  bool isProductsLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    // _scrollController = ScrollController();
  }

  late double pinnedHeaderHeight;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    pinnedHeaderHeight =
    //statusBar height
    statusBarHeight +
        //pinned SliverAppBar height in header
        kToolbarHeight;

    // return Scaffold(body: isProductsLoading ? Container() : ProductTabListStateful(products: products));

      return ScrollsToTop(
      onScrollsToTop: (ScrollsToTopEvent event) async {
        // print('parent');
        // _parentScrollController.animateTo(0,
        //     duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: UpgradeAlert(
            shouldPopScope: () => true,
            debugLogging: false,
            showIgnore: false,
            showLater: false,
            child:
            SingleChildScrollView(
              controller: _parentScrollController,
              scrollDirection: Axis.vertical,
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                margin: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    OrderStatus(),
                    ChooseCity(),
                    ChooseTypeDelivery(),
                    SizedBox(height: 25.0),
                    ProductListListen(
                        parentScrollController: _parentScrollController),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
