import 'package:chopar_app/models/product_section.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductDetail extends HookWidget {
  const ProductDetail({Key? key, required this.detail}) : super(key: key);

  final detail;

  Widget makeDismisible(
          {required BuildContext context, required Widget child}) =>
      GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: GestureDetector(onTap: () {}, child: child));

  List<Widget> modifiersList() {
    if (detail.variants.length > 0) {
      return [
        SizedBox(height: 30.0),
        Text(
          'Добавить в пиццу',
          style: TextStyle(color: Colors.yellow.shade600, fontSize: 16.0),
        ),
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
    final selectedVariant = useState<String>('');

    final modifiers = useMemoized(() {
      List<Modifiers> modifier = List<Modifiers>.empty();
      if (detail.variants != null && detail.variants.length > 0) {
        Variants activeValue = detail.variants
            .firstWhere((item) => item.customName = selectedVariant);
        if (activeValue != null && activeValue.modifiers != null) {
          modifier = activeValue.modifiers!;
          if (activeValue.modifierProduct != null) {
            Modifiers? isExistSausage = modifier.firstWhere(
                (mod) => mod.id == activeValue.modifierProduct?.id,
                orElse: () => null as Modifiers);
            if (isExistSausage != null) {
              modifier.add(new Modifiers(
                  id: activeValue.modifierProduct?.id ?? 0,
                  createdAt: '',
                  updatedAt: '',
                  name: 'Сосисочный борт',
                  xmlId: '',
                  price: int.parse(activeValue.modifierProduct?.price ?? '0') -
                      int.parse(activeValue.price),
                  weight: 0,
                  groupId: '',
                  nameUz: 'Sosiskali tomoni'));
            }
          }
        }
      } else {
        if (detail.modifiers != null) {
          modifier = detail.modifiers;
        }
      }

      if (modifier.isNotEmpty) {
        modifier.sort((a, b) => a.price.compareTo(b.price));
      }

      return modifier;
    }, [detail]);

    return makeDismisible(
        context: context,
        child: DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 1,
            builder: (_, controller) => Container(
                padding:
                    EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Image.network(
                      detail.image,
                      width: 345.0,
                      height: 345.0,
                      // width: MediaQuery.of(context).size.width / 2.5,
                    )),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      detail.attributeData?.name?.chopar?.ru ?? '',
                      style: TextStyle(fontSize: 26),
                    ),
                    Html(
                      data: detail.attributeData?.description?.chopar?.ru ?? '',
                      // style: TextStyle(
                      //     fontSize: 11.0, fontWeight: FontWeight.w400, height: 2),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List<Widget>.generate(detail.variants.length,
                            (index) {
                          return ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0))),
                                  backgroundColor: MaterialStateProperty.all(
                                      selectedVariant.value ==
                                              detail.variants[index].customName
                                          ? Colors.yellow.shade600
                                          : Colors.white)),
                              child: Text(detail.variants[index].customName,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: selectedVariant.value ==
                                              detail.variants[index].customName
                                          ? Colors.white
                                          : Colors.grey)),
                              onPressed: () {
                                selectedVariant.value =
                                    detail.variants[index].customName;
                              });
                        }),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    ...modifiersList(),
                    Expanded(child: Container()),
                    DefaultStyledButton(
                        width: MediaQuery.of(context).size.width,
                        onPressed: () {},
                        text: 'davr'),
                  ],
                ))));
  }
}
