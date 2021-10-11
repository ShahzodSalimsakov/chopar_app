import 'package:flutter/material.dart';

class Basket extends StatefulWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  int _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    Widget basketItems() {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 40),
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.network(
                    'https://api.choparpizza.uz/storage/products/2021/09/27/EPj1hQCL3I9YOoPKBzOLTqyKPKPnxU0r3HvtSvB3.webp',
                    width: 60.0,
                    height: 60.0,
                    // width: MediaQuery.of(context).size.width / 2.5,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        child: Text(
                          'БАЙРАМ 30 + КОРОБКА 30',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    '92 000 сум',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 30.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.yellow.shade600,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.remove,
                              size: 20.0, color: Colors.yellow.shade600),
                          onPressed: () => setState(() => _itemCount--),
                        ),
                        Text(
                          _itemCount.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.yellow.shade600,
                              fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add,
                                size: 20.0, color: Colors.yellow.shade600),
                            onPressed: () => setState(() => _itemCount++))
                      ],
                    ),
                  )
                ],
              )
            ],
          ));
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 88,
        title: Text('Корзина'),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 1,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemBuilder: (context, index) {
                      return basketItems();
                    }),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1 товар',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                          Text('125 000 сум',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18))
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Доставка',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                          Text('10 000 сум',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18))
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Итого:',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          Text('135  000 сум',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Оформить заказ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.yellow.shade700),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0),
                                )))))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
