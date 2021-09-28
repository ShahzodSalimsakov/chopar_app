import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              'Выберите город',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Ташкент'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Самарканд'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Фергана'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Андижан'),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: Text('Коканд'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ));
  }
}
