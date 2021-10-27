import 'dart:convert';
import 'package:chopar_app/models/city.dart';
import 'package:chopar_app/models/terminals.dart';
import 'package:chopar_app/widgets/delivery/control_button.dart';
import 'package:chopar_app/widgets/delivery/terminals_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:yandex_mapkit/yandex_mapkit.dart';

class Pickup extends HookWidget {
  late YandexMapController controller;
  late YandexMap map;


  @override
  Widget build(BuildContext context) {
    final terminals = useState<List<Terminals>>(List<Terminals>.empty());
    City? currentCity = Hive.box<City>('currentCity').get('currentCity');

    Future<void> getTerminals() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https('api.choparpizza.uz', 'api/terminals/pickup',
          {'city_id': currentCity?.id.toString()});
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

    return ValueListenableBuilder<Box<Terminals>>(
        valueListenable: Hive.box<Terminals>('currentTerminal').listenable(),
        builder: (context, box, _) {
          Terminals? currentTerminal =
              Hive.box<Terminals>('currentTerminal').get('currentTerminal');
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
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              width: 1.0,
                                              color: Colors.yellow.shade600)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      25.0)))),
                                  child: Text(
                                    'Списком',
                                    style: TextStyle(
                                        color: Colors.yellow.shade600),
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
                                            builder: (context) => TerminalsModal(terminals: terminals.value)));
                                  },
                                  style: ButtonStyle(
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              width: 1.0, color: Colors.grey)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      25.0)))),
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
                              var terminal = terminals.value[index];
                              return InkWell(
                                  onTap: () {
                                    Box<Terminals> transaction =
                                        Hive.box<Terminals>('currentTerminal');
                                    transaction.put(
                                        'currentTerminal', terminal);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: currentTerminal?.id ==
                                                    terminal.id
                                                ? Colors.yellow.shade600
                                                : Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: currentTerminal
                                                                    ?.id ==
                                                                terminal.id
                                                            ? Colors
                                                                .yellow.shade600
                                                            : Colors.grey,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        color: currentTerminal
                                                                    ?.id ==
                                                                terminal.id
                                                            ? Colors
                                                                .yellow.shade600
                                                            : Colors.grey),
                                                    margin: EdgeInsets.all(3),
                                                    width: 10,
                                                    height: 10),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    terminals.value[index]
                                                            .name ??
                                                        '',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          terminals.value[index]
                                                                  .desc ??
                                                              '',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          overflow:
                                                              TextOverflow.clip,
                                                          softWrap: false,
                                                        )),
                                                      ],
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      )));
                            }),
                      ))
                    ],
                  )));
        });
  }
}
