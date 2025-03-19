import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/basket_data.dart';
import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:chopar_app/pages/home.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/delivery_type.dart';
import '../models/terminals.dart';

// Helper method to get localized text
String getLocalizedText(BuildContext context, dynamic chopar) {
  if (chopar == null) return '';

  final languageCode = context.locale.languageCode;

  if (languageCode == 'uz' && chopar.uz != null && chopar.uz.isNotEmpty) {
    return chopar.uz;
  } else if (languageCode == 'ru' &&
      chopar.ru != null &&
      chopar.ru.isNotEmpty) {
    return chopar.ru;
  } else {
    // Fallback to Russian if available
    return chopar.ru ?? '';
  }
}

// Helper method to get localized size
String getLocalizedSize(BuildContext context, String size) {
  if (context.locale.languageCode == 'uz') {
    switch (size) {
      case 'Средняя':
        return 'O\'rtacha';
      case 'Большая':
        return 'Katta';
      case 'Семейная':
        return 'Oilaviy';
      default:
        return size;
    }
  }
  return size;
}

var _scrollController = ScrollController();

class ProductDetail extends HookWidget {
  const ProductDetail({Key? key, required this.detail, modifiers})
      : super(key: key);

  final detail;

  Widget makeDismissible(
          {required BuildContext context, required Widget child}) =>
      GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: GestureDetector(onTap: () {}, child: child));

  Widget modifierImage(Modifiers mod) {
    if (mod.assets != null && mod.assets!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl:
            'https://api.choparpizza.uz/storage/${mod.assets![0].location}/${mod.assets![0].filename}',
        width: 100.0,
        height: 73.0,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.yellow.shade700,
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade100,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey.shade400,
              size: 40,
            ),
          ),
        ),
        memCacheWidth: 400,
        memCacheHeight: 300,
        maxWidthDiskCache: 400,
        maxHeightDiskCache: 300,
      );
    } else {
      if (mod.xmlId.isNotEmpty) {
        return ClipOval(
          child: SvgPicture.network(
            'https://choparpizza.uz/no_photo.svg',
            width: 100.0,
            height: 73.0,
            placeholderBuilder: (BuildContext context) => Container(
              padding: const EdgeInsets.all(30.0),
              child: CircularProgressIndicator(
                color: Colors.yellow.shade700,
                strokeWidth: 2,
              ),
            ),
          ),
        );
      } else {
        return CachedNetworkImage(
          imageUrl: 'https://choparpizza.uz/sausage_modifier.png',
          width: 100.0,
          height: 73.0,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade700,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade100,
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey.shade400,
                size: 30,
              ),
            ),
          ),
          memCacheWidth: 400,
          memCacheHeight: 300,
        );
      }
    }
  }

  List<Widget> modifiersList(List<Modifiers> modifiers, addModifier,
      activeModifiers, BuildContext context) {
    if (detail.variants.length > 0) {
      final formatCurrency = new NumberFormat.currency(
          locale: 'ru_RU', symbol: tr('sum'), decimalDigits: 0);
      return [
        SizedBox(height: 20.0),
        Text(
          tr('add_to_pizza'),
          style: TextStyle(color: Colors.yellow.shade600, fontSize: 16.0),
        ),
        SizedBox(height: 10.0),
        Container(
          height: 500,
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: List.generate(modifiers.length, (index) {
              var m = modifiers[index];
              return LimitedBox(
                maxHeight: 100,
                child: InkWell(
                    onTap: () {
                      addModifier(m.id);
                    },
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
                              SafeArea(
                                  child: Center(
                                widthFactor: 0.5,
                                child: Text(
                                  context.locale.languageCode == 'uz'
                                      ? m.nameUz
                                      : m.name,
                                  style: TextStyle(fontSize: 14),
                                ),
                              )),
                              DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
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
                          right: 20.0,
                        )
                      ],
                    )),
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
    final isMounted = useValueNotifier<bool>(true);
    Future<void> fetchConfig() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.choparpizza.uz', 'api/configs/public');
      var response = await http.get(url, headers: requestHeaders);

      var json = jsonDecode(response.body);
      if (isMounted.value) {
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        configData.value = jsonDecode(stringToBase64.decode(json['data']));
      }
    }

    useEffect(() {
      Future.delayed(Duration(seconds: 1), () {
        if (_scrollController.hasClients) {
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
        }
        // _scrollController.dispose();
      });
      fetchConfig();
      return () {
        isMounted.value = false;
      };
    }, []);

    final formatCurrency = new NumberFormat.currency(
        locale: 'ru_RU', symbol: tr('sum'), decimalDigits: 0);

    int defaultSelectedVariantId = 0;
    if (detail.variants != null && detail.variants.length > 0) {
      defaultSelectedVariantId = detail.variants[1].id;
    }
    final selectedVariantId = useState<int>(defaultSelectedVariantId);
    final activeModifiers = useState<List<int>>([]);
    final _isBasketLoading = useState<bool>(false);
    final modifiers = useMemoized(() {
      List<Modifiers> modifier = List<Modifiers>.empty();
      if (detail.variants != null && detail.variants.length > 0) {
        try {
          Variants? activeValue = detail.variants
              .firstWhere((item) => item.id == selectedVariantId.value);
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
    }, [detail, selectedVariantId.value]);

    addModifier(int modId) {
      ModifierProduct? modifierProduct;
      if (detail.variants != null && detail.variants.length > 0) {
        try {
          Variants? activeValue = detail.variants
              .firstWhere((item) => item.id == selectedVariantId.value);
          if (activeValue != null && activeValue.modifierProduct != null) {
            modifierProduct = activeValue.modifierProduct;
          }
        } catch (e) {}
      }
      // Modifiers zeroModifier = modifiers.firstWhere((mod) => mod.price == 0);
      if (activeModifiers.value.contains(modId)) {
        Modifiers currentModifier =
            modifiers.firstWhere((mod) => mod.id == modId);
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
              .firstWhere((item) => item.id == selectedVariantId.value);
          if (activeValue != null) {
            price += int.parse(
                double.parse(activeValue.price.toString() ?? '0.0000')
                    .toStringAsFixed(0));
          }

          if (modifiers.isNotEmpty) {
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
      selectedModifiers = modifiers
          .where((m) => mods!.contains(m.id))
          .map((m) => ({'id': m.id}))
          .toList();

      int selectedProdId = 0;
      if (detail.variants != null && detail.variants.length > 0) {
        Variants activeVariant =
            detail.variants.firstWhere((v) => v.id == selectedVariantId.value);
        selectedProdId = activeVariant.id;
        if (activeVariant.modifierProduct != null) {
          modifierProduct = activeVariant.modifierProduct;
        }

        if (mods.length > 0 && modifierProduct != null) {
          if (mods.contains(modifierProduct.id)) {
            selectedProdId = modifierProduct.id;
            List<int> currentProductModifiersPrices = [
              ...modifiers
                  .where((mod) =>
                      mod.id != modifierProduct!.id &&
                      selectedModifiers!.any((map) => map['id'] == mod.id))
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
        try {
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
                lineCount: basketData.lines?.length ?? 0,
                totalPrice: basketData.total);

            // Update the basket and force a rebuild of the UI
            basketBox.delete('basket');
            basketBox.put('basket', newBasket);

            // Just close the modal without refreshing the page
            Navigator.of(context).pop();

            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text(tr('added_to_cart')),
                  ],
                ),
                backgroundColor: Colors.yellow.shade700,
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
        } catch (e) {
          throw Exception('addToBasket: ' + e.toString());
        }
      } else {
        try {
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
                lineCount: basketData.lines?.length ?? 0,
                totalPrice: basketData.total);

            // Update the basket and force a rebuild of the UI
            basketBox.delete('basket');
            basketBox.put('basket', newBasket);

            // Just close the modal without refreshing the page
            Navigator.of(context).pop();

            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text(tr('added_to_cart')),
                  ],
                ),
                backgroundColor: Colors.yellow.shade700,
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
        } catch (e) {
          throw Exception('addToBasket: ' + e.toString());
        }
      }
      _isBasketLoading.value = false;

      Navigator.of(context).pop();
      return;

      // showPlatformDialog(
      //     context: context,
      //     builder: (context) {
      //       // Future.delayed(Duration(seconds: 1), () {
      //       //   Navigator.of(context).pop(true);
      //       // });
      //       return AlertDialog(
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.all(Radius.circular(10))),
      //           content: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               FaIcon(
      //                 FontAwesomeIcons.cartPlus,
      //                 size: 80,
      //                 color: Colors.yellow.shade700,
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               Text(
      //                 "Добавлено",
      //                 textAlign: TextAlign.center,
      //               ),
      //               SizedBox(
      //                 height: 10,
      //               ),
      //               Text(
      //                 detail.attributeData?.name?.chopar?.ru,
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(fontSize: 18),
      //               ),
      //             ],
      //           ));
      //     });

      return;
    }

    return makeDismissible(
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
                                  tag: detail.image != null &&
                                          detail.image.isNotEmpty
                                      ? detail.image
                                      : 'no_image',
                                  child: detail.image != null &&
                                          detail.image.isNotEmpty
                                      ? Image.network(
                                          detail.image,
                                          width: 250.0,
                                          height: 250.0,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 250.0,
                                              height: 250.0,
                                              color: Colors.grey.shade200,
                                              child: Center(
                                                child: Icon(
                                                  Icons
                                                      .image_not_supported_outlined,
                                                  color: Colors.grey,
                                                  size: 50,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          width: 250.0,
                                          height: 250.0,
                                          color: Colors.grey.shade200,
                                          child: Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          ),
                                        ))),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            getLocalizedText(
                                context, detail.attributeData?.name?.chopar),
                            style: TextStyle(fontSize: 26),
                          ),
                          Html(
                            data: getLocalizedText(context,
                                detail.attributeData?.description?.chopar),
                            // style: TextStyle(
                            //     fontSize: 11.0, fontWeight: FontWeight.w400, height: 2),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: detail.variants != null &&
                                      detail.variants.length > 0
                                  ? List<Widget>.generate(
                                      detail.variants.length, (index) {
                                      // Get the appropriate variant name based on language
                                      String variantName = '';
                                      if (context.locale.languageCode == 'uz' &&
                                          detail.variants[index].customNameUz !=
                                              null &&
                                          detail.variants[index].customNameUz
                                              .isNotEmpty) {
                                        variantName =
                                            detail.variants[index].customNameUz;
                                      } else {
                                        variantName =
                                            detail.variants[index].customName ??
                                                '';
                                      }

                                      // Применяем локализацию к размерам пиццы
                                      variantName = getLocalizedSize(
                                          context, variantName);

                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  25.0))),
                                                  backgroundColor: MaterialStateProperty.all(selectedVariantId.value == detail.variants[index].id
                                                      ? Colors.yellow.shade600
                                                      : Colors.grey.shade100)),
                                              child: Text(variantName,
                                                  style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: selectedVariantId.value == detail.variants[index].id
                                                          ? Colors.white
                                                          : Colors.grey)),
                                              onPressed: () {
                                                selectedVariantId.value =
                                                    detail.variants[index].id;
                                              }));
                                    })
                                  : [
                                      Container()
                                    ], // Empty container if no variants
                            ),
                          ),
                          Column(
                            children: modifiersList(modifiers, addModifier,
                                activeModifiers, context),
                          ),
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
                                '${tr('to_cart')} ${formatCurrency.format(totalPrice)}',
                          ),
                        ),
                        bottom: 0,
                        width: MediaQuery.of(context).size.width),
                  ],
                )));
  }
}
