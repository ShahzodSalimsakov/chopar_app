import 'dart:convert';
import 'dart:math';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/basket_data.dart';
import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_dialog/overlay_dialog.dart';

class BonusShuffle extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isBonusListSuccess = useState<bool>(false);
    final errorMessage = useState<String>('');
    final products = useState<List<Items>>(List<Items>.empty());
    final hideProducts = useState<bool>(false);
    final isShuffle = useState<bool>(false);
    final bonusProduct = useState<Items?>(null);

    Future<void> getProducts(BuildContext context) async {
      try {
        Box box = Hive.box<User>('user');
        User? currentUser = box.get('user');
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
            errorMessage.value = json['message'];
          } else {
            isBonusListSuccess.value = true;
            List<Items> productSections = List<Items>.from(
                json['data'].map((m) => new Items.fromJson(m)).toList());
            products.value = productSections;
          }
        }
      } catch (e) {}
    }

    Future<void> getBonusProd(BuildContext context) async {
      Box userBox = Hive.box<User>('user');
      User? user = userBox.get('user');
      Box basketBox = Hive.box<Basket>('basket');
      Basket? basket = basketBox.get('basket');
      // let basketId = localStorage.getItem('basketId')
      // const otpToken = Cookies.get('opt_token')
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      if (user != null) {
        requestHeaders['Authorization'] = 'Bearer ${user.userToken}';
      }
      Map<String, dynamic> queryParams = {};
      if (basket != null) {
        queryParams['basketId'] = basket.encodedId;
      }
      var url =
          Uri.https('api.choparpizza.uz', '/api/bonus_prods/show', queryParams);
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        BasketData basketData =
            new BasketData.fromJson(json['data']['basketResponse']);
        Basket newBasket = new Basket(
            encodedId: basketData.encodedId ?? '',
            lineCount: basketData.lines?.length ?? 0);
        basketBox.put('basket', newBasket);
        bonusProduct.value = new Items.fromJson(json['data']['prodData']);
      }
    }

    useEffect(() {
      getProducts(context);
    }, []);

    Widget renderProduct(context, index) {
      var product = products.value[index];
      String image = hideProducts.value
          ? 'https://store.hq.fungeek.net/surprise/box.png'
          : product?.image as String;
      return GestureDetector(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              hideProducts.value
                  ? SizedBox()
                  : Positioned(
                      child: Container(
                          child: Center(
                        child: Text(
                          product.attributeData!.name!.chopar!.ru
                                  ?.toUpperCase() ??
                              '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                      bottom: 10,
                      left: 0,
                      right: 0,
                    ),
              Positioned(
                child: Image.network(
                  image,
                  width: 170.0,
                  height: 170.0,
                  // width: MediaQuery.of(context).size.width / 2.5,
                ),
                top: -20,
              )
            ],
            clipBehavior: Clip.none,
          ),
        ),
        onTap: () {
          if (isShuffle.value) {
            getBonusProd(context);
          }
        },
      );
    }

    Widget renderPage() {
      if (isBonusListSuccess.value) {
        if (!isShuffle.value) {
          return Column(
            children: [
              Text(
                tr('stir_to'),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                tr('get_a_gift'),
                style: TextStyle(
                    color: Colors.yellow.shade600,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () {
                  var newProducts = products.value;
                  newProducts.shuffle(Random());
                  hideProducts.value = true;
                  isShuffle.value = true;
                  products.value = List<Items>.empty();
                  products.value = newProducts;
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    tr('mix').toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 2.0, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      // side: BorderSide(width: 20, color: Colors.black)
                    ),
                    backgroundColor: Colors.yellow.shade600),
              ),
              SizedBox(
                height: 30,
              ),
              // Expanded(child: AnimationLimiter(
              //   child: GridView.count(
              //     crossAxisCount: 2,
              //     children: List.generate(
              //       products.value.length,
              //           (int index) {
              //         return AnimationConfiguration.staggeredGrid(
              //           position: index,
              //           duration: const Duration(milliseconds: 375),
              //           columnCount: 2,
              //           child: ScaleAnimation(
              //             child: FadeInAnimation(
              //               child: renderProduct(context, index),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // )),
              Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisSpacing: 20),
                      itemCount: products.value.length,
                      itemBuilder: (context, index) =>
                          renderProduct(context, index)))
            ],
          );
        } else {
          if (bonusProduct.value == null) {
            return Column(
              children: [
                Text(
                  tr('choose_one_of_the_boxes'),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                    child: AnimationLimiter(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                      products.value.length,
                      (int index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: renderProduct(context, index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )),
                // Expanded(child:
                // GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //   mainAxisSpacing: 20
                // ), itemCount: products.value.length, itemBuilder: (context, index) => renderProduct(context, index)))
              ],
            );
          } else {
            return Center(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(bonusProduct.value!.attributeData!.name!.chopar!.ru ?? '', style: TextStyle(color: Colors.blue.shade600, fontSize: 24, fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Image.network(bonusProduct.value!.image!),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(tr('congratulations') + ' ', style: TextStyle(color: Colors.yellow.shade600, fontSize: 20),),
                      Text(tr('your_winnings'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                    ],),
                    Text(tr('automatic_added'), style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                    SizedBox(height: 15,),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context)..pop()..pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          tr('go_to_home').toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 2.0, color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            // side: BorderSide(width: 20, color: Colors.black)
                          ),
                          backgroundColor: Colors.blue.shade600),
                    )
                  ],
                ),
              ),
            );
          }
        }
      } else {
        return Center(
          child: Text(tr(errorMessage.value), style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
        );
      }
    }

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
                child: renderPage())));
  }
}
