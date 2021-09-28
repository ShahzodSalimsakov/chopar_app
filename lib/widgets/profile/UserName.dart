import 'package:flutter/material.dart';

class UserName extends StatelessWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Привет, Зафар!',
              style: TextStyle(fontSize: 26),

            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Это ваш личный кабинет. Здесь вы можете управлять своими заказами, редактировать личные данные.',
          style: TextStyle(fontSize: 12),
        ),
        // Expanded(
        //   // width: 300,
        //   child: Column(
        //   children: [
        //     ,
        //     ,
        //   ],
        // ),),

      ],
    );
  }
}
