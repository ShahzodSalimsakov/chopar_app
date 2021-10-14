import 'package:chopar_app/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class SalesList extends HookWidget {
  Widget modifierImage(Sales s) {
    if (s.asset != null && s.asset!.isNotEmpty) {
      return Container(
        width: 150,
        height: 86,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(s.asset.link),
              fit: BoxFit.cover,
            )),
      );
    } else {
      return Container(
        width: 150,
        height: 86,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)),
        child: SvgPicture.network(
          'https://choparpizza.uz/no_photo.svg',
          width: 150.0,
          height: 73.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sales = useState<List<Sales>>(List<Sales>.empty());

    Future<void> getSales() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https(
          'api.hq.fungeek.net', '/api/sales/public', {'city_id': '7'});
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Sales> salesList = List<Sales>.from(
            json['data'].map((s) => new Sales.fromJson(s)).toList());
        sales.value = salesList;
      }
    }

    useEffect(() {
      getSales();
    }, []);

    return Expanded(
        child: ListView.separated(
      itemCount: sales.value.length,
      itemBuilder: (BuildContext context, index) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              modifierImage(sales.value[index]),
              Container(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sales.value[index].name,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    ));
  }
}
