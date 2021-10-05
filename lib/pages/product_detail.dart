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

  @override
  Widget build(BuildContext context) {
    final selectedVariant = useState<String>('');
    print(detail);
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
                child: ListView(
                  children: [
                    Image.network(
                      detail.image,
                      width: 345.0,
                      height: 345.0,
                      // width: MediaQuery.of(context).size.width / 2.5,
                    ),
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
                    Row(
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
                    SizedBox(height: 30),
                    Text(
                      'Добавить в пиццу',
                      style: TextStyle(
                          color: Colors.yellow.shade600, fontSize: 16),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      child: Text('asdasd'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow.shade600),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0))),
                      ),
                      onPressed: () {},
                    )
                  ],
                ))));
  }
}
