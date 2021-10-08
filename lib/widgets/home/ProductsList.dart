import 'dart:convert';

import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/pages/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:niku/niku.dart';

class ProductsList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final products =
        useState<List<ProductSection>>(List<ProductSection>.empty());

    Future<void> getProducts() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https(
          'api.hq.fungeek.net', '/api/products/public', {'perSection': '1'});
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
        child: GroupListView(
      controller: scrollController,
      sectionsCount: products.value.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      countOfItemInSection: (int section) {
        return products.value[section].items?.length ?? 0;
      },
      itemBuilder: (BuildContext context, IndexPath index) {
        return renderProduct(
            context, products.value[index.section].items?[index.index]);
      },
      groupHeaderBuilder: (BuildContext context, int section) {
        return Container(
          child: Stack(
            children: [
              NikuText(
                  products.value[section].attributeData?.name?.chopar?.ru ?? '')
                ..textDecoration(TextDecoration.underline)
                ..textDecorationColor(Colors.yellow)
                ..fontSize(24.0)
                ..w400()
                ..fontFamily('Ubuntu'),
              SizedBox(
                height: 40.0,
              ),

              /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
              // Container(),
            ],
          ),
          width: MediaQuery.of(context).size.width,
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
        height: 1,
      ),
      sectionSeparatorBuilder: (context, section) => SizedBox(
        height: 20.0,
      ),
    ));
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
            child: Image.network(
              image,
              width: 170.0,
              height: 170.0,
              // width: MediaQuery.of(context).size.width / 2.5,
            ),
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
