import 'package:chopar_app/models/delivery_time.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dart_date/dart_date.dart';

class DeliveryTimeWidget extends HookWidget {
  Widget build(BuildContext context) {
    final timeValues = useState<List<String>>(List<String>.empty());
    useEffect(() {
      Box<DeliveryTime> box = Hive.box<DeliveryTime>('deliveryTime');
      DeliveryTime? deliveryTime = box.get('deliveryTime');
      if (deliveryTime == null) {
        DeliveryTime newDeliveryTime = new DeliveryTime();
        newDeliveryTime.value = DeliveryTimeEnum.now;
        box.put('deliveryTime', newDeliveryTime);
      }

      List<String> deliveryTimeOptions = [];
      var startTime = DateTime.now();

      startTime = startTime.add(Duration(minutes: 40));
      startTime = startTime.setMinute((startTime.minute / 10).ceil() * 10);
      // startTime.minute = (startTime.minute / 10).ceil() * 10;
      // startTime = startTime.set({
      //   minute: Math.ceil(startTime.minute / 10) * 10,
      // })
      var val = '';
      while (startTime.hour < 3 || startTime.hour > 10) {
        val = '${startTime.format('Hm').toString()}';
        startTime = startTime.add(Duration(minutes: 20));
        startTime = startTime.setMinute((startTime.minute / 10).ceil() * 10);

        val = val + ' - ${startTime.format('Hm').toString()}';
        deliveryTimeOptions.add(val);

        startTime = startTime.add(Duration(minutes: 40));
        startTime = startTime.setMinute((startTime.minute / 10).ceil() * 10);
      }
      print(deliveryTimeOptions);
      timeValues.value = deliveryTimeOptions;
    }, []);

    return ValueListenableBuilder<Box<DeliveryTime>>(
        valueListenable: Hive.box<DeliveryTime>('deliveryTime').listenable(),
        builder: (context, box, _) {
          DeliveryTime? deliveryTime = box.get('deliveryTime');
          List<Color> disabledColors = [
            Colors.grey.shade200,
            Colors.grey.shade200
          ];
          return Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Когда доставить',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 38,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: DefaultStyledButton(
                              color: (deliveryTime == null ||
                                      deliveryTime.value != DeliveryTimeEnum.now
                                  ? disabledColors
                                  : null),
                              textSize: 16,
                              textColor: (deliveryTime == null ||
                                      deliveryTime.value != DeliveryTimeEnum.now
                                  ? Colors.grey.shade700
                                  : null),
                              width: MediaQuery.of(context).size.width,
                              text: 'Побыстрее',
                              onPressed: () {
                                DeliveryTime newDeliveryTime =
                                    new DeliveryTime();
                                newDeliveryTime.value = DeliveryTimeEnum.now;
                                Box<DeliveryTime> box =
                                    Hive.box<DeliveryTime>('deliveryTime');
                                box.put('deliveryTime', newDeliveryTime);
                              },
                            ),
                          ),
                          Container(
                            height: 38,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: DefaultStyledButton(
                              color: (deliveryTime == null ||
                                      deliveryTime.value !=
                                          DeliveryTimeEnum.later
                                  ? disabledColors
                                  : null),
                              textSize: 16,
                              textColor: (deliveryTime == null ||
                                      deliveryTime.value !=
                                          DeliveryTimeEnum.later
                                  ? Colors.grey.shade700
                                  : null),
                              width: MediaQuery.of(context).size.width,
                              text: 'Позже',
                              onPressed: () {
                                DeliveryTime newDeliveryTime =
                                    new DeliveryTime();
                                newDeliveryTime.value = DeliveryTimeEnum.later;
                                Box<DeliveryTime> box =
                                    Hive.box<DeliveryTime>('deliveryTime');
                                box.put('deliveryTime', newDeliveryTime);
                              },
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 15,
                    ),
                    deliveryTime == null ||
                            deliveryTime.value != DeliveryTimeEnum.later
                        ? SizedBox(
                            height: 1,
                          )
                        : Form(
                            child: Column(children: [
                              FormBuilderDropdown<String>(
                                name: 'deliveryTime',
                                hint: Text('Укажите время'),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide(
                                            width: 0,
                                            color: Colors.grey.shade200)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15)),
                                items: timeValues.value
                                    .map((time) => DropdownMenuItem(
                                          value: time,
                                          child: Text('$time'),
                                        ))
                                    .toList(),
                              )
                            ]),
                          )
                  ]));
        });
  }
}

// class DeliveryTime extends StatefulWidget {
//   const DeliveryTime({Key? key}) : super(key: key);
//
//   @override
//   State<DeliveryTime> createState() => _DeliveryTimeState();
// }
//
// class _DeliveryTimeState extends State<DeliveryTime> {
//   String _time = "Укажите время";
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       width: double.infinity,
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Когда доставить',
//             style: TextStyle(fontSize: 18),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Row(children: [
//             Expanded(
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                         shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25.0))),
//                         backgroundColor:
//                             MaterialStateProperty.all(Colors.yellow.shade600)),
//                     child: Text('Побыстрее',
//                         style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700)),
//                     onPressed: () {})),
//             SizedBox(
//               width: 15,
//             ),
//             Expanded(
//                 child: ElevatedButton(
//                     style: ButtonStyle(
//                         shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25.0))),
//                         backgroundColor:
//                             MaterialStateProperty.all(Colors.grey.shade200)),
//                     child: Text('Позже',
//                         style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.grey.shade700,
//                             fontWeight: FontWeight.w700)),
//                     onPressed: () {})),
//           ]),
//           ElevatedButton(
//             style: ButtonStyle(
//                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25.0))),
//                 backgroundColor:
//                     MaterialStateProperty.all(Colors.grey.shade200)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   width: 30,
//                 ),
//                 Text(_time,
//                     style:
//                         TextStyle(fontSize: 16, color: Colors.grey.shade700)),
//                 Icon(
//                   Icons.arrow_drop_down_outlined,
//                   color: Colors.grey,
//                 )
//               ],
//             ),
//             onPressed: () {
//               DatePicker.showTimePicker(context, showTitleActions: true,
//                   onConfirm: (time) {
//                 _time = '${time.hour} : ${time.minute}';
//                 setState(() {});
//               }, currentTime: DateTime.now(), locale: LocaleType.ru);
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
