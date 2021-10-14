import 'dart:convert';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'package:timer_count_down/timer_count_down.dart';

class AuthModal extends HookWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  final TextEditingController nameFieldController = TextEditingController();
  final initialCountry = 'UZ';
  final number = PhoneNumber(isoCode: 'UZ');

  @override
  Widget build(BuildContext context) {
    final _isValid = useState<bool>(false);
    final _isVerifyPage = useState<bool>(false);
    final _isSendingPhone = useState<bool>(false);
    final _isShowNameField = useState<bool>(false);
    final phoneNumber = useState<String>('');
    final otpCode = useState<String>('');
    final otpToken = useState<String>('');
    final _isFinishedTimer = useState<bool>(false);

    Future<void> trySignIn() async {
      _isSendingPhone.value = true;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${otpToken.value}'
      };
      var url = Uri.https('api.hq.fungeek.net', '/api/auth_otp');
      var formData = {'phone': phoneNumber.value, 'code': otpCode.value};
      var response = await http.post(url,
          headers: requestHeaders, body: jsonEncode(formData));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print(json);
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String decoded = stringToBase64.decode(json['result']);
        print(jsonDecode(decoded));
        if (jsonDecode(decoded) == false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Введённый код неверный или срок кода истёк')));
        } else {
          var result = jsonDecode(decoded);
          User authorizedUser = User.fromJson(result['user']);
          Box<User> transaction = Hive.box<User>('user');
          transaction.put('user', authorizedUser);
          Navigator.of(context).pop();
        }
      }
      _isSendingPhone.value = false;
    }

    Future<void> tryResendCode() async {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      };
      var url = Uri.https(
          'api.hq.fungeek.net', '/api/send_otp');
      var formData = {'phone': phoneNumber.value};
      if (_isShowNameField.value) {
        formData['name'] = nameFieldController.text;
      }
      var response = await http.post(url,
          headers: requestHeaders,
          body: jsonEncode(formData));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success'] != null) {
          Codec<String, String> stringToBase64 =
          utf8.fuse(base64);
          String decoded =
          stringToBase64.decode(json['success']);
          otpToken.value =
          jsonDecode(decoded)['user_token'];
        }
        _isFinishedTimer.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.00,
      ),
      body: _isVerifyPage.value
          ? Form(
              key: otpFormKey,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Text(
                          'Отправили код на номер',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          phoneNumber.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 26),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: OtpTextField(
                        numberOfFields: 4,
                        fieldWidth:
                            ((MediaQuery.of(context).size.width - 30) / 4) - 10,
                        autoFocus: true,
                        borderColor: Color(0xFF512DA8),
                        //set to true to show as box or false to show as dash
                        // showFieldAsBox: true,
                        hasCustomInputDecoration: true,

                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40)),
                            counterStyle: TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: ""),
                        //runs when a code is typed in
                        // onCodeChanged: (String code) {
                        //   print(code);
                        //   otpCode.value = code;
                        // },
                        onSubmit: (String code) {
                          otpCode.value = code;
                          trySignIn();
                        },
                      ),
                    ),
                    Spacer(),
                    _isFinishedTimer.value
                        ? Container(
                            child: InkWell(
                              child: Text(
                                'Получить новый код',
                                style: TextStyle(
                                    color: Colors.yellow.shade600,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: (){
                                tryResendCode();
                              },
                            ),
                          )
                        : Container(
                            child: Countdown(
                              // controller: _controller,
                              seconds: 60,
                              build: (_, double time) => Row(
                                children: [
                                  Text(
                                    'Код не пришел\n получить новый код через ${time.ceil().toString()} сек.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              interval: Duration(milliseconds: 1000),
                              onFinished: () {
                                _isFinishedTimer.value = true;
                              },
                            ),
                          ),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 20.0),
                        child: DefaultStyledButton(
                          width: MediaQuery.of(context).size.width,
                          isLoading: _isSendingPhone.value == true
                              ? _isSendingPhone.value
                              : null,
                          onPressed: () async {
                            if (_isSendingPhone.value) {
                              return;
                            }
                            if (otpCode.value.length == 4) {
                              trySignIn();
                            }
                          },
                          text: 'Войти',
                        ))
                  ],
                ),
              ),
            )
          : Form(
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'чтобы быстро оформлять заказы\n и получать бонусы',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(height: 35.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(width: 1.0, color: Colors.grey),
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            phoneNumber.value = number.phoneNumber ?? '';
                          },
                          onInputValidated: (bool value) {
                            _isValid.value = value;
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
                          hintText: '',
                          errorMessage: 'Неверный номер',
                          spaceBetweenSelectorAndTextField: 0,
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 24.0),
                          // inputDecoration: InputDecoration(border: ),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),
                    ),
                    _isShowNameField.value
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 20),
                            child: TextFormField(
                              controller: nameFieldController,
                              validator: (String? val) {
                                if (val == null || val.isEmpty) {
                                  return 'Укажите своё имя';
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'Ваше имя',
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.yellow.shade600),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.yellow.shade600)),
                                  contentPadding: EdgeInsets.only(left: 40),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40))),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                            ),
                          )
                        : SizedBox(),
                    Spacer(),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20.0),
                      child: DefaultStyledButton(
                        width: MediaQuery.of(context).size.width,
                        isLoading: _isSendingPhone.value == true ? true : null,
                        text: 'Получить код',
                        onPressed: () async {
                          if (_isSendingPhone.value) {
                            return;
                          }
                          if (formKey.currentState != null &&
                              formKey.currentState!.validate()) {
                            _isSendingPhone.value = true;
                            Map<String, String> requestHeaders = {
                              'Content-type': 'application/json',
                              'Accept': 'application/json'
                            };
                            var url =
                                Uri.https('api.hq.fungeek.net', '/api/keldi');
                            var response =
                                await http.get(url, headers: requestHeaders);
                            if (response.statusCode == 200) {
                              var json = jsonDecode(response.body);
                              Codec<String, String> stringToBase64 =
                                  utf8.fuse(base64);
                              String decoded =
                                  stringToBase64.decode(json['result']);

                              Map<String, String> requestHeaders = {
                                'Content-type': 'application/json',
                                'Accept': 'application/json'
                              };
                              url = Uri.https(
                                  'api.hq.fungeek.net', '/api/send_otp');
                              var formData = {'phone': phoneNumber.value};
                              if (_isShowNameField.value) {
                                formData['name'] = nameFieldController.text;
                              }
                              response = await http.post(url,
                                  headers: requestHeaders,
                                  body: jsonEncode(formData));
                              if (response.statusCode == 200) {
                                json = jsonDecode(response.body);
                                print(json);
                                if (json['error'] != null) {
                                  if (json['error'] ==
                                      'name_field_is_required') {
                                    _isShowNameField.value = true;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Мы Вас не нашли в нашей системе. Просьба указать своё имя.')));
                                  }
                                } else if (json['success'] != null) {
                                  Codec<String, String> stringToBase64 =
                                      utf8.fuse(base64);
                                  String decoded =
                                      stringToBase64.decode(json['success']);
                                  otpToken.value =
                                      jsonDecode(decoded)['user_token'];
                                  print(otpToken.value);
                                  _isVerifyPage.value = true;
                                }
                              }
                            }
                            _isSendingPhone.value = false;
                          }
                        },
                        color:
                            !_isValid.value ? [Colors.grey, Colors.grey] : null,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
