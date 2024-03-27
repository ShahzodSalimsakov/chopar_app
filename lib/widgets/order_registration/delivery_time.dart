import 'package:chopar_app/models/deliver_later_time.dart';
import 'package:chopar_app/models/delivery_time.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dart_date/dart_date.dart';

class DeliveryTimeWidget extends HookWidget {
  Widget build(BuildContext context) {
    final timeValues = useState<List<String>>(List<String>.empty());
    final selectedTimeIndex = useState<int>(0);
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
          List<Color> activeColor = [
            Colors.yellow.shade700,
            Colors.yellow.shade700
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
                                  : activeColor),
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
                                  : activeColor),
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
                              Container(
                                child: DirectSelect(
                                    itemExtent: 35.0,
                                    selectedIndex: selectedTimeIndex.value!,
                                    child: MySelectionItem(
                                      isForList: false,
                                      title: timeValues
                                          .value[selectedTimeIndex.value!],
                                    ),
                                    onSelectedItemChanged: (index) {
                                      selectedTimeIndex.value = index!;

                                      Box<DeliverLaterTime> box =
                                          Hive.box<DeliverLaterTime>(
                                              'deliveryLaterTime');
                                      box.get('deliveryLaterTime');
                                      DeliverLaterTime deliverLaterTime =
                                          new DeliverLaterTime();
                                      deliverLaterTime.value =
                                          timeValues.value[index];
                                      box.put('deliveryLaterTime',
                                          deliverLaterTime);
                                    },
                                    mode: DirectSelectMode.tap,
                                    items: timeValues.value
                                        .map((e) => MySelectionItem(
                                              title: e,
                                            ))
                                        .toList()),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.grey.shade200),
                              )
                            ]),
                          )
                  ]));
        });
  }
}

//You can use any Widget
class MySelectionItem extends StatelessWidget {
  final String? title;
  final bool isForList;

  const MySelectionItem({Key? key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Container(
              // color: Colors.grey.shade200,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(40),
      //     color: Colors.grey.shade200
      // ),
      alignment: Alignment.center,
      child: FittedBox(
          child: Text(
        title!,
      )),
    );
  }
}
