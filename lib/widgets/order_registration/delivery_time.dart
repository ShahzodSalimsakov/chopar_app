import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DeliveryTime extends StatefulWidget {
  const DeliveryTime({Key? key}) : super(key: key);

  @override
  State<DeliveryTime> createState() => _DeliveryTimeState();
}

class _DeliveryTimeState extends State<DeliveryTime> {
  String _time = "Укажите время";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          Row(children: [
            Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow.shade600)),
                    child: Text('Побыстрее',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                    onPressed: () {})),
            SizedBox(
              width: 15,
            ),
            Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade200)),
                    child: Text('Позже',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w700)),
                    onPressed: () {})),
          ]),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.shade200)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(_time,
                    style:
                        TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                Icon(
                  Icons.arrow_drop_down_outlined,
                  color: Colors.grey,
                )
              ],
            ),
            onPressed: () {
              DatePicker.showTimePicker(context, showTitleActions: true,
                  onConfirm: (time) {
                _time = '${time.hour} : ${time.minute}';
                setState(() {});
              }, currentTime: DateTime.now(), locale: LocaleType.ru);
            },
          )
        ],
      ),
    );
  }
}
