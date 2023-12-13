import 'package:auto_route/auto_route.dart';
import 'package:chopar_app/widgets/home/ChooseCity.dart';
import 'package:chopar_app/widgets/home/ChooseTypeDelivery.dart';
import 'package:chopar_app/widgets/order_status/index.dart';
import 'package:flutter/material.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:upgrader/upgrader.dart';
import '../models/product_section.dart';
import '../widgets/home/ProductListListen.dart';

// late final ScrollController _scrollController;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  ScrollController _parentScrollController = ScrollController();
  List<ProductSection> products = List<ProductSection>.empty();
  bool isProductsLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            child: SingleChildScrollView(
              controller: _parentScrollController,
              scrollDirection: Axis.vertical,
              child: Container(
                height: (MediaQuery.of(context).size.height + 18) * 1,
                margin: EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    OrderStatus(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 150, height: 50, child: ChooseCity()),
                        GestureDetector(
                            onTap: () {
                              context.router.pushNamed("/notifications");
                            },
                            child: Icon(Icons.notifications_none_rounded,
                                size: 30)),
                      ],
                    ),
                    ChooseTypeDelivery(),
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
