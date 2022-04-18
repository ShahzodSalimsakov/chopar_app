import 'dart:convert';

import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/basket_data.dart';
import 'package:chopar_app/models/delivery_location_data.dart';
import 'package:chopar_app/models/delivery_type.dart';
import 'package:chopar_app/models/home_is_scrolled.dart';
import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/models/stock.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/pages/product_detail.dart';
import 'package:chopar_app/widgets/products/50_50.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:niku/niku.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:simple_html_css/simple_html_css.dart';

class ProductsList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final products =
        useState<List<ProductSection>>(List<ProductSection>.empty());
    final scrolledIndex = useState<int>(0);
    final collapsedId = useState<int?>(null);
    Box<Basket> basketBox = Hive.box<Basket>('basket');
    Basket? basket = basketBox.get('basket');

    final hashids = HashIds(
      salt: 'basket',
      minHashLength: 15,
      alphabet: 'abcdefghijklmnopqrstuvwxyz1234567890',
    );
    final basketData = useState<BasketData?>(null);

    Future<void> getBasket() async {
      if (basket != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        var url = Uri.https(
            'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          BasketData basketLocalData = BasketData.fromJson(json['data']);
          if (basketLocalData.lines != null) {
            basket.lineCount = basketLocalData.lines!.length;
            basketBox.put('basket', basket);
          }
          basketData.value = basketLocalData;
        }
      }
    }

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
      getBasket();
      getProducts();
    }, []);
    ScrollController scrollController = new ScrollController();

    Future<void> decreaseQuantity(Lines line) async {
      if (line.quantity == 1) {
        return;
      }

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      var url = Uri.https(
          'api.choparpizza.uz',
          '/api/v1/basket-lines/${hashids.encode(line.id.toString())}/remove',
          {'quantity': '1'});
      var response = await http.put(url, headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        url = Uri.https(
            'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
        response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          json = jsonDecode(response.body);
          basketData.value = BasketData.fromJson(json['data']);
        }
      }
    }

    Future<void> increaseQuantity(Lines line) async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      var url = Uri.https(
          'api.choparpizza.uz',
          '/api/v1/basket-lines/${hashids.encode(line.id.toString())}/add',
          {'quantity': '1'});
      var response = await http.post(url, headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        url = Uri.https(
            'api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
        response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200 || response.statusCode == 201) {
          json = jsonDecode(response.body);
          basketData.value = BasketData.fromJson(json['data']);
        }
      }
    }

    Widget productImage(String? image) {
      if (image != null) {
        return Image.network(
          image!,
          width: 170.0,
          height: 170.0,
          // width: MediaQuery.of(context).size.width / 2.5,
        );
      } else {
        return ClipOval(
          child: SvgPicture.network(
            'https://choparpizza.uz/no_photo.svg',
            width: 175.0,
            height: 175.0,
          ),
        );
      }
    }

    Widget renderCreatePizza(BuildContext context, List<Items>? items) {
      return Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: InkWell(
                    child: Image.network(
                      'https://choparpizza.uz/createYourPizza.png',
                      width: 170.0,
                      height: 170.0,
                    ),
                    onTap: () {
                      showMaterialModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CreateOwnPizza(items));
                    },
                  )),
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
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                                OutlinedButton(
                                  child: Text(
                                    'Собрать пиццу',
                                    style: TextStyle(
                                        color: Colors.yellow.shade600),
                                  ),
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              width: 1.0,
                                              color: Colors.yellow.shade600)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      25.0)))),
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
              ),
            )
          ],
        ),
      );
    }

    Widget renderProduct(BuildContext context, Items? product) {
      Lines? productLine;

      if (basket != null) {
        if (basketData.value != null && basketData.value!.lines != null) {
          if (basketData.value!.lines!.length > 0) {
            // print(basketData.value!.lines![3].variant!.id);
            // if (basketData.value!.lines![3].variant!.id == 347) {
            // print(product!.variants);
            // }
            basketData.value!.lines!.forEach((element) {
              if (product!.variants != null) {
                product!.variants!.forEach((variant) {
                  if (element.variant!.productId == variant!.id) {
                    productLine = element;
                  }
                });
              } else if (product.productId == element.id) {
                productLine = element;
              }
            });
          }
        }
      }

      Box<Stock> stockBox = Hive.box<Stock>('stock');
      Stock? stock = stockBox.get('stock');
      String? image = product?.image as String?;
      final formatCurrency = new NumberFormat.currency(
          locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
      String productPrice = '';

      if (product?.variants != null && product!.variants!.isNotEmpty) {
        productPrice = product.variants!.first.price;
      } else {
        productPrice = product!.price;
      }

      productPrice = formatCurrency.format(double.tryParse(productPrice));

      bool isInStock = false;

      if (stock != null) {
        if (stock.prodIds.length > 0) {
          if (stock.prodIds.indexOf(product.id) >= 0) {
            isInStock = true;
          }
        }
      }

      var html = product.attributeData?.description?.chopar?.ru ?? '';

      var document = parse(html);
      String? parsedString = parse(document.body?.text).documentElement?.text;

      return Opacity(
        opacity: isInStock ? 0.3 : 1,
        child: Card(
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  Expanded(
                    child: InkWell(
                      child: productImage(image),
                      onTap: () {
                        Box<DeliveryType> box =
                            Hive.box<DeliveryType>('deliveryType');
                        DeliveryType? deliveryType = box.get('deliveryType');
                        Terminals? currentTerminal =
                            Hive.box<Terminals>('currentTerminal')
                                .get('currentTerminal');
                        DeliveryLocationData? deliveryLocationData =
                            Hive.box<DeliveryLocationData>(
                                    'deliveryLocationData')
                                .get('deliveryLocationData');

                        //Check pickup terminal
                        if (deliveryType != null &&
                            deliveryType.value == DeliveryTypeEnum.pickup) {
                          if (currentTerminal == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Не выбран филиал самовывоза')));
                            return;
                          }
                        }

                        // Check delivery address
                        if (deliveryType != null &&
                            deliveryType.value == DeliveryTypeEnum.deliver) {
                          if (deliveryLocationData == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Не указан адрес доставки')));
                            return;
                          } else if (deliveryLocationData.address == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Не указан адрес доставки')));
                            return;
                          }
                        }

                        if (isInStock) {
                          return;
                        }
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
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.attributeData?.name?.chopar?.ru ?? '',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (collapsedId.value == product.id) {
                                collapsedId.value = null;
                              } else {
                                collapsedId.value = product.id;
                              }
                            },
                            child: RichText(
                                text: HTML.toTextSpan(
                                    context,
                                    product.attributeData?.description?.chopar
                                            ?.ru ??
                                        ''),
                                maxLines:
                                    collapsedId.value == product.id ? 20 : 4,
                                overflow: TextOverflow.ellipsis
                                //...
                                ),
                          ),
                          productLine != null
                              ? Container(
                                  height: 35,
                                  width: 123,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      color: Colors.grey.shade200),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.remove,
                                            size: 20.0, color: Colors.grey),
                                        onPressed: () {
                                          decreaseQuantity(productLine!);
                                        },
                                      ),
                                      Text(
                                        productLine!.quantity.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(Icons.add,
                                              size: 20.0, color: Colors.grey),
                                          onPressed: () {
                                            increaseQuantity(productLine!);
                                          })
                                    ],
                                  ),
                                )
                              : OutlinedButton(
                                  child: Text(
                                    'от ' + productPrice,
                                    style: TextStyle(
                                        color: Colors.yellow.shade600),
                                  ),
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              width: 1.0,
                                              color: Colors.yellow.shade600)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      25.0)))),
                                  onPressed: () {
                                    Box<DeliveryType> box =
                                        Hive.box<DeliveryType>('deliveryType');
                                    DeliveryType? deliveryType =
                                        box.get('deliveryType');
                                    Terminals? currentTerminal =
                                        Hive.box<Terminals>('currentTerminal')
                                            .get('currentTerminal');
                                    DeliveryLocationData? deliveryLocationData =
                                        Hive.box<DeliveryLocationData>(
                                                'deliveryLocationData')
                                            .get('deliveryLocationData');

                                    //Check pickup terminal
                                    if (deliveryType != null &&
                                        deliveryType.value ==
                                            DeliveryTypeEnum.pickup) {
                                      if (currentTerminal == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Не выбран филиал самовывоза')));
                                        return;
                                      }
                                    }

                                    // Check delivery address
                                    if (deliveryType != null &&
                                        deliveryType.value ==
                                            DeliveryTypeEnum.deliver) {
                                      if (deliveryLocationData == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Не указан адрес доставки')));
                                        return;
                                      } else if (deliveryLocationData.address ==
                                          null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Не указан адрес доставки')));
                                        return;
                                      }
                                    }

                                    if (isInStock) {
                                      return;
                                    }

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
              )
            ],
          ),
        ),
      );
    }

    return ValueListenableBuilder<Box<Stock>>(
        valueListenable: Hive.box<Stock>('stock').listenable(),
        builder: (context, box, _) {
          return ValueListenableBuilder(
              valueListenable: Hive.box<Basket>('basket').listenable(),
              builder: (context, box, _) {
                // getBasket();

                Box<Basket> basketBox = Hive.box<Basket>('basket');
                Basket? basket = basketBox.get('basket');

                if (basket != null) {
                  if (basketData.value == null) {
                    getBasket();
                  } else if (basketData.value != null) {
                    // print(basketData.value!.lines);
                    if (basketData.value!.lines != null) {
                      if (basket.lineCount != basketData.value!.lines!.length) {
                        getBasket();
                      }
                    } else {
                      // getBasket();
                    }
                  }
                }

                return Expanded(
                    child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          var pixels = scrollNotification.metrics.pixels;
                          HomeIsScrolled hm = new HomeIsScrolled();
                          if (pixels > 20) {
                            hm.value = true;
                          } else {
                            hm.value = false;
                          }

                          Hive.box<HomeIsScrolled>('homeIsScrolled')
                              .put('homeIsScrolled', hm);
                          return true;
                        },
                        child: ScrollableListTabView(
                            tabHeight: 50,
                            bodyAnimationDuration:
                                const Duration(milliseconds: 150),
                            tabAnimationCurve: Curves.easeOut,
                            tabAnimationDuration:
                                const Duration(milliseconds: 200),
                            tabs: products.value.map((section) {
                              if (section.halfMode == 1) {
                                return ScrollableListTab(
                                  tab: ListTab(
                                      label: Text(section.attributeData?.name
                                              ?.chopar?.ru ??
                                          ''),
                                      // icon: Icon(Icons.group),
                                      showIconOnList: false,
                                      activeBackgroundColor:
                                          Colors.yellow.shade600,
                                      borderRadius: BorderRadius.circular(20)),
                                  body: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 1,
                                    itemBuilder: (_, index) =>
                                        renderCreatePizza(
                                            context, section.items),
                                  ),
                                );
                              }
                              return ScrollableListTab(
                                  tab: ListTab(
                                      label: Text(section.attributeData?.name
                                              ?.chopar?.ru ??
                                          ''),
                                      // icon: Icon(Icons.group),
                                      showIconOnList: false,
                                      activeBackgroundColor:
                                          Colors.yellow.shade600,
                                      borderRadius: BorderRadius.circular(20)),
                                  body: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: section.items?.length ?? 1,
                                    itemBuilder: (_, index) => renderProduct(
                                        context, section.items?[index]),
                                  ));
                            }).toList())));
              });
        });
  }
}
