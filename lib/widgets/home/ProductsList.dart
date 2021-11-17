import 'dart:convert';

import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/pages/product_detail.dart';
import 'package:chopar_app/widgets/products/50_50.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:niku/niku.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';

class ProductsList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final products =
        useState<List<ProductSection>>(List<ProductSection>.empty());
    final scrolledIndex = useState<int>(0);

    Future<void> getProducts() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https(
          'api.choparpizza.uz', '/api/products/public', {'perSection': '1'});
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<ProductSection> productSections = List<ProductSection>.from(
            json['data'].map((m) => new ProductSection.fromJson(m)).toList());
        products.value = productSections;
      }
    }

    useEffect(() {
      getProducts();
    }, []);
    ScrollController scrollController = new ScrollController();

    return Expanded(
        child: ScrollableListTabView(
            tabHeight: 40,
            bodyAnimationDuration: const Duration(milliseconds: 150),
            tabAnimationCurve: Curves.easeOut,
            tabAnimationDuration: const Duration(milliseconds: 200),
            tabs: products.value.map((section) {
              if (section.halfMode == 1) {
                return ScrollableListTab(
                    tab: ListTab(
                        label:
                            Text(section.attributeData?.name?.chopar?.ru ?? ''),
                        // icon: Icon(Icons.group),
                        showIconOnList: false,
                        activeBackgroundColor: Colors.yellow.shade600,
                        borderRadius: BorderRadius.circular(20)),
                    body: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (_, index) =>
                          renderCreatePizza(context, section.items),
                    ),
                );
              }
              return ScrollableListTab(
                  tab: ListTab(
                      label:
                          Text(section.attributeData?.name?.chopar?.ru ?? ''),
                      // icon: Icon(Icons.group),
                      showIconOnList: false,
                      activeBackgroundColor: Colors.yellow.shade600,
                      borderRadius: BorderRadius.circular(20)),
                  body: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: section.items?.length ?? 1,
                    itemBuilder: (_, index) =>
                        renderProduct(context, section.items?[index]),
                  ));
            }).toList()));
  }

  Widget renderCreatePizza(BuildContext context, List<Items>? items) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: InkWell(child: Image.network(
                    'https://choparpizza.uz/createYourPizza.png',
                    width: 170.0,
                    height: 170.0,
                  ), onTap: () {

                    showMaterialModalBottomSheet(
                        expand: false,
                        context: context,
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            CreateOwnPizza(items));
                  },)),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Соберите свою пиццу',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w700),
                            ),
                            OutlinedButton(
                              child: Text(
                                'Собрать пиццу',
                                style: TextStyle(color: Colors.yellow.shade600),
                              ),
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(BorderSide(
                                      width: 1.0,
                                      color: Colors.yellow.shade600)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0)))),
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    isDismissible: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        CreateOwnPizza(items));
                              },
                            )
                          ])))
            ],
          )
        ],
      ),
    );
  }

  Widget renderProduct(BuildContext context, Items? product) {
    String image = product?.image as String;
    final formatCurrency = new NumberFormat.currency(
        locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
    String productPrice = '';

    if (product?.variants != null && product!.variants!.isNotEmpty) {
      productPrice = product.variants!.first.price;
    } else {
      productPrice = product!.price;
    }

    productPrice = formatCurrency.format(double.tryParse(productPrice));

    return Column(
      children: [
        SizedBox(
          height: 15.0,
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: InkWell(child: Hero(
              child: Image.network(
                image,
                width: 170.0,
                height: 170.0,
                // width: MediaQuery.of(context).size.width / 2.5,
              ),
              tag: image,
            ), onTap: () {
              showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ProductDetail(
                    detail: product,
                  ));
            },),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    product.attributeData?.name?.chopar?.ru ?? '',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                  ),
                  Html(
                    data: product.attributeData?.description?.chopar?.ru ?? '',
                    // style: TextStyle(
                    //     fontSize: 11.0, fontWeight: FontWeight.w400, height: 2),
                  ),
                  OutlinedButton(
                    child: Text(
                      'от ' + productPrice,
                      style: TextStyle(color: Colors.yellow.shade600),
                    ),
                    style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(
                            width: 1.0, color: Colors.yellow.shade600)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)))),
                    onPressed: () {
                      showMaterialModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => ProductDetail(
                                detail: product,
                              ));
                    },
                  ),
                ],
              ),
            ),
          )
        ]),
        SizedBox(
          height: 15.0,
        )
      ],
    );
  }
}

// class ProductsList extends HookWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     final products =
//         useState<List<ProductSection>>(List<ProductSection>.empty());
//     final scrolledIndex = useState<int>(0);
//
//
//     Future<void> getProducts() async {
//       Map<String, String> requestHeaders = {
//         'Content-type': 'application/json',
//         'Accept': 'application/json'
//       };
//       var url = Uri.https(
//           'api.hq.fungeek.net', '/api/products/public', {'perSection': '1'});
//       var response = await http.get(url, headers: requestHeaders);
//       if (response.statusCode == 200) {
//         var json = jsonDecode(response.body);
//         List<ProductSection> productSections = List<ProductSection>.from(
//             json['data'].map((m) => new ProductSection.fromJson(m)).toList());
//         products.value = productSections;
//       }
//     }
//
//     useEffect(() {
//       getProducts();
//     }, []);
//     ScrollController scrollController = new ScrollController();
//
//     return Expanded(
//         child: Column(
//       children: [
//         LimitedBox(
//           maxHeight: 30,
//           child:
//           ListView.separated(separatorBuilder: (context, index) {
//             return SizedBox(width: 5);
//           }, itemCount: products.value.length, itemBuilder: (context, index){
//             return GestureDetector(onTap: (){
//               scrolledIndex.value = index;
//               // print(scrollController.);
//             }, child: Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//               decoration: BoxDecoration(
//                   color: scrolledIndex.value == index ? Colors.yellow.shade600 : Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(20)
//               ),
//               child: Text(products.value[index].attributeData?.name?.chopar?.ru ?? '', style: TextStyle(color: scrolledIndex.value == index ? Colors.white : Colors.black, fontWeight: FontWeight.w400),),
//             ),);
//             return Text(products.value[index].attributeData?.name?.chopar?.ru ?? '');
//           }, scrollDirection: Axis.horizontal,),
//         ),
//         SizedBox(height: 10,),
//         Expanded(
//             child: GroupListView(
//           controller: scrollController,
//           sectionsCount: products.value.length,
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           countOfItemInSection: (int section) {
//             if (products.value[section].halfMode == 1) {
//               return 1;
//             } else {
//               return products.value[section].items?.length ?? 0;
//             }
//           },
//           itemBuilder: (BuildContext context, IndexPath index) {
//             if (products.value[index.section].halfMode == 1) {
//               return renderCreatePizza(
//                   context, products.value[index.section].items);
//             } else {
//               return renderProduct(
//                   context, products.value[index.section].items?[index.index]);
//             }
//           },
//           groupHeaderBuilder: (BuildContext context, int section) {
//             if (products.value[section].halfMode == 1) {
//               return SizedBox();
//             } else {
//               return Container(
//                 child: Stack(
//                   children: [
//                     NikuText(products
//                             .value[section].attributeData?.name?.chopar?.ru ??
//                         '')
//                       ..textDecoration(TextDecoration.underline)
//                       ..textDecorationColor(Colors.yellow)
//                       ..fontSize(24.0)
//                       ..w400()
//                       ..fontFamily('Ubuntu'),
//                     SizedBox(
//                       height: 40.0,
//                     ),
//
//                     /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
//                     // Container(),
//                   ],
//                 ),
//                 width: MediaQuery.of(context).size.width,
//               );
//             }
//           },
//           separatorBuilder: (context, index) => Divider(
//             color: Colors.black,
//             height: 1,
//           ),
//           sectionSeparatorBuilder: (context, section) => SizedBox(
//             height: 20.0,
//           ),
//         )),
//       ],
//     ));
//   }
//
//   Widget renderCreatePizza(BuildContext context, List<Items>? items) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 15.0),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                   child: Image.network(
//                 'https://store.hq.fungeek.net/createYourPizza.png',
//                 width: 170.0,
//                 height: 170.0,
//               )),
//               Expanded(
//                   child: Container(
//                       padding: EdgeInsets.only(left: 15.0, right: 15.0),
//                       child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Соберите свою пиццу',
//                               style: TextStyle(
//                                   fontSize: 20.0, fontWeight: FontWeight.w700),
//                             ),
//                             OutlinedButton(
//                               child: Text(
//                                 'Собрать пиццу',
//                                 style: TextStyle(color: Colors.yellow.shade600),
//                               ),
//                               style: ButtonStyle(
//                                   side: MaterialStateProperty.all(BorderSide(
//                                       width: 1.0,
//                                       color: Colors.yellow.shade600)),
//                                   shape: MaterialStateProperty.all(
//                                       RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(25.0)))),
//                               onPressed: () {
//                                 showMaterialModalBottomSheet(
//                                     expand: false,
//                                     context: context,
//                                     isDismissible: true,
//                                     backgroundColor: Colors.transparent,
//                                     builder: (context) =>
//                                         CreateOwnPizza(items));
//                               },
//                             )
//                           ])))
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget renderProduct(BuildContext context, Items? product) {
//     String image = product?.image as String;
//     final formatCurrency = new NumberFormat.currency(
//         locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
//     String productPrice = '';
//
//     if (product?.variants != null && product!.variants!.isNotEmpty) {
//       productPrice = product.variants!.first.price;
//     } else {
//       productPrice = product!.price;
//     }
//
//     productPrice = formatCurrency.format(double.tryParse(productPrice));
//
//     return Column(
//       children: [
//         SizedBox(
//           height: 15.0,
//         ),
//         Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Expanded(
//             child: Hero(
//               child: Image.network(
//                 image,
//                 width: 170.0,
//                 height: 170.0,
//                 // width: MediaQuery.of(context).size.width / 2.5,
//               ),
//               tag: image,
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.only(left: 15.0, right: 15.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     product.attributeData?.name?.chopar?.ru ?? '',
//                     style:
//                         TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
//                   ),
//                   Html(
//                     data: product.attributeData?.description?.chopar?.ru ?? '',
//                     // style: TextStyle(
//                     //     fontSize: 11.0, fontWeight: FontWeight.w400, height: 2),
//                   ),
//                   OutlinedButton(
//                     child: Text(
//                       'от ' + productPrice,
//                       style: TextStyle(color: Colors.yellow.shade600),
//                     ),
//                     style: ButtonStyle(
//                         side: MaterialStateProperty.all(BorderSide(
//                             width: 1.0, color: Colors.yellow.shade600)),
//                         shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25.0)))),
//                     onPressed: () {
//                       showMaterialModalBottomSheet(
//                           expand: false,
//                           context: context,
//                           isDismissible: true,
//                           backgroundColor: Colors.transparent,
//                           builder: (context) => ProductDetail(
//                                 detail: product,
//                               ));
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ]),
//         SizedBox(
//           height: 15.0,
//         )
//       ],
//     );
//   }
// }
