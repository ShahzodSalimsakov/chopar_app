import 'dart:convert';
import 'package:chopar_app/models/terminals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Pickup extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final terminals = useState<List<Terminals>>(List<Terminals>.empty());

    Future<void> getTerminals() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.hq.fungeek.net', 'api/terminals/pickup');
      var response = await http.get(url, headers: requestHeaders);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Terminals> terminal = List<Terminals>.from(
            json['data'].map((m) => new Terminals.fromJson(m)).toList());
        terminals.value = terminal;
      }
    }

    useEffect(() {
      getTerminals();
    }, []);

    print(terminals.value);
    return SafeArea(
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    width: 1.0, color: Colors.yellow.shade600)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)))),
                            child: Text(
                              'Списком',
                              style: TextStyle(color: Colors.yellow.shade600),
                            ))),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                          appBar: AppBar(
                                              title: const Text(
                                                  'YandexMap examples')),
                                          body: Column(children: <Widget>[
                                            Expanded(
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: const YandexMap())),
                                            // Expanded(
                                            //     child: ListView.builder(
                                            //       itemCount: _allPages.length,
                                            //       itemBuilder: (_, int index) => ListTile(
                                            //         title: Text(_allPages[index].title),
                                            //         onTap: () => _pushPage(context, _allPages[index]),
                                            //       ),
                                            //     )
                                            // )
                                          ]))));
                            },
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    BorderSide(width: 1.0, color: Colors.grey)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)))),
                            child: Text(
                              'На карте',
                              style: TextStyle(color: Colors.grey),
                            )))
                  ],
                ),
                Expanded(
                    child: Container(
                  child: ListView.builder(
                      itemCount: terminals.value.length,
                      itemBuilder: (context, index) {
                        return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      terminals.value[index].name ?? '',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text(terminals.value[index].desc ?? '',
                                    style: TextStyle(fontSize: 14))
                              ],
                            ));
                      }),
                ))
              ],
            )));
  }
}
