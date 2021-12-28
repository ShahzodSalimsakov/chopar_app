import 'package:chopar_app/models/additional_phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';

class AdditionalPhoneNumberWidget extends HookWidget {
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Дополнительный номер телефона',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(23),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: 'Введите номер',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
              keyboardType: TextInputType.number,
            onChanged: (value) {
              AdditionalPhoneNumber additionalPhone = new AdditionalPhoneNumber();
              additionalPhone.additionalPhoneNumber = value;
              Hive.box<AdditionalPhoneNumber>('additionalPhoneNumber').put('additionalPhoneNumber', additionalPhone);
            },
            scrollPadding: EdgeInsets.all(200),
          )
        ]));
  }
}
