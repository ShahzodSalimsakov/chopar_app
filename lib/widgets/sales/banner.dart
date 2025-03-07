import 'package:carousel_slider/carousel_slider.dart';
import 'package:chopar_app/models/salesBanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BannerWidget extends HookWidget {
  BannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final banner = useState<List<SalesBanner>>(List<SalesBanner>.empty());
    final _current = useState<int>(0);
    final isMounted = useValueNotifier<bool>(true);
    final controller = useState(CarouselController());

    Future<void> getSalesBanner() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https(
          'api.choparpizza.uz', '/api/sliders/public', {'locale': 'ru'});
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (isMounted.value) {
          List<SalesBanner> bannerList = List<SalesBanner>.from(
              json['data'].map((b) => SalesBanner.fromJson(b)).toList());
          banner.value = bannerList;
        }
      }
    }

    useEffect(() {
      getSalesBanner();
      return () {
        isMounted.value = false; // Set to false when widget is disposed
      };
    }, []);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1.0,
              height: 200.0,
              autoPlay: true,
              onPageChanged: (index, reason) {
                _current.value = index;
              }),
          items: banner.value.map((SalesBanner slide) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(
                            (slide.asset.length > 1 && slide.asset[1] != null
                                ? slide.asset[1].link
                                : slide.asset[0].link)),
                        fit: BoxFit.fitWidth,
                      )),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banner.value.asMap().entries.map((entry) {
            return Container(
              width: 15.0,
              height: 3.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.yellow.shade700
                      .withOpacity(_current.value == entry.key ? 0.9 : 0.4)),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
