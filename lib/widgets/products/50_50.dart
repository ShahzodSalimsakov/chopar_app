import 'dart:convert';
import 'package:chopar_app/models/basket.dart';
import 'package:chopar_app/models/basket_data.dart';
import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CreateOwnPizza extends HookWidget {
  final formatCurrency = new NumberFormat.currency(
      locale: 'ru_RU', symbol: 'сум', decimalDigits: 0);
  final List<Items>? items;

  CreateOwnPizza(this.items);

  Widget modifierImage(Modifiers mod) {
    if (mod.assets != null && mod.assets!.isNotEmpty) {
      // print('https://api.hq.fungeek.net/storage/${mod.assets![0].location}/${mod.assets![0].filename}');
      return Image.network(
        'https://api.hq.fungeek.net/storage/${mod.assets![0].location}/${mod
            .assets![0].filename}',
        width: 100.0,
        height: 73.0,
        // width: MediaQuery.of(context).size.width / 2.5,
      );
    } else {
      if (mod.xmlId.isNotEmpty) {
        return SvgPicture.network(
          'https://choparpizza.uz/no_photo.svg',
          width: 100.0,
          height: 73.0,
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

  @override
  Widget build(BuildContext context) {
    final activeModifiers = useState<List<int>>(List<int>.empty());
    final activeCustomName = useState<String>('');
    final leftSelectedProduct = useState<Items?>(null);
    final rightSelectedProduct = useState<Items?>(null);
    final isSecondPage = useState<bool>(false);
    final isBasketLoading = useState<bool>(false);

    changeCustomName(String name) {
      activeCustomName.value = name;
    }

    changeToSecondPage() {
      if (leftSelectedProduct.value == null ||
          rightSelectedProduct.value == null) {
        return;
      }

      isSecondPage.value = true;
    }

    final customNames = useMemoized(() {
      Map<String, String> names = {};
      items!.forEach((Items item) {
        print(item);
        item.variants?.forEach((Variants vars) {
          names[vars.customName ?? ''] = vars.customName ?? '';
        });
      });
      return names.keys.toList();
    }, [items]);

    final readyProductList = useMemoized(() {
      return items?.map((Items item) {
        item.variants?.forEach((Variants vars) {
          if (vars.customName == activeCustomName.value) {
            item.price = vars.price;
          }
        });
        return item;
      }).toList();
    }, [items, activeCustomName.value]);

    final modifiers = useMemoized(() {
      if (leftSelectedProduct.value == null ||
          rightSelectedProduct.value == null ||
          activeCustomName.value == null) {
        return List<Modifiers>.empty();
      }
      List<Modifiers>? leftModifiers = List<Modifiers>.empty();

      leftSelectedProduct.value?.variants?.forEach((Variants vars) {
        if (vars.customName == activeCustomName.value) {
          leftModifiers = vars.modifiers;
        }
      });

      Variants? activeVariant;
      leftSelectedProduct.value?.variants!.forEach((Variants vars) {
        if (vars.customName == activeCustomName.value) {
          activeVariant = vars;
        }
      });
      Variants? rightActiveVariant;
      rightSelectedProduct.value?.variants!.forEach((Variants vars) {
        if (vars.customName == activeCustomName.value) {
          rightActiveVariant = vars;
        }
      });

      if (activeVariant != null && activeVariant?.modifierProduct != null) {
        Modifiers? isExistSausage = leftModifiers
            ?.firstWhere((mod) => mod.id == activeVariant?.modifierProduct?.id);
        if (isExistSausage != null) {
          leftModifiers?.add(new Modifiers(
            id: activeVariant?.modifierProduct?.id ?? 0,
            createdAt: '',
            updatedAt: '',
            name: 'Сосисочный борт',
            xmlId: '',
            price: int.parse(double.parse(
                activeVariant?.modifierProduct?.price ?? '0.0000')
                .toStringAsFixed(0)) -
                int.parse(double.parse(activeVariant?.price ?? '0.00')
                    .toStringAsFixed(0)),
            weight: 0,
            groupId: '',
            nameUz: 'Sosiskali tomoni',
          ));
        }
      }

      if (leftModifiers != null) {
        leftModifiers?.sort((a, b) => a.price.compareTo(b.price));
      }
      if (leftModifiers == null) {
        return List<Modifiers>.empty();
      }
      return leftModifiers;
    }, [
      leftSelectedProduct.value,
      rightSelectedProduct.value,
      activeCustomName.value
    ]);

    final totalSummary = useMemoized(() {
      int res = 0;
      if (leftSelectedProduct.value != null) {
        res += int.parse(double.parse(
            leftSelectedProduct.value?.price.toString() ?? '0.0000')
            .toStringAsFixed(0));
      }

      if (rightSelectedProduct.value != null) {
        res += int.parse(double.parse(
            rightSelectedProduct.value?.price.toString() ?? '0.0000')
            .toStringAsFixed(0));
      }

      if (modifiers != null && modifiers.isNotEmpty) {
        List<Modifiers> selectedModifiers = [
          ...modifiers
              .where((Modifiers mod) => activeModifiers.value.contains(mod.id)),
        ];
        selectedModifiers.map((Modifiers mod) {
          res += int.parse(double.parse(mod.price.toString() ?? '0.0000')
              .toStringAsFixed(0));
        });
      }

      return res;
    }, [
      leftSelectedProduct.value,
      rightSelectedProduct.value,
      activeCustomName.value,
      activeModifiers.value,
    ]);

    addModifier(int id) {
      ModifierProduct? modifierProduct;
      Variants? activeVariant;

      leftSelectedProduct.value?.variants?.forEach((Variants vars) {
        if (vars.customName == activeCustomName) {
          activeVariant = vars;
        }
      });
      if (activeVariant?.modifierProduct != null) {
        modifierProduct = activeVariant?.modifierProduct;
      }
      Modifiers? zeroModifier =
      modifiers?.firstWhere((Modifiers mod) => mod.price == 0);
      if (activeModifiers.value.contains(id)) {
        Modifiers? currentModifier =
        modifiers?.firstWhere((Modifiers mod) => mod.id == id);
        if (currentModifier == null) return;
        if (currentModifier.price == 0) return;
        List<int> resultModifiers = [
          ...activeModifiers.value.where((int modId) => modId != id)
        ].where((id) => id != null).toList();
        if (resultModifiers.isEmpty && zeroModifier != null) {
          resultModifiers.add(zeroModifier.id);
        }
        activeModifiers.value = resultModifiers;
      } else {
        Modifiers? currentModifier =
        modifiers?.firstWhere((mod) => mod.id == id);
        if (currentModifier?.price == 0) {
          activeModifiers.value = [id].toList();
        } else {
          List<int> selectedModifiers = [
            ...activeModifiers.value
                .where((modId) => modId != zeroModifier?.id),
            id,
          ].toList();

          if (modifierProduct != null) {
            Modifiers sausage =
            modifiers!.firstWhere((mod) => mod.id == modifierProduct?.id);
            if (selectedModifiers.contains(modifierProduct.id) &&
                sausage!.price < currentModifier!.price) {
              selectedModifiers = [
                ...selectedModifiers.where((modId) => modId != sausage.id),
              ];
            } else if (currentModifier?.id == sausage.id) {
              List<int> richerModifier = modifiers!
                  .where((mod) => mod.price > sausage.price)
                  .map((mod) => mod.id)
                  .toList();
              selectedModifiers = [
                ...selectedModifiers
                    .where((modId) => !richerModifier.contains(modId)),
                id,
              ];
            }
          }
          activeModifiers.value = selectedModifiers;
        }
      }
    }

    Future<void> addToBasket() async {
      isBasketLoading.value = true;
      ModifierProduct? modifierProduct;
      List<Map<String, int>>? selectedModifiers;
      List<int> selectedIntModifiers = [...activeModifiers.value];
      List<Modifiers> allModifiers = [...modifiers!];
      Modifiers freeModifiers = allModifiers.firstWhere((mod) =>
      mod.price == 0);
      if (selectedIntModifiers.length == 0) {
        selectedIntModifiers.add(freeModifiers.id);
      }

      selectedModifiers = allModifiers
          .where((m) => selectedIntModifiers.contains(m.id))
          .map((m) => ({ 'id': m.id})).toList();

      Variants leftProduct = leftSelectedProduct.value!.variants!.firstWhere((
          v) => v.customName == activeCustomName.value);

      Variants rightProduct = rightSelectedProduct.value!.variants!.firstWhere((
          v) => v.customName == activeCustomName.value);

      ModifierProduct? leftModifierProduct;
      if (leftProduct.modifierProduct != null) {
        modifierProduct = leftProduct.modifierProduct;
      }
      ModifierProduct? rightModifierProduct;
      if (rightProduct.modifierProduct != null) {
        rightModifierProduct = rightProduct.modifierProduct;
      }

      if (selectedModifiers.length > 0 && modifierProduct != null) {
        if ([...activeModifiers.value].contains(modifierProduct.id)) {
          leftModifierProduct = modifierProduct;
          List<int> currentProductModifiersPrices = [
            ...modifiers
                .where(
                    (mod) =>
                mod.id != modifierProduct!.id &&
                    [...activeModifiers.value].contains(mod.id)
            )
                .map((mod) => mod.price),
          ];
          if (currentProductModifiersPrices.length > 0) {
            selectedModifiers = modifierProduct.modifiers!
                .where((mod) =>
                currentProductModifiersPrices.contains(mod.price)
            )
                .map((m) => ({ 'id': m.id})).toList();
          } else {
            selectedModifiers = [{ 'id': freeModifiers.id}];
          }
        }
      }

      Box userBox = Hive.box<User>('user');
      User? user = userBox.get('user');
      Box basketBox = Hive.box<Basket>('basket');
      Basket? basket = basketBox.get('basket');

      if (basket != null) {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        if (user != null) {
          requestHeaders['Authorization'] = 'Bearer ${user.userToken}';
        }

        var url = Uri.https('api.hq.fungeek.net', '/api/baskets-lines');
        var formData = {
          'basket_id': basket.encodedId,
          'variants': [
            {
              'id': leftModifierProduct != null ? leftModifierProduct.id : leftProduct.id,
              'quantity': 1,
              'modifiers': selectedModifiers,
              'child': {
                'id': rightModifierProduct != null ? rightModifierProduct.id : rightSelectedProduct.value!.id,
                'quantity': 1,
                'modifiers': [
                  {
                    'id': freeModifiers.id
                  }
                ]
              }
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
      } else {
        Map<String, String> requestHeaders = {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        };

        if (user != null) {
          requestHeaders['Authorization'] = 'Bearer ${user.userToken}';
        }

        var url = Uri.https('api.hq.fungeek.net', '/api/baskets');
        var formData = {
          'variants': [
            {
              'id': leftModifierProduct != null ? leftModifierProduct.id : leftProduct.id,
              'quantity': 1,
              'modifiers': selectedModifiers,
              'child': {
                'id': rightModifierProduct != null ? rightModifierProduct.id : rightSelectedProduct.value!.id,
                'quantity': 1,
                'modifiers': [
                  {
                    'id': freeModifiers.id
                  }
                ]
              }
            }
          ]
        };
        var response = await http.post(url,
            headers: requestHeaders, body: jsonEncode(formData));
        if (response.statusCode == 200 || response.statusCode == 201) {
          var json = jsonDecode(response.body);
          print(json);
          BasketData basketData = new BasketData.fromJson(json['data']);
          Basket newBasket = new Basket(
              encodedId: basketData.encodedId ?? '',
              lineCount: basketData.lines?.length ?? 0);
          basketBox.put('basket', newBasket);
        }
      }
      isBasketLoading.value = false;
      Navigator.of(context).pop();
    }

    Widget renderPage(BuildContext context) {
      if (isSecondPage.value) {
        return Stack(
          children: [
            LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          height: 300.0,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                          left: 0,
                                          child: Container(
                                            child: Image.network(
                                              leftSelectedProduct.value
                                                  ?.image ??
                                                  '',
                                              height: 300,
                                            ),
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width -
                                                30,
                                          ))
                                    ],
                                  )),
                              Expanded(
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          right: 0,
                                          child: Container(
                                            width:
                                            MediaQuery
                                                .of(context)
                                                .size
                                                .width -
                                                30,
                                            child: Image.network(
                                              rightSelectedProduct.value
                                                  ?.image ??
                                                  '',
                                              height: 300,
                                            ),
                                          ))
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Text(
                            '${leftSelectedProduct.value?.attributeData?.name
                                ?.chopar?.ru
                                ?.toUpperCase()} + ${rightSelectedProduct.value
                                ?.attributeData?.name?.chopar?.ru
                                ?.toUpperCase()}',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Divider(),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Text(
                              leftSelectedProduct
                                  .value?.attributeData?.name?.chopar?.ru
                                  ?.toUpperCase() ??
                                  '',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 24.0),
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Html(
                              data: leftSelectedProduct.value?.attributeData
                                  ?.description?.chopar?.ru ??
                                  '',
                              // style: TextStyle(
                              //     fontSize: 11.0, fontWeight: FontWeight.w400, height: 2),
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Text(
                              rightSelectedProduct
                                  .value?.attributeData?.name?.chopar?.ru
                                  ?.toUpperCase() ??
                                  '',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 24.0),
                            )),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.0),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Html(
                              data: rightSelectedProduct.value?.attributeData
                                  ?.description?.chopar?.ru ??
                                  '',
                              // style: TextStyle(
                              //     fontSize: 11.0, fontWeight: FontWeight.w400, height: 2),
                            )),
                        SizedBox(height: 20.0),
                        Text(
                          'Добавить в пиццу',
                          style: TextStyle(
                              color: Colors.yellow.shade600, fontSize: 16.0),
                        ),
                        SizedBox(height: 10.0),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  ...List<InkWell>.from(modifiers!
                                      .map((m) =>
                                      InkWell(
                                          onTap: () {
                                            addModifier(m.id);
                                          },
                                          child: Container(
                                              height: 75,
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 20),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 2,
                                                  vertical: 10.0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                border: Border.all(
                                                    color: activeModifiers.value
                                                        .contains(m.id)
                                                        ? Colors.yellow.shade600
                                                        : Colors.grey),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius:
                                                    3, // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                fit: StackFit.loose,
                                                children: [
                                                  Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                        children: [
                                                          Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  m.name,
                                                                  style: TextStyle(
                                                                      fontSize: 18),
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                DecoratedBox(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                            Radius
                                                                                .circular(
                                                                                12))),
                                                                    child: Container(
                                                                        padding: EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                            3,
                                                                            horizontal:
                                                                            10),
                                                                        child: Text(
                                                                            formatCurrency
                                                                                .format(
                                                                                m
                                                                                    .price)))),
                                                              ]),
                                                          Spacer(),
                                                          modifierImage(m)
                                                        ],
                                                      )),
                                                  Positioned(
                                                    child: activeModifiers.value
                                                        .contains(m.id)
                                                        ? Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors
                                                            .yellow.shade600)
                                                        : SizedBox(width: 0.0),
                                                    width: 10.0,
                                                    height: 10.0,
                                                    top: 5.0,
                                                    right: 5.0,
                                                  )
                                                ],
                                              ))))
                                      .toList()),
                                  SizedBox(height: 100,)
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }),
            Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(color: Colors.white),
                  child: DefaultStyledButton(
                    isLoading: isBasketLoading.value == true ? isBasketLoading.value : null,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 30,
                    onPressed: () {
                      addToBasket();
                    },
                    text: 'В корзину',
                  ),
                ))
          ],
        );
      } else {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.all(15.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(customNames.length, (index) {
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25.0))),
                                backgroundColor: MaterialStateProperty.all(
                                    activeCustomName.value == customNames[index]
                                        ? Colors.yellow.shade600
                                        : Colors.grey.shade100)),
                            child: Text(customNames[index],
                                style: TextStyle(
                                    fontSize: 13.0,
                                    color: activeCustomName.value ==
                                        customNames[index]
                                        ? Colors.white
                                        : Colors.grey)),
                            onPressed: () {
                              activeCustomName.value = customNames[index];
                            }));
                  })),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: readyProductList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Stack(
                                  children: [
                                    Opacity(
                                        opacity: rightSelectedProduct.value
                                            ?.id ==
                                            readyProductList?[index].id
                                            ? 0.25
                                            : 1,
                                        child: Container(
                                          margin: EdgeInsets.all(10.0),
                                          padding: EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(23.0),
                                              border: Border.all(
                                                  color: leftSelectedProduct
                                                      .value?.id ==
                                                      readyProductList?[index]
                                                          .id
                                                      ? Colors.yellow.shade600
                                                      : Colors.transparent,
                                                  width: 2.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white),
                                          height: 200,
                                          width: 150,
                                          child: Column(
                                            children: [
                                              Image.network(
                                                readyProductList?[index]
                                                    .image ?? '',
                                                width: 110,
                                                height: 110,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                readyProductList?[index]
                                                    .attributeData
                                                    ?.name
                                                    ?.chopar
                                                    ?.ru
                                                    ?.toUpperCase() ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 20.0),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(formatCurrency.format(
                                                  int.parse(
                                                      double.parse(
                                                          readyProductList?[index]
                                                              .price ??
                                                              '0.0000')
                                                          .toStringAsFixed(0))))
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                      child: leftSelectedProduct.value?.id ==
                                          readyProductList?[index].id
                                          ? Icon(Icons.check_circle_outline,
                                          color: Colors.yellow.shade600)
                                          : SizedBox(width: 0.0),
                                      width: 10.0,
                                      height: 10.0,
                                      top: 20.0,
                                      right: 50.0,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  if (rightSelectedProduct.value?.id ==
                                      readyProductList?[index].id) {
                                    return;
                                  }
                                  leftSelectedProduct.value =
                                  readyProductList?[index];
                                },
                              );
                            },
                          )),
                      Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: readyProductList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Stack(
                                  children: [
                                    Opacity(
                                      opacity: leftSelectedProduct.value?.id ==
                                          readyProductList?[index].id
                                          ? 0.25
                                          : 1,
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                23.0),
                                            border: Border.all(
                                                color: rightSelectedProduct
                                                    .value?.id ==
                                                    readyProductList?[index].id
                                                    ? Colors.yellow.shade600
                                                    : Colors.transparent,
                                                width: 2.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.5),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: Offset(
                                                    0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            color: Colors.white),
                                        height: 200,
                                        width: 150,
                                        child: Column(
                                          children: [
                                            Image.network(
                                              readyProductList?[index].image ??
                                                  '',
                                              width: 110,
                                              height: 110,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              readyProductList?[index]
                                                  .attributeData
                                                  ?.name
                                                  ?.chopar
                                                  ?.ru
                                                  ?.toUpperCase() ??
                                                  '',
                                              style: TextStyle(fontSize: 20.0),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                                formatCurrency.format(int.parse(
                                                    double.parse(
                                                        readyProductList?[index]
                                                            .price ??
                                                            '0.0000')
                                                        .toStringAsFixed(0))))
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: rightSelectedProduct.value?.id ==
                                          readyProductList?[index].id
                                          ? Icon(Icons.check_circle_outline,
                                          color: Colors.yellow.shade600)
                                          : SizedBox(width: 0.0),
                                      width: 10.0,
                                      height: 10.0,
                                      top: 20.0,
                                      right: 50.0,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  if (leftSelectedProduct.value?.id ==
                                      readyProductList?[index].id) {
                                    return;
                                  }
                                  rightSelectedProduct.value =
                                  readyProductList?[index];
                                },
                              );
                            },
                          ))
                    ],
                  ),
                )),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(leftSelectedProduct
                      .value?.attributeData?.name?.chopar?.ru
                      ?.toUpperCase() ??
                      ''),
                  Container(
                    color: Colors.grey.shade300,
                    width: 1.0,
                    height: 40.0,
                  ),
                  Text(rightSelectedProduct
                      .value?.attributeData?.name?.chopar?.ru
                      ?.toUpperCase() ??
                      ''),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: DefaultStyledButton(
                text: 'Соединить половинки',
                onPressed: () {
                  if (leftSelectedProduct.value == null ||
                      rightSelectedProduct.value == null) {
                    return;
                  }
                  isSecondPage.value = true;
                },
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: leftSelectedProduct.value == null ||
                    rightSelectedProduct.value == null
                    ? [Colors.grey.shade300, Colors.grey.shade300]
                    : null,
              ),
            )
          ],
        );
      }
    }

    useEffect(() {
      activeCustomName.value = customNames[0];
    }, [customNames]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Пицца 50/50\nСоедини 2 любимых вкуса',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: renderPage(context),
      ),
    );
  }
}