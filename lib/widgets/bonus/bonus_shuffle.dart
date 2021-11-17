import 'dart:convert';
import 'package:chopar_app/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_dialog/overlay_dialog.dart';

class BonusShuffle extends HookWidget {
  build(BuildContext context) {

    Future<void> getProducts(BuildContext context) async {
      try {
        Box box = Hive.box<User>('user');
        User? currentUser = box.get('user');
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${currentUser?.userToken}'
        };
        var url = Uri.https(
            'api.choparpizza.uz', '/api/bonus_prods');
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          print(json);
          if (!json['success']) {
          }
        }
      } catch (e) {
      }

    }

    useEffect((){

    }, []);

    return Scaffold(
        appBar: AppBar(
          title: Text(tr('get_a_gift').toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.blue.shade600,
        ),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(10),
                color: Colors.blue.shade600,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight,
                              maxWidth: viewportConstraints.maxWidth),
                          child: Column(
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: Text(
                                  tr('mix').toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(width: 2.0, color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      // side: BorderSide(width: 20, color: Colors.black)
                                  ),
                                  backgroundColor: Colors.yellow.shade600
                                ),
                              ),

                            ],
                          )));
                }))));
  }
}
