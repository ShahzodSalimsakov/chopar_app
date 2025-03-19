import 'package:chopar_app/pages/about_us.dart';
import 'package:chopar_app/pages/orders.dart';
import 'package:chopar_app/pages/personal_data.dart';
import 'package:chopar_app/services/app_update_service.dart';
import 'package:chopar_app/widgets/profile/LanguageSwitcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class PagesList extends StatelessWidget {
  const PagesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppUpdateService _appUpdateService = AppUpdateService();

    return Expanded(
        // wrap in Expanded
        child: ListView(
      shrinkWrap: true,
      children: [
        // ListTile(
        //   contentPadding: EdgeInsets.all(0.00),
        //   leading: Icon(Icons.map),
        //   title: Text('Бонусы'),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => Bonuses(),
        //       ),
        //     );
        //   },
        // ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          // leading: FaIcon(FontAwesomeIcons.shoppingBasket),
          leading: Icon(Icons.shopping_basket_outlined),
          title: Text(tr('my_orders')),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrdersPage(),
              ),
            );
          },
        ),
        // ListTile(
        //   contentPadding: EdgeInsets.all(0.00),
        //   leading: Icon(Icons.map),
        //   title: Text('Мои адреса'),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        // ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.person_outline),
          title: Text(tr('personal_data')),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalDataPage(),
              ),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.language),
          title: Text(tr('language_app')),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => LanguageSwitcher(),
            );
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0.00),
          leading: Icon(Icons.info_outline),
          title: Text(tr('about_us')),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutUs(),
              ),
            );
          },
        ),
        // Only show update button on Android
        if (Theme.of(context).platform == TargetPlatform.android)
          ListTile(
            contentPadding: EdgeInsets.all(0.00),
            leading: Icon(Icons.system_update),
            title: Text(tr('check_updates')),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              // Check if flexible update is available
              final updateInfo = await _appUpdateService.checkForUpdateInfo();

              if (updateInfo != null &&
                  updateInfo.updateAvailability ==
                      UpdateAvailability.updateAvailable) {
                if (updateInfo.flexibleUpdateAllowed) {
                  _appUpdateService.startFlexibleUpdate(context);
                } else if (updateInfo.immediateUpdateAllowed) {
                  _appUpdateService.performImmediateUpdate();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr('no_updates')),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr('no_updates')),
                  ),
                );
              }
            },
          ),
        // ListTile(
        //   contentPadding: EdgeInsets.all(0.00),
        //   leading: Icon(Icons.info_outline),
        //   title: Text('Оформление заказа'),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => OrderRegistration(),
        //       ),
        //     );
        //   },
        // ),
      ],
    ));
  }
}
