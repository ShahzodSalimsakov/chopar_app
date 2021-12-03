import 'package:chopar_app/models/pay_cash.dart';
import 'package:chopar_app/models/pay_type.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PayTypeWidget extends StatefulWidget {
  const PayTypeWidget({Key? key}) : super(key: key);

  @override
  State<PayTypeWidget> createState() => _PayTypeState();
}

class _PayTypeState extends State<PayTypeWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool selected = false;
  final myTabs = [
    Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Tab(text: 'Наличными'),
    ),
    Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Tab(text: 'Онлайн'),
    ),
    Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Tab(
          text: 'Картой',
        ))
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);

    PayType newPayType = new PayType();
    newPayType.value = 'offline';
    Hive.box<PayType>('payType').put('payType', newPayType);

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        PayType newPayType = new PayType();
        newPayType.value = 'offline';
        Hive.box<PayType>('payType').put('payType', newPayType);
      } else {
        Hive.box<PayCash>('payCash').delete('payCash');
      }
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget inCash() {
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(23),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: 'С какой суммы подготовить сдачу?',
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
      ),
      onChanged: (value) {
        PayCash payCash = new PayCash();
        payCash.value = value;
        Hive.box<PayCash>('payCash').put('payCash', payCash);
      },
      scrollPadding: EdgeInsets.all(100),
    );
  }

  Widget online() {
    Terminals? currentTerminal =
        Hive.box<Terminals>('currentTerminal').get('currentTerminal');
    PayType? payType = Hive.box<PayType>('payType').get('payType');

    List<String> payments = [];

    if (currentTerminal != null) {
      Map<String, dynamic> terminalJson = currentTerminal.toJson();
      terminalJson.keys.forEach((key) {
        if (key.indexOf('_active') > 1 && terminalJson[key] == true) {
          payments.add(key.replaceAll('_active', ''));
        }
      });
    }

    return Row(
        children: payments
            .map((payment) => GestureDetector(
                  onTap: () {
                    PayType newPayType = new PayType();
                    newPayType.value = payment;
                    Hive.box<PayType>('payType').put('payType', newPayType);
                  },
                  child: Container(
                    height: 78,
                    width: 78,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: payType != null && payType.value == payment
                            ? Border.all(color: Colors.yellow.shade700)
                            : Border.all(width: 0)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset(
                      'assets/images/$payment.png',
                    ),
                  ),
                ))
            .toList());
  }

  Widget byCard() {
    PayType? payType = Hive.box<PayType>('payType').get('payType');
    return Row(children: [
      GestureDetector(
          onTap: () {
            PayType newPayType = new PayType();
            newPayType.value = 'uzcard';
            Hive.box<PayType>('payType').put('payType', newPayType);
          },
          child: Container(
            height: 78,
            width: 78,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: payType != null && payType.value == 'uzcard'
                    ? Border.all(color: Colors.yellow.shade700)
                    : Border.all(width: 0)),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              'assets/images/uzcard.png',
            ),
          )),
      SizedBox(
        width: 10,
      ),
      GestureDetector(
          onTap: () {
            PayType newPayType = new PayType();
            newPayType.value = 'humo';
            Hive.box<PayType>('payType').put('payType', newPayType);
          },
          child: Container(
            height: 78,
            width: 78,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: payType != null && payType.value == 'humo'
                    ? Border.all(color: Colors.yellow.shade700)
                    : Border.all(width: 0)),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              'assets/images/humo.png',
            ),
          )),
    ]);
  }

  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<PayType>>(
        valueListenable: Hive.box<PayType>('payType').listenable(),
        builder: (context, box, _) {
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
                  SizedBox(
                    height: 20,
                  ),
                  DefaultTabController(
                      length: 2,
                      child: TabBar(
                        isScrollable: true,
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                        tabs: myTabs,
                        controller: _tabController,
                        // unselectedLabelStyle: TextStyle(backgroundColor: Colors.grey),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.yellow.shade700,
                        ),
                        unselectedLabelColor: Colors.grey,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: TabBarView(
                          controller: _tabController,
                          children: [inCash(), online(), byCard()]))
                ],
              ));
        });
  }
}
