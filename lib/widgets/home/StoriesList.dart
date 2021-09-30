import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_stories/flutter_stories.dart';

class StoriesList extends StatelessWidget {
  const StoriesList({Key? key}) : super(key: key);

  final _momentCount = 5;
  final _momentDuration = const Duration(seconds: 5);

  @override
  Widget build(BuildContext context) {
    final images = List.generate(
      _momentCount,
      (idx) => Image.asset('assets/images/${idx + 1}.jpg'),
    );
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.only(left: 6),
                  child: InkWell(
                    onTap: () {
                      // showCupertinoDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return CupertinoPageScaffold(
                      //         child: Stack(
                      //       children: [
                      //         Story(
                      //           onFlashForward: Navigator.of(context).pop,
                      //           onFlashBack: Navigator.of(context).pop,
                      //           momentCount: 5,
                      //           momentDurationGetter: (idx) => _momentDuration,
                      //           momentBuilder: (context, idx) => images[idx],
                      //         ),
                      //         Positioned(
                      //             left: 0,
                      //             right: 0,
                      //             bottom: 0,
                      //             child: Container(
                      //               padding: EdgeInsets.only(
                      //                   left: 50, right: 50),
                      //               margin: EdgeInsets.only(bottom: 10),
                      //               child: Text(
                      //                 'Assalom pepironni '
                      //                 'Комбо-сеты на двоих от 40 000 сумов',
                      //                 style: TextStyle(
                      //                     color: Colors.white, fontSize: 20),
                      //               ),
                      //             ))
                      //       ],
                      //     ));
                      //   },
                      // );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.asset('assets/images/pizza.png'),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            child: Container(
                              padding:
                                  EdgeInsets.only(top: 70, left: 5, right: 5),
                              child: Text(
                                'Комбо-сеты на двоих от 40 000 сумов',
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                      ],
                    ),
                  ));
            }));
  }
}
