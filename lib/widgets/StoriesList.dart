import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoriesList extends StatelessWidget {
  const StoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: 6),
                  child: InkWell(
                onTap: () {},
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset('assets/images/pizza.png'),
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(top: 70, left: 5, right: 5),
                          child: Text(
                            'Комбо-сеты на двоих от 40 000 сумов',
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                  ],
                ),
              ));
            }));
  }
}
