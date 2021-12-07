import 'dart:convert';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class UserName extends StatelessWidget {
  const UserName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<User>>(
        valueListenable: Hive.box<User>('user').listenable(),
        builder: (context, box, _) {
          User? currentUser = box.get('user');
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Привет, ${currentUser != null ? currentUser.name : ''}!',
                          style: TextStyle(fontSize: 26),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Это ваш личный кабинет. Здесь вы можете управлять своими заказами, редактировать личные данные.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                width: MediaQuery.of(context).size.width * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      child: SvgPicture.asset('assets/images/logout.svg'),
                      onTap: () async {
                        Box<User> transaction = Hive.box<User>('user');
                        User currentUser = transaction.get('user')!;
                        Map<String, String> requestHeaders = {
                          'Content-type': 'application/json',
                          'Accept': 'application/json',
                          'Authorization': 'Bearer ${currentUser.userToken}'
                        };
                        String? token =
                            await FirebaseMessaging.instance.getToken();
                        var url =
                            Uri.https('api.choparpizza.uz', '/api/logout');
                        var formData = {};
                        if (token != null) {
                          formData['token'] = token;
                        }
                        var response = await http.post(url,
                            headers: requestHeaders,
                            body: jsonEncode(formData));
                        if (response.statusCode == 200) {
                          var json = jsonDecode(response.body);
                        }
                        box.delete('user');
                        Box<Basket> basketBox = Hive.box<Basket>('basket');
                        basketBox.delete('basket');
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
