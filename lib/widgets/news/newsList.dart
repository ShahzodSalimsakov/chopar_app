import 'package:chopar_app/models/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NewsList extends HookWidget {
  Widget modifierImage(News s) {
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SvgPicture.network(
              'https://choparpizza.uz/no_photo.svg',
              fit: BoxFit.cover,
              width: 150.0,
              height: 73.0,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final news = useState<List<News>>(List<News>.empty());

    Future<void> getNews() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url =
          Uri.https('api.choparpizza.uz', '/api/news/public', {'city_id': '7'});
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<News> newsList = List<News>.from(
            json['data'].map((s) => new News.fromJson(s)).toList());
        news.value = newsList;
      }
    }

    useEffect(() {
      getNews();
    }, []);

    return /*Expanded(
        child:*/ ListView.separated(
      itemCount: news.value.length,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
            onTap: () {
              showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Material(
                          child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        height: MediaQuery.of(context).size.height * 0.90,
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                news.value[index].name,
                                style: TextStyle(fontSize: 22),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              // Text(
                              //   '12 август 2021',
                              //   style:
                              //       TextStyle(fontSize: 10, color: Colors.grey),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                news.value[index].description,
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      )));
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: modifierImage(news.value[index])),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.value[index].name,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // Text(
                        //   '12 август 2021',
                        //   style: TextStyle(fontSize: 10, color: Colors.grey),
                        // ),
                      ],
                    ),
                  ),
                ]));
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    )/*)*/;
  }
}
