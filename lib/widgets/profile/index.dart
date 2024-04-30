import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/services/user_repository.dart';
import 'package:chopar_app/widgets/home/ChooseCity.dart';
import 'package:chopar_app/widgets/profile/PagesList.dart';
import 'package:chopar_app/widgets/profile/UserName.dart';
import 'package:chopar_app/widgets/profile/unautorised_user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileIndex extends StatelessWidget {
  final userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<User>>(valueListenable: Hive.box<User>('user').listenable(), builder: (context, box, _) {
      bool isUserAuthorized = UserRepository().isAuthorized();
      if (isUserAuthorized) {
        return Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: [
              ChooseCity(),
              UserName(),
              PagesList()
            ],
          ),
        );
      } else {
        return UnAuthorisedUserPage();
      }
    });

  }
}
