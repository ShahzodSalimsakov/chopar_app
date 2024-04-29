import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/widgets/delivery/delivery.dart';
import 'package:chopar_app/widgets/delivery/pickup.dart';
import 'package:chopar_app/widgets/home/DiscountWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChooseTypeDelivery extends StatefulWidget {
  const ChooseTypeDelivery({Key? key}) : super(key: key);

  @override
  _ChooseTypeDeliveryState createState() => _ChooseTypeDeliveryState();
}

class _ChooseTypeDeliveryState extends State<ChooseTypeDelivery>
    with SingleTickerProviderStateMixin {
  final myTabs = <Tab>[
    Tab(text: 'Доставка'),
    Tab(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Самовывоз '), DiscountWidget()],
    )),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
    DeliveryType? currentDeliver = box.get('deliveryType');
    if (currentDeliver != null) {
      var currentTabIndex = 0;
      if (currentDeliver.value == DeliveryTypeEnum.pickup) {
        currentTabIndex = 1;
      }
      _tabController = TabController(
          vsync: this, length: myTabs.length, initialIndex: currentTabIndex);
    } else {
      _tabController = TabController(vsync: this, length: myTabs.length);
    }
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
            padding: EdgeInsets.all(2),
            child: DefaultTabController(
                length: 2,
                child: TabBar(
                  tabs: myTabs,
                  controller: _tabController,
                  onTap: (index) {
                    DeliveryType deliveryType = DeliveryType();
                    if (index == 0) {
                      deliveryType.value = DeliveryTypeEnum.deliver;
                    } else {
                      deliveryType.value = DeliveryTypeEnum.pickup;
                    }
                    Box<DeliveryType> box =
                        Hive.box<DeliveryType>('deliveryType');
                    box.put('deliveryType', deliveryType);
                  },
                  // unselectedLabelStyle: TextStyle(backgroundColor: Colors.grey),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white),
                  unselectedLabelColor: Colors.white,
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                ))),
        Container(
            height: 55,
            width: double.infinity,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                ValueListenableBuilder<Box<DeliveryLocationData>>(
                    valueListenable:
                        Hive.box<DeliveryLocationData>('deliveryLocationData')
                            .listenable(),
                    builder: (context, box, _) {
                      DeliveryLocationData? deliveryLocationData =
                          box.get('deliveryLocationData');
                      String deliveryText = 'Укажите адрес доставки';
                      if (deliveryLocationData != null) {
                        deliveryText = deliveryLocationData.address ?? '';
                        String house = deliveryLocationData.house != null
                            ? ', дом: ${deliveryLocationData.house}'
                            : '';
                        String flat = deliveryLocationData.flat != null
                            ? ', кв.: ${deliveryLocationData.flat}'
                            : '';
                        String entrance = deliveryLocationData.entrance != null
                            ? ', подъезд: ${deliveryLocationData.entrance}'
                            : '';
                        deliveryText =
                            '${deliveryText}${house}${flat}${entrance}';
                      }
                      return TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: Text(
                                deliveryText,
                              )),
                              // Spacer(),
                              SvgPicture.asset(
                                'assets/images/edit.svg',
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DeliveryWidget()));
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.grey));
                    }),
                ValueListenableBuilder<Box<Terminals>>(
                    valueListenable:
                        Hive.box<Terminals>('currentTerminal').listenable(),
                    builder: (context, box, _) {
                      Terminals? currentTerminal = box.get('currentTerminal');
                      return TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          appBar: AppBar(
                                            leading: IconButton(
                                              icon: Icon(
                                                  Icons.arrow_back_ios_outlined,
                                                  color: Colors.black),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            centerTitle: true,
                                            title: Text('Выберите ресторан',
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                          body: Pickup(),
                                        )));
                          },
                          child: Row(
                            children: [
                              Text(currentTerminal != null
                                  ? currentTerminal.name!
                                  : 'Выберите ресторан'),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/images/edit.svg',
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(foregroundColor: Colors.grey));
                    }),
              ],
            )),
      ],
    );
  }
}