import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${tr('version')}: ${snapshot.data!.version}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
