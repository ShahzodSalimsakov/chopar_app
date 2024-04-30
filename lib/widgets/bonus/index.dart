import 'dart:convert';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:chopar_app/widgets/bonus/bonus_shuffle.dart';
import 'package:chopar_app/widgets/profile/unautorised_user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class BonusIndex extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isBonusListSuccess = useState<bool>(false);
    final errorMessage = useState<String>('');

    Box box = Hive.box<User>('user');
    User? currentUser = box.get('user');
    Future<void> getProducts(BuildContext context) async {
      try {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${currentUser?.userToken}'
        };
        var url = Uri.https('api.choparpizza.uz', '/api/bonus_prods');
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          if (!json['success']) {
            errorMessage.value = 'you_have_bonus_already';
          } else {
            isBonusListSuccess.value = true;
          }
        }
      } catch (e) {}
    }

    useEffect(() {
      getProducts(context);
      return null;
    }, []);

    return ValueListenableBuilder<Box<User>>(
        valueListenable: Hive.box<User>('user').listenable(),
        builder: (context, box, _) {
          bool isUserAuthorized = UserRepository().isAuthorized();
          if (isUserAuthorized) {
            return Scaffold(
              appBar: AppBar(
                title: Text(tr('get_a_gift').toUpperCase()),
                centerTitle: true,
                backgroundColor: Colors.blue.shade600,
              ),
              body: SafeArea(
                  child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(10),
                color: Colors.blue.shade600,
                child: isBonusListSuccess.value
                    ? LayoutBuilder(builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                        return SingleChildScrollView(
                            child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight,
                              maxWidth: viewportConstraints.maxWidth),
                          child: Center(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Chopar '.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.yellow.shade600,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      EasyLocalization.of(context)!
                                                  .locale
                                                  .toString() ==
                                              'ru'
                                          ? tr('gives')
                                          : tr('gift'),
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                Text(
                                  EasyLocalization.of(context)!
                                              .locale
                                              .toString() ==
                                          'ru'
                                      ? tr('gift')
                                      : tr('gives'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Html(
                                  data: tr('gift_text'),
                                  style: {
                                    'div': Style(
                                        color: Colors.white,
                                        fontSize: FontSize.large)
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(bottom: 30),
                                        decoration: BoxDecoration(
                                          // color: Colors.black,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://choparpizza.uz/surpriseButton.png'),
                                              fit: BoxFit.cover), // button text
                                        ),
                                        child: Text(
                                          tr('get_a_gift'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26),
                                        )),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BonusShuffle(),
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ));
                      })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr(errorMessage.value),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context)..pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                tr('go_to_home').toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                                side:
                                    BorderSide(width: 2.0, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  // side: BorderSide(width: 20, color: Colors.black)
                                ),
                                backgroundColor: Colors.blue.shade600),
                          )
                        ],
                      ),
              )),
            );
          } else {
            return UnAuthorisedUserPage(
              title: tr('get_a_gift'),
            );
          }
        });
  }
}
