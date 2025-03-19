import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  Widget _buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            tr('language_select'),
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text(tr('language_russian')),
            onTap: () {
              context.setLocale(Locale('ru'));
              Navigator.of(context).pop();
            },
            trailing: context.locale.toString() == 'ru'
                ? Icon(Icons.check, color: Colors.green)
                : null,
          ),
          ListTile(
            title: Text(tr('language_uzbek')),
            onTap: () {
              context.setLocale(Locale('uz'));
              Navigator.of(context).pop();
            },
            trailing: context.locale.toString() == 'uz'
                ? Icon(Icons.check, color: Colors.green)
                : null,
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(tr('language_cancel')),
          ),
        ],
      ),
    );
  }
}
