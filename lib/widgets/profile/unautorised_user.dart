import 'package:chopar_app/widgets/auth/modal.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class UnAuthorisedUserPage extends StatelessWidget {
  final String? title;

  const UnAuthorisedUserPage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title ?? tr('nav_profile')),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 150,
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                tr('hello'),
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                tr('to_login_enter_phone_number'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey),
              ),
              SizedBox(
                height: 30,
              ),
              DefaultStyledButton(
                  width: MediaQuery.of(context).size.width * 0.75,
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthModal(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  text: tr('to_login_enter_phone_number'))
            ],
          ),
        ),
      ),
    );
  }
}
