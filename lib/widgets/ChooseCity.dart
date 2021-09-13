import 'package:chopar_app/modals/modal_fit.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChooseCity extends StatelessWidget {
  const ChooseCity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          'Ваш город',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: <Widget>[
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
