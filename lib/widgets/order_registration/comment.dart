import 'package:chopar_app/models/delivery_notes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';

class OrderCommentWidget extends HookWidget {
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(top: 20, bottom: 60, right: 20, left: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextField(
            maxLines: 4,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(23),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: tr('comment'),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onChanged: (value) {
              DeliveryNotes deliveryNotes = new DeliveryNotes();
              deliveryNotes.deliveryNotes = value;
              Hive.box<DeliveryNotes>('deliveryNotes')
                  .put('deliveryNotes', deliveryNotes);
            },
            scrollPadding: EdgeInsets.only(bottom: 200),
          )
        ]));
  }
}
