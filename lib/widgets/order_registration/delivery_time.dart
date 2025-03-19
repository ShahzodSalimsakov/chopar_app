import 'package:chopar_app/models/deliver_later_time.dart';
import 'package:chopar_app/models/delivery_time.dart';
import 'package:direct_select/direct_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dart_date/dart_date.dart';
import 'package:easy_localization/easy_localization.dart';

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
      return null;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 38,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  deliveryTime?.value == DeliveryTimeEnum.now
                                      ? Colors.yellow.shade700
                                      : Colors.white),
                              elevation: WidgetStateProperty.all(0),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                          color: Colors.yellow.shade700,
                                          width: 1.5))),
                            ),
                            onPressed: () {
                              DeliveryTime deliveryTime = DeliveryTime();
                              deliveryTime.value = DeliveryTimeEnum.now;
                              box.put('deliveryTime', deliveryTime);
                            },
                            child: Text(
                              tr('delivery_time_now'),
                              style: TextStyle(
                                  color: deliveryTime?.value ==
                                          DeliveryTimeEnum.now
                                      ? Colors.white
                                      : Colors.yellow.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 38,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  deliveryTime?.value == DeliveryTimeEnum.later
                                      ? Colors.yellow.shade700
                                      : Colors.white),
                              elevation: WidgetStateProperty.all(0),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                          color: Colors.yellow.shade700,
                                          width: 1.5))),
                            ),
                            onPressed: () {
                              DeliveryTime deliveryTime = DeliveryTime();
                              deliveryTime.value = DeliveryTimeEnum.later;
                              box.put('deliveryTime', deliveryTime);
                            },
                            child: Text(
                              tr('delivery_time_later'),
                              style: TextStyle(
                                  color: deliveryTime?.value ==
                                          DeliveryTimeEnum.later
                                      ? Colors.white
                                      : Colors.yellow.shade700,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                    selectedIndex: selectedTimeIndex.value,
                                    child: MySelectionItem(
                                      isForList: false,
                                      title: timeValues
                                          .value[selectedTimeIndex.value],
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
