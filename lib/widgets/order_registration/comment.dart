import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OrderCommentWidget extends HookWidget {
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Комментарий к заказу',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 20,
          ),
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
              hintText: 'Комментарий',
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onChanged: (value) {},
          )
        ]));
  }
}
