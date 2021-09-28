import 'package:chopar_app/models/modal_fit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChooseCity extends StatelessWidget {
  const ChooseCity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ваш город',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
        onTap: () => showMaterialModalBottomSheet(
              expand: false,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => ModalFit(),
            ));
  }
}
