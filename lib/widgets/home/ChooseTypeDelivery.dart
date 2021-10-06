import 'package:chopar_app/models/modal_fit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChooseTypeDelivery extends StatefulWidget {
  const ChooseTypeDelivery({Key? key}) : super(key: key);

  @override
  _ChooseTypeDeliveryState createState() => _ChooseTypeDeliveryState();
}

class _ChooseTypeDeliveryState extends State<ChooseTypeDelivery>
    with SingleTickerProviderStateMixin {
  final myTabs = <Tab>[
    Tab(text: 'Доставка'),
    Tab(text: 'Самовывоз'),
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
    return Column(
      children: [
        Container(
            height: 33.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0), color: Colors.grey),
            padding: EdgeInsets.all(1.0),
            child: DefaultTabController(
                length: 2,
                child: TabBar(
                  tabs: myTabs,
                  controller: _tabController,
                  // unselectedLabelStyle: TextStyle(backgroundColor: Colors.grey),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white),
                  unselectedLabelColor: Colors.white,
                ))),
        Container(
            height: 50,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            'Укажите адрес доставки',
                          ),
                          width: 320,
                        ),
                        Icon(Icons.edit)
                      ],
                    ),
                    onPressed: () {},
                    style: TextButton.styleFrom(primary: Colors.grey)),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 300, child: Text('Выберите ресторан')),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        )
                      ],
                    ),
                    style: TextButton.styleFrom(primary: Colors.grey))
              ],
            )),
      ],
    );
  }
}
