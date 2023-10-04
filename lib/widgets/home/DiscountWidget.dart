import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;

class DiscountWidget extends HookWidget {
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
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        if (isMounted.value) {
          configData.value = jsonDecode(stringToBase64.decode(json['data']));
        }
      } else {
        print('Error fetching config: ${response.statusCode}');
      }
    }

    var discountValue = useMemoized(() {
      var res = 0;
      if (configData.value != null) {
        if (configData.value?["discount_end_date"] != null) {
          if (DateTime.now().weekday.toString() !=
              configData.value?["discount_disable_day"]) {
            if (DateTime.now().isBefore(
                DateTime.parse(configData.value?["discount_end_date"]))) {
              if (configData.value?["discount_value"] != null) {
                res = int.parse(configData.value?["discount_value"]);
              }
            }
          }
        }
      }

      return res;
    }, [configData.value]);

    useEffect(() {
      fetchConfig();
      return () {
        isMounted.value = false; // Set to false when widget is disposed
      };
    }, []);

    return Container(
        child: discountValue > 0
            ? Image.asset('assets/images/sale.png', height: 35, width: 30)
            : SizedBox());
  }
}
