import 'dart:convert';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${tr('hello')}, ${currentUser != null ? currentUser.name : ''}!',
                      style: TextStyle(fontSize: 26),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 10),
                    Text(
                      tr('personal_account'),
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  ],
                ),
              ),
              SizedBox(
                  width:
                      8), // Add some spacing between the text and logout icon
              Container(
                padding: EdgeInsets.only(top: 5),
                child: InkWell(
                  child: SvgPicture.asset('assets/images/logout.svg'),
                  onTap: () async {
                    Box<User> transaction = Hive.box<User>('user');
                    User currentUser = transaction.get('user')!;
                    Map<String, String> requestHeaders = {
                      'Content-type': 'application/json',
                      'Accept': 'application/json',
                      'Authorization': 'Bearer ${currentUser.userToken}'
                    };
                    String? token = await FirebaseMessaging.instance.getToken();
                    var url = Uri.https('api.choparpizza.uz', '/api/logout');
                    var formData = {};
                    if (token != null) {
                      formData['token'] = token;
                    }
                    var response = await http.post(url,
                        headers: requestHeaders, body: jsonEncode(formData));
                    if (response.statusCode == 200) {
                      var json = jsonDecode(response.body);
                    }
                    box.delete('user');
                    Box<Basket> basketBox = Hive.box<Basket>('basket');
                    basketBox.delete('basket');
                  },
                ),
              )
            ],
          );
        });
  }
}
