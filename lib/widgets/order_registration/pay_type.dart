import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PayType extends StatefulWidget {
  const PayType({Key? key}) : super(key: key);

  @override
  State<PayType> createState() => _PayTypeState();
}

class _PayTypeState extends State<PayType> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool selected = false;
  final myTabs = [
    Container(
      height: 30,
      width: 130,
      child: Tab(text: 'Наличными'),
    ),
    Container(
      height: 30,
      width: 130,
      child: Tab(text: 'Онлайн'),
    ),
    Container(
        height: 30,
        width: 130,
        child: Tab(
          text: 'Картой',
        ))
  ];

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

  Widget inCash() {
    return TextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(23),
        ),
        fillColor: Colors.grey.shade300,
        filled: true,
        hintText: 'С какой суммы подготовить сдачу ?',
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
      ),
      onChanged: (value) {},
    );
  }

  Widget online() {
    return Row(children: [
      Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.yellow.shade700)),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          'assets/images/payme.png',
        ),
      ),
      Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Image.asset(
          'assets/images/click.png',
        ),
      ),
      Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          'assets/images/oson.png',
        ),
      )
    ]);
  }

  Widget byCard() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.yellow.shade700)),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          'assets/images/uzcard.png',
        ),
      ),
      Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          'assets/images/humo.png',
        ),
      ),
      Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          'assets/images/visa.png',
        ),
      ),
      Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey)),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          'assets/images/mastercard.png',
        ),
      )
    ]);
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
            SizedBox(
              height: 20,
            ),
            DefaultTabController(
                length: 2,
                child: TabBar(
                  isScrollable: true,

                  labelColor: Colors.white,
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
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
                height: MediaQuery.of(context).size.height * 0.1,
                child: TabBarView(
                    controller: _tabController,
                    children: [inCash(), online(), byCard()]))
          ],
        ));
  }
}
