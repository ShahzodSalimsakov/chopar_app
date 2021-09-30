import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AuthModal extends StatefulWidget {
  const AuthModal({Key? key}) : super(key: key);

  @override
  _AuthModalState createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'UZ';
  PhoneNumber number = PhoneNumber(isoCode: 'UZ');
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.00,
      ),
      body: Form(
        key: formKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.0),
              Row(
                children: [
                  Text(
                    'Укажите Ваш номер',
                    style: TextStyle(fontSize: 26.0),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Row(
                children: [
                  Text('чтобы быстро оформлять заказы и получать бонусы')
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(height: 35.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(23.0),
                  border: Border.all(width: 1.0, color: Colors.grey),
                ),
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print('valid: ${value}');
                      setState(() {
                        _isValid = value;
                      });
                    },
                    countries: ['UZ'],
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      showFlags: false,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle:
                        TextStyle(color: Colors.black, fontSize: 24.0),
                    initialValue: number,
                    textFieldController: controller,
                    formatInput: true,
                    countrySelectorScrollControlled: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: InputBorder.none,
                    spaceBetweenSelectorAndTextField: 0,
                    textStyle: TextStyle(color: Colors.black, fontSize: 24.0),
                    // inputDecoration: InputDecoration(border: ),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [
                      Colors.deepPurple.shade400,
                      Colors.deepPurple.shade200,
                    ],
                  ),
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    print(formKey.currentState);
                  },
                  child: Text('Получить код'),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0))),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
