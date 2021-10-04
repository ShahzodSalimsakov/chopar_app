import 'package:chopar_app/models/modal_fit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChooseTypeDelivery extends StatefulWidget {
  const ChooseTypeDelivery({Key? key}) : super(key: key);

  @override
  _ChooseTypeDeliveryState createState() => _ChooseTypeDeliveryState();
}

class _ChooseTypeDeliveryState extends State<ChooseTypeDelivery>
    with SingleTickerProviderStateMixin {
  // int _activeWidget = 1;

  final myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: DefaultTabController(
                length: 2,
                child: TabBar(
                  tabs: myTabs,
                  controller: _tabController,
                  unselectedLabelStyle: TextStyle(backgroundColor: Colors.grey),
                ))),
        Container(
            height: 100,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Укажите адрес доставки',
                        ),
                        Icon(Icons.edit)
                      ],
                    ),
                    onPressed: () {},
                    style: TextButton.styleFrom(primary: Colors.red)),
                TextButton(
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Выберите ресторан'),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        )
                      ],
                    ),
                    style: TextButton.styleFrom(primary: Colors.red))
              ],
            )),
      ],
    );

    //   Container(
    //   padding: EdgeInsets.all(2),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.all(Radius.circular(100)),
    //     color: Colors.grey,
    //   ),
    //   child: Wrap(
    //     spacing: 5.0,
    //     children: [
    //       ElevatedButton(
    //         style: ElevatedButton.styleFrom(
    //             shape: StadiumBorder(),
    //             primary: _activeWidget != 2 ? Colors.white : Colors.grey,
    //             minimumSize: Size(182, 30)),
    //         child: Text(
    //           'Доставка',
    //           style: TextStyle(
    //               color: _activeWidget != 2 ? Colors.grey[600] : Colors.white,
    //               fontSize: 16,
    //               fontWeight: FontWeight.bold),
    //         ),
    //         onPressed: () {
    //           setState(() {
    //             _activeWidget = 1;
    //           });
    //         },
    //       ),
    //       ElevatedButton(
    //         style: ElevatedButton.styleFrom(
    //             shape: StadiumBorder(),
    //             primary: _activeWidget == 2 ? Colors.white : Colors.grey,
    //             minimumSize: Size(182, 30)),
    //         child: Text('Самовывоз',
    //             style: TextStyle(
    //                 color: _activeWidget == 2 ? Colors.grey[600] : Colors.white,
    //                 fontSize: 16,
    //                 fontWeight: FontWeight.bold)),
    //         onPressed: () {
    //           setState(() {
    //             _activeWidget = 2;
    //           });
    //         },
    //       ),
    //       Column(
    //         children: [chooseDelivery()],
    //       ),
    //     ],
    //   ),
    //   // color: Colors.grey,
    // );
  }

// Widget chooseDelivery() {
//   chooseAddress() => showMaterialModalBottomSheet(
//         expand: false,
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (context) => ModalFit(),
//       );
//   switch (_activeWidget) {
//     case 1:
//       return TextButton(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Укажите адрес доставки',
//               ),
//               Icon(Icons.edit)
//             ],
//           ),
//           onPressed: chooseAddress,
//           style: TextButton.styleFrom(primary: Colors.red));
//     case 2:
//       return TextButton(
//           onPressed: () {},
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Выберите ресторан'),
//               IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: () {},
//               )
//             ],
//           ),
//           style: TextButton.styleFrom(primary: Colors.red));
//
//     default:
//       return Text('asd');
//   }
// }
}
