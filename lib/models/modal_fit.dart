import 'package:flutter/material.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              ListTile(
                title: Text('Ташкент'),
                onTap: () => Navigator.of(context).pop(),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: Colors.grey,
                height: 1,
              ),
              ListTile(
                title: Text('Самарканд'),
                onTap: () => Navigator.of(context).pop(),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: Colors.grey,
                height: 1,
              ),
              ListTile(
                title: Text('Фергана'),
                onTap: () => Navigator.of(context).pop(),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: Colors.grey,
                height: 1,
              ),
              ListTile(
                title: Text('Андижан'),
                onTap: () => Navigator.of(context).pop(),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: Colors.grey,
                height: 1,
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
