import 'package:chopar_app/app.dart';
import 'package:chopar_app/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:chopar_app/pages/home.dart';

import 'authentication_repository.dart';

void main() => runApp(
    // App(
    //   authenticationRepository: AuthenticationRepository(),
    //   userRepository: UserRepository(),
    // )

        MaterialApp(
          theme: ThemeData(primaryColor: Colors.white, fontFamily: 'Ubuntu'),
          home: Home(),
          debugShowCheckedModeBanner: false,
        ),
        );
