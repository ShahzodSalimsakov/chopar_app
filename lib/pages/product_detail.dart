import 'dart:convert';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/basket_data.dart';
import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:collection/collection.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/delivery_type.dart';
import '../models/terminals.dart';

var _scrollController = ScrollController();

class ProductDetail extends HookWidget {
  const ProductDetail({Key? key, required this.detail, modifiers})
      : super(key: key);

  final detail;

  Widget makeDismisible(
          {required BuildContext context, required Widget child}) =>
      GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: GestureDetector(onTap: () {}, child: child));

  Widget modifierImage(Modifiers mod) {
    if (mod.assets != null && mod.assets!.isNotEmpty) {
      return Image.network(
        'https://api.choparpizza.uz/storage/${mod.assets![0].location}/${mod.assets![0].filename}',
        width: 100.0,
        height: 73.0,
        // width: MediaQuery.of(context).size.width / 2.5,
      );
    } else {
      if (mod.xmlId.isNotEmpty) {
        return ClipOval(
          child: SvgPicture.network(
            'https://choparpizza.uz/no_photo.svg',
            width: 100.0,
            height: 73.0,
          ),
        );
      } else {
        return Image.network(
          'https://choparpizza.uz/sausage_modifier.png',
          width: 100.0,
          height: 73.0,
          // width: MediaQuery.of(context).size.width / 2.5,
        );
      }
    }
  }

  List<Widget> modifiersList(List<Modifiers> modifiers, addModifier,
      activeModifiers, BuildContext context) {
    if (detail.variants.length > 0) {
      final formatCurrency = new NumberFormat.currency(
          locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
      return [
        SizedBox(height: 20.0),
        Text(
          'Добавить в пиццу',
          style: TextStyle(color: Colors.yellow.shade600, fontSize: 16.0),
        ),
        SizedBox(height: 10.0),
        Container(
          height: 500,
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: List.generate(modifiers.length, (index) {
              var m = modifiers[index];
              return LimitedBox(
                maxHeight: 100,
                child: InkWell(
                    onTap: () {
                      addModifier(m.id);
                    },
                    child: Container(
                        height: 75,
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                              color: activeModifiers.value.contains(m.id)
                                  ? Colors.yellow.shade600
                                  : Colors.grey),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.3),
                          //     spreadRadius: 2,
                          //     blurRadius: 3, // changes position of shadow
                          //   ),
                          // ],
                        ),
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            /*Expanded(
                                  child: */
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(children: [
                                  modifierImage(m),
                                  SizedBox(height: 10),
                                  SafeArea(
                                      child: Center(
                                    widthFactor: 0.5,
                                    child: Text(
                                      m.name,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )),
                                  SizedBox(height: 10),
                                  DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 10),
                                          child: Text(
                                              formatCurrency.format(m.price)))),
                                ]),
                              ],
                            ) /*)*/,
                            Positioned(
                              child: activeModifiers.value.contains(m.id)
                                  ? Icon(Icons.check_circle_outline,
                                      color: Colors.yellow.shade600)
                                  : SizedBox(width: 0.0),
                              width: 10.0,
                              height: 10.0,
                              top: 0,
                              right: 10.0,
                            )
                          ],
                        ))),
              );
            }),
          ),
        )
      ];
    } else {
      return [
        SizedBox(
          height: 1.0,
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final configData = useState<Map<String, dynamic>?>(null);
    Future<void> fetchConfig() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.choparpizza.uz', 'api/configs/public');
      var response = await http.get(url, headers: requestHeaders);

      var json = jsonDecode(response.body);
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      configData.value = jsonDecode(stringToBase64.decode(json['data']));
    }

    useEffect(() {
      Future.delayed(Duration(seconds: 1), () {
        _scrollController
            .animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
        )
            .then((value) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          );
        });
        // _scrollController.dispose();
      });
      fetchConfig();
    });

    final formatCurrency = new NumberFormat.currency(
        locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);

    String defaultSelectedVariant = '';
    if (detail.variants != null && detail.variants.length > 0) {
      defaultSelectedVariant = detail.variants[1].customName;
    }
    final selectedVariant = useState<String>(defaultSelectedVariant);
    final activeModifiers = useState<List<int>>([]);
    final _isBasketLoading = useState<bool>(false);
    final modifiers = useMemoized(() {
      List<Modifiers> modifier = List<Modifiers>.empty();
      if (detail.variants != null && detail.variants.length > 0) {
        try {
          Variants? activeValue = detail.variants
              .firstWhere((item) => item.customName == selectedVariant.value);
          if (activeValue != null && activeValue.modifiers != null) {
            modifier = [...activeValue.modifiers!.where((m) => m.price > 0)];
            if (activeValue.modifierProduct != null) {
              // Modifiers? sausageModifier = modifier.firstWhere(
              //     (mod) => mod.id == activeValue.modifierProduct?.id, orElse: () => null);
              // if (sausageModifier != null) {
              modifier.add(new Modifiers(
                id: activeValue.modifierProduct?.id ?? 0,
                createdAt: '',
                updatedAt: '',
                name: 'Сосисочный борт',
                xmlId: '',
                price: int.parse(double.parse(
                            activeValue.modifierProduct?.price ?? '0.0000')
                        .toStringAsFixed(0)) -
                    int.parse(
                        double.parse(activeValue.price).toStringAsFixed(0)),
                weight: 0,
                groupId: '',
                nameUz: 'Sosiskali tomoni',
              ));
              // }
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        if (detail.modifiers != null) {
          modifier = detail.modifiers;
        }
      }

      if (modifier.isNotEmpty) {
        modifier.sort((a, b) => b.price.compareTo(a.price));
      }

      return modifier;
    }, [detail, selectedVariant.value]);

    addModifier(int modId) {
      ModifierProduct? modifierProduct;
      if (detail.variants != null && detail.variants.length > 0) {
        try {
          Variants? activeValue = detail.variants
              .firstWhere((item) => item.customName == selectedVariant.value);
          if (activeValue != null && activeValue.modifierProduct != null) {
            modifierProduct = activeValue.modifierProduct;
          }
        } catch (e) {}
      }
      // Modifiers zeroModifier = modifiers.firstWhere((mod) => mod.price == 0);
      if (activeModifiers.value.contains(modId)) {
        Modifiers currentModifier =
            modifiers.firstWhere((mod) => mod.id == modId);
        if (currentModifier == null) return;
        if (currentModifier.price == 0) return;
        List<int> resultModifiers = activeModifiers.value
            .where((id) => modId != id)
            .where((id) => id != null)
            .toList();
        // if (resultModifiers.length == 0) {
        //   resultModifiers.add(zeroModifier.id);
        // }
        activeModifiers.value = resultModifiers;
      } else {
        Modifiers currentModifier =
            modifiers.firstWhere((mod) => mod.id == modId);
        if (currentModifier.price == 0) {
          activeModifiers.value = [modId].toList();
        } else {
          List<int> selectedModifiers = [
            ...activeModifiers.value,
            modId,
          ].toList();

          if (modifierProduct != null) {
            Modifiers sausage =
                modifiers.firstWhere((mod) => mod.id == modifierProduct?.id);
            if (selectedModifiers.contains(modifierProduct.id) &&
                sausage.price < currentModifier.price) {
              selectedModifiers = [
                ...selectedModifiers.where((modId) => modId != sausage.id),
              ].toList();
            } else if (currentModifier.id == sausage.id) {
              List<int> richerModifier = modifiers
                  .where((mod) => mod.price > sausage.price)
                  .map((mod) => mod.id)
                  .toList();
              selectedModifiers = [
                ...selectedModifiers
                    .where((modId) => !richerModifier.contains(modId)),
                modId,
              ].toList();
            }
          }
          activeModifiers.value = selectedModifiers;
        }
      }
    }

    var totalPrice = useMemoized(() {
      int price =
          int.parse(double.parse(detail.price ?? '0.0000').toStringAsFixed(0));
      if (detail.variants != null && detail.variants.length > 0) {
        try {
          Variants? activeValue = detail.variants
              .firstWhere((item) => item.customName == selectedVariant.value);
          if (activeValue != null) {
            price += int.parse(
                double.parse(activeValue.price.toString() ?? '0.0000')
                    .toStringAsFixed(0));
          }

          if (modifiers != null && modifiers.isNotEmpty) {
            modifiers.forEach((mod) {
              if (activeModifiers.value.contains(mod.id)) {
                price += int.parse(
                    double.parse(mod.price.toString() ?? '0.0000')
                        .toStringAsFixed(0));
              }
            });
          }
        } catch (e) {}
      }
      Box<DeliveryType> box = Hive.box<DeliveryType>('deliveryType');
      DeliveryType? deliveryType = box.get('deliveryType');

      Terminals? currentTerminal =
          Hive.box<Terminals>('currentTerminal').get('currentTerminal');

      if (configData.value?["discount_end_date"] != null &&
          deliveryType?.value == DeliveryTypeEnum.pickup &&
          currentTerminal != null &&
          configData.value?["discount_catalog_sections"]
              .split(',')
              .map((i) => int.parse(i))
              .contains(detail.categoryId)) {
        if (DateTime.now().weekday.toString() !=
            configData.value?["discount_disable_day"]) {
          if (DateTime.now().isBefore(
              DateTime.parse(configData.value?["discount_end_date"]))) {
            if (configData.value?["discount_value"] != null) {
              price = (price *
                      ((100 - int.parse(configData.value!["discount_value"])) /
                          100))
                  .toInt();
            }
          }
        }
      }
      return price;
    }, [
      detail.price,
      detail.variants,
      modifiers,
      activeModifiers.value,
      detail.categoryId,
      configData.value
    ]);

    Future<void> addToBasket({List<int>? mods}) async {
      ModifierProduct? modifierProduct;
      List<Map<String, int>>? selectedModifiers;
      _isBasketLoading.value = true;
      // await setCredentials()

      if (mods == null) {
        mods = activeModifiers.value;
      }
      if (modifiers != null) {
        selectedModifiers = modifiers
            .where((m) => mods!.contains(m.id))
            .map((m) => ({'id': m.id}))
            .toList();
      }

      int selectedProdId = 0;
      if (detail.variants != null && detail.variants.length > 0) {
        Variants activeVariant = detail.variants
            .firstWhere((v) => v.customName == selectedVariant.value);
        selectedProdId = activeVariant.id;
        if (activeVariant.modifierProduct != null) {
          modifierProduct = activeVariant.modifierProduct;
        }

        if (mods.length > 0 && modifierProduct != null) {
          if (mods.contains(modifierProduct.id)) {
            selectedProdId = modifierProduct.id;
            List<int> currentProductModifiersPrices = [
              ...modifiers
                  .where((mod) => mod.id != modifierProduct!.id)
                  .map((mod) => mod.price)
                  .toList(),
            ];
            selectedModifiers = modifierProduct.modifiers!
                .where(
                    (mod) => currentProductModifiersPrices.contains(mod.price))
                .map((m) => ({'id': m.id}))
                .toList();
          }
        }
      } else {
        selectedProdId = detail.id;
      }

      Box userBox = Hive.box<User>('user');
      User? user = userBox.get('user');
      Box basketBox = Hive.box<Basket>('basket');
      Basket? basket = basketBox.get('basket');
      // let basketId = localStorage.getItem('basketId')
      // const otpToken = Cookies.get('opt_token')

      if (basket != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        if (user != null) {
          requestHeaders['Authorization'] = 'Bearer ${user.userToken}';
        }

        var url = Uri.https('api.choparpizza.uz', '/api/baskets-lines');
        var formData = {
          'basket_id': basket.encodedId,
          'variants': [
            {
              'id': selectedProdId,
              'quantity': 1,
              'modifiers': selectedModifiers
            }
          ],
          'sourceType': "app"
        };
        var response = await http.post(url,
            headers: requestHeaders, body: jsonEncode(formData));
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          BasketData basketData = new BasketData.fromJson(json['data']);
          Basket newBasket = new Basket(
              encodedId: basketData.encodedId ?? '',
              lineCount: basketData.lines?.length ?? 0);
          basketBox.put('basket', newBasket);
        }
      } else {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        if (user != null) {
          requestHeaders['Authorization'] = 'Bearer ${user.userToken}';
        }

        var url = Uri.https('api.choparpizza.uz', '/api/baskets');
        var formData = {
          'variants': [
            {
              'id': selectedProdId,
              'quantity': 1,
              'modifiers': selectedModifiers
            }
          ]
        };
        var response = await http.post(url,
            headers: requestHeaders, body: jsonEncode(formData));
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          BasketData basketData = new BasketData.fromJson(json['data']);
          Basket newBasket = new Basket(
              encodedId: basketData.encodedId ?? '',
              lineCount: basketData.lines?.length ?? 0);
          basketBox.put('basket', newBasket);
        }
      }
      _isBasketLoading.value = true;
      Navigator.of(context).pop();

      showPlatformDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.cartPlus,
                      size: 80,
                      color: Colors.yellow.shade700,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Добавлено",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      detail.attributeData?.name?.chopar?.ru,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ));
          });
      return;
    }

    return makeDismisible(
        context: context,
        child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 1,
            expand: true,
            builder: (_, controller) => Stack(
                  children: [
                    Container(
                      height: double.maxFinite,
                      padding: EdgeInsets.only(
                          top: 0, left: 15, right: 15, bottom: 20),
                      color: Colors.white,
                      child: SingleChildScrollView(
                          // controller: _scrollController,
                          // physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.chevronDown,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Center(
                              child: Hero(
                                  child: Image.network(
                                    detail.image,
                                    width: 250.0,
                                    height: 250.0,
                                    // width: MediaQuery.of(context).size.width / 2.5,
                                  ),
                                  tag: detail.image)),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            detail.attributeData?.name?.chopar?.ru ?? '',
                            style: TextStyle(fontSize: 26),
                          ),
                          Html(
                            data:
                                detail.attributeData?.description?.chopar?.ru ??
                                    '',
                            // style: TextStyle(
                            //     fontSize: 11.0, fontWeight: FontWeight.w400, height: 2),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List<Widget>.generate(
                                  detail.variants.length, (index) {
                                return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 3.0),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        25.0))),
                                            backgroundColor: MaterialStateProperty.all(
                                                selectedVariant.value == detail.variants[index].customName
                                                    ? Colors.yellow.shade600
                                                    : Colors.grey.shade100)),
                                        child: Text(detail.variants[index].customName,
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: selectedVariant.value == detail.variants[index].customName
                                                    ? Colors.white
                                                    : Colors.grey)),
                                        onPressed: () {
                                          selectedVariant.value =
                                              detail.variants[index].customName;
                                        }));
                              }),
                            ),
                          ),
                          ...modifiersList(
                              modifiers, addModifier, activeModifiers, context),
                          // SizedBox(
                          //   height: 50,
                          // )
                          //   ],
                          // )),
                        ],
                      )),
                    ),
                    Positioned(
                        child: Container(
                          // width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          color: Colors.white,
                          child: DefaultStyledButton(
                              isLoading: _isBasketLoading.value == true
                                  ? _isBasketLoading.value
                                  : null,
                              width: MediaQuery.of(context).size.width,
                              onPressed: () {
                                addToBasket();
                              },
                              text:
                                  'В корзину ${formatCurrency.format(totalPrice)}'),
                        ),
                        bottom: 0,
                        width: MediaQuery.of(context).size.width),
                  ],
                )));
  }
}
