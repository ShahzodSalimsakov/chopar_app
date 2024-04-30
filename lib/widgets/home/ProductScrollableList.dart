import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hashids2/hashids2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/parser.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:http/http.dart' as http;
import 'package:simple_html_css/simple_html_css.dart';

import '../../models/basket.dart';
import '../../models/basket_data.dart';
import '../../models/delivery_location_data.dart';
import '../../models/delivery_type.dart';
import '../../models/product_section.dart';
import '../../models/stock.dart';
import '../../models/terminals.dart';
import '../../pages/product_detail.dart';
import '../products/50_50.dart';

class ProductScrollableList extends StatefulWidget {
  final ScrollController parentScrollController;

  const ProductScrollableList({Key? key, required this.parentScrollController})
      : super(key: key);

  @override
  State<ProductScrollableList> createState() => _ProductScrollableListState();
}

class _ProductScrollableListState extends State<ProductScrollableList> {
  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  ItemScrollController verticalScrollController = ItemScrollController();
  ItemPositionsListener verticalPositionsListener =
      ItemPositionsListener.create();
  List<ProductSection> products = List<ProductSection>.empty();
  int scrolledIndex = 0;
  int? collapsedId;
  Map<String, dynamic>? configData;

  // Box<Basket> basketBox = Hive.box<Basket>('basket');
  // Basket? basket = basketBox.get('basket');

  final hashids = HashIds(
    salt: 'basket',
    minHashLength: 15,
    alphabet: 'abcdefghijklmnopqrstuvwxyz1234567890',
  );
  BasketData? basketData;

  Future<void> getBasket() async {
    Box<Basket> basketBox = Hive.box<Basket>('basket');
    Basket? basket = basketBox.get('basket');
    if (basket != null) {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };

      var url =
          Uri.https('api.choparpizza.uz', '/api/baskets/${basket.encodedId}');
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        BasketData basketLocalData = BasketData.fromJson(json['data']);
        if (basketLocalData.lines != null) {
          basket.lineCount = basketLocalData.lines!.length;
          basketBox.put('basket', basket);
        }

        setState(() {
          basketData = basketLocalData;
        });
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

      setState(() {
        products = productSections;
      });
    }
  }

  Future<void> fetchConfig() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    var url = Uri.https('api.choparpizza.uz', 'api/configs/public');
    var response = await http.get(url, headers: requestHeaders);

    var json = jsonDecode(response.body);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    setState(() {
      configData = jsonDecode(stringToBase64.decode(json['data']));
    });
  }

  scrollListening() {
    // print('listened');
    // print(verticalPositionsListener.itemPositions.value);
    verticalPositionsListener.itemPositions.addListener(() {
      ItemPosition min;
      print(verticalPositionsListener.itemPositions.value);
      if (verticalPositionsListener.itemPositions.value.isNotEmpty) {
        min = verticalPositionsListener.itemPositions.value.first;
        // print('Min Index $min');
        // print('Products count ${products.length}');
        // print(widget.parentScrollController.position.pixels);
        // print(widget.parentScrollController.position.maxScrollExtent);
        if (min.itemLeadingEdge < 0 &&
            widget.parentScrollController.position.maxScrollExtent !=
                widget.parentScrollController.position.pixels) {
          widget.parentScrollController.animateTo(
              widget.parentScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn);
        } else if (min.itemLeadingEdge == 0 &&
            min.index == 0 &&
            widget.parentScrollController.position.pixels != 0.0) {
          widget.parentScrollController.animateTo(0.0,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }

        itemScrollController.scrollTo(
            index: min.index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOutCubic,
            alignment: 0.02);

        if (scrolledIndex != min.index) {
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() {
              scrolledIndex = min.index;
            });
          });
        }
      }
    });
  }

  Future<void> decreaseQuantity(Lines line) async {
    if (line.quantity == 1) {
      return;
    }

    Box<Basket> basketBox = Hive.box<Basket>('basket');
    Basket? basket = basketBox.get('basket');
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

      url =
          Uri.https('api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
      response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        json = jsonDecode(response.body);
        setState(() {
          basketData = BasketData.fromJson(json['data']);
        });
      }
    }
  }

  Future<void> increaseQuantity(Lines line) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

    Box<Basket> basketBox = Hive.box<Basket>('basket');
    Basket? basket = basketBox.get('basket');
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

      url =
          Uri.https('api.choparpizza.uz', '/api/baskets/${basket!.encodedId}');
      response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        json = jsonDecode(response.body);
        setState(() {
          basketData = BasketData.fromJson(json['data']);
        });
      }
    }
  }

  Widget productImage(String? image) {
    if (image != null) {
      return CachedNetworkImage(imageUrl: image, width: 170.0, height: 170.0);
      // Image.network(
      //   image,
      //   width: 170.0,
      //   height: 170.0,
      //   // width: MediaQuery.of(context).size.width / 2.5,
      // );
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
                  child: CachedNetworkImage(
                    imageUrl: 'https://choparpizza.uz/createYourPizza.png',
                    width: 170.0,
                    height: 170.0,
                  ),
                  // Image.network(
                  //   'https://choparpizza.uz/createYourPizza.png',
                  //   width: 170.0,
                  //   height: 170.0,
                  // ),
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
                                  style:
                                      TextStyle(color: Colors.yellow.shade600),
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
            ),
          )
        ],
      ),
    );
  }

  Widget renderProduct(BuildContext context, Items? product) {
    Lines? productLine;

    Box<Basket> basketBox = Hive.box<Basket>('basket');
    Basket? basket = basketBox.get('basket');
    if (basket != null) {
      if (basketData != null && basketData!.lines != null) {
        if (basketData!.lines!.length > 0) {
          // print(basketData.value!.lines![3].variant!.id);
          // if (basketData.value!.lines![3].variant!.id == 347) {
          // print(product!.variants);
          // }
          basketData!.lines!.forEach((element) {
            if (product!.variants != null) {
              product.variants!.forEach((variant) {
                if (element.variant!.productId == variant.id) {
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
    String? image = product?.image;
    final formatCurrency = new NumberFormat.currency(
        locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
    String productPrice = '';
    String beforePrice = '';

    if (product?.variants != null && product!.variants!.isNotEmpty) {
      productPrice = product.variants!.first.price;
    } else {
      productPrice = product!.price;
    }

    Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
    DeliveryType? deliveryType = box.get('deliveryType');

    Terminals? currentTerminal =
        Hive.box<Terminals>('currentTerminal').get('currentTerminal');

    if (configData?["discount_end_date"] != null &&
        deliveryType?.value == DeliveryTypeEnum.pickup &&
        currentTerminal != null &&
        configData?["discount_catalog_sections"]
            .split(',')
            .map((i) => int.parse(i))
            .contains(product.categoryId)) {
      if (DateTime.now().weekday.toString() !=
          configData?["discount_disable_day"]) {
        if (DateTime.now()
            .isBefore(DateTime.parse(configData?["discount_end_date"]))) {
          if (configData?["discount_value"] != null) {
            productPrice = (double.parse(productPrice) *
                    ((100 - double.parse(configData!["discount_value"])) / 100))
                .toString();

            if (product.variants != null && product.variants!.isNotEmpty) {
              beforePrice = product.variants!.first.price;
            } else {
              beforePrice = product.price;
            }
          }
        }
      }
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      DeliveryLocationData? deliveryLocationData =
                          Hive.box<DeliveryLocationData>('deliveryLocationData')
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
                        beforePrice.isNotEmpty
                            ? Align(
                                child: Image.asset('assets/images/sale.png',
                                    height: 30, width: 30),
                                alignment: AlignmentDirectional.topEnd,
                              )
                            : SizedBox(),
                        Text(
                          product.attributeData?.name?.chopar?.ru ?? '',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w700),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (collapsedId == product.id) {
                              setState(() {
                                collapsedId = null;
                              });
                            } else {
                              setState(() {
                                collapsedId = product.id;
                              });
                            }
                          },
                          child: RichText(
                              text: HTML.toTextSpan(
                                  context,
                                  product.attributeData?.description?.chopar
                                          ?.ru ??
                                      ''),
                              maxLines: collapsedId == product.id ? 20 : 4,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                child: Column(
                                  children: [
                                    beforePrice.isNotEmpty
                                        ? Text(
                                            double.tryParse(beforePrice)!
                                                .toStringAsFixed(0),
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.red),
                                          )
                                        : SizedBox(),
                                    Text(
                                      'от ' + productPrice,
                                      style: TextStyle(
                                          color: Colors.yellow.shade600,
                                          fontSize:
                                              beforePrice.isNotEmpty ? 17 : 16),
                                    ),
                                  ],
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

  double getProductHeight(ProductSection section) {
    double height = 200;

    if (section.halfMode == 1) {
      height = 260;
    } else {
      if (section.items != null && section.items!.length > 0) {
        height = (section.items!.length * 210) + 50;
      }
    }

    return height;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBasket();
    getProducts();
    fetchConfig();
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    verticalScrollController = ItemScrollController();
    verticalPositionsListener = ItemPositionsListener.create();
    scrollListening();
  }

  @override
  void dispose() {
    verticalPositionsListener.itemPositions.removeListener(() {});
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  if (basketData == null) {
                    getBasket();
                  } else if (basketData != null) {
                    // print(basketData.value!.lines);
                    if (basketData!.lines != null) {
                      if (basket.lineCount != basketData!.lines!.length) {
                        getBasket();
                      }
                    } else {
                      // getBasket();
                    }
                  }
                }

                return Expanded(
                    child: Column(
                  children: [
                    Container(
                      child: ScrollablePositionedList.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) => SizedBox(
                          width: 110,
                          child: GestureDetector(
                            onTap: () {
                              verticalScrollController.scrollTo(
                                  index: index,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOutCubic,
                                  alignment: 0.0005);
                              // verticalScrollController.jumpTo(index: index);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: scrolledIndex == index
                                          ? Colors.white
                                          : Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(20),
                                  color: scrolledIndex == index
                                      ? Colors.yellow.shade600
                                      : Colors.white),
                              child: Center(
                                child: Text(
                                  products[index]
                                          .attributeData
                                          ?.name
                                          ?.chopar
                                          ?.ru ??
                                      '',
                                  style: TextStyle(
                                      color: scrolledIndex == index
                                          ? Colors.white
                                          : Colors.grey.shade300),
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                        scrollDirection: Axis.horizontal,
                      ),
                      height: 30,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: ScrollablePositionedList.builder(
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) => SizedBox(
                        height: getProductHeight(products[index]),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              products[index].attributeData?.name?.chopar?.ru ??
                                  '',
                              style: TextStyle(fontSize: 20),
                            ),
                            products[index].halfMode == 1
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 1,
                                    itemBuilder: (_, index) =>
                                        renderCreatePizza(
                                            context, products[index].items),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        products[index].items?.length ?? 1,
                                    itemBuilder: (_, prodIndex) =>
                                        renderProduct(context,
                                            products[index].items?[prodIndex]),
                                  )
                          ],
                        ),
                      ),
                      itemScrollController: verticalScrollController,
                      itemPositionsListener: verticalPositionsListener,
                      scrollDirection: Axis.vertical,
                    )),
                  ],
                ));
              });
        });
  }
}
