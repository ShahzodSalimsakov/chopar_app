import 'dart:convert';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hex/hex.dart';
import 'package:hive/hive.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:http/http.dart' as http;
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../utils/random.dart';

class AuthModal extends HookWidget {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  // final TextEditingController controller = TextEditingController();
  final TextEditingController nameFieldController = TextEditingController();
  final initialCountry = 'UZ';
  final number = PhoneNumber(isoCode: 'UZ');
  OTPTextEditController? controller;
  late OTPInteractor _otpInteractor;

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
    final _gender = useState(1);

    Future<void> trySignIn() async {
      _isSendingPhone.value = true;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${otpToken.value}'
      };
      String? token = await FirebaseMessaging.instance.getToken();
      var url = Uri.https('api.choparpizza.uz', '/api/auth_otp');
      var formData = {'phone': phoneNumber.value, 'code': otpCode.value};
      if (token != null) {
        formData['token'] = token;
      }
      var response = await http.post(url,
          headers: requestHeaders, body: jsonEncode(formData));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        Codec<String, String> stringToBase64 = utf8.fuse(base64);
        String decoded = stringToBase64.decode(json['result']);
        // print(jsonDecode(decoded));
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
      final buff = utf8.encode('Xa65vmthH15j');
      final base64data = base64.encode(buff);
      final randomString = randomAlphaNumeric(6);
      final hexBuffer = utf8.encode('$randomString$base64data');
      final hexString = HEX.encode(hexBuffer);

      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $hexString'
      };
      var url = Uri.https('api.choparpizza.uz', '/api/ss_zz');
      var formData = {'phone': phoneNumber.value};
      if (_isShowNameField.value) {
        formData['name'] = nameFieldController.text;
      }
      var response = await http.post(url,
          headers: requestHeaders, body: jsonEncode(formData));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if (json['success'] != null) {
          Codec<String, String> stringToBase64 = utf8.fuse(base64);
          String decoded = stringToBase64.decode(json['success']);
          otpToken.value = jsonDecode(decoded)['user_token'];
        }
        _isFinishedTimer.value = false;
      }
    }

    useEffect(() {
      // listenForCode();
      _otpInteractor = OTPInteractor();
      _otpInteractor
          .getAppSignature()
          .then((value) => print('signature - $value'));

      controller = OTPTextEditController(
        codeLength: 4,
        onCodeReceive: (code) => print('Your Application receive code - $code'),
      )..startListenUserConsent(
          (code) {
            print(code);
            final exp = RegExp(r'(\d{4})');
            return exp.stringMatch(code ?? '') ?? '';
          },
          // strategies: [
          //   SampleStrategy(),
          // ],
        );

      return () {
        // SmsAutoFill().unregisterListener();
        controller?.stopListen();
        print('Unregistered');
      };
    }, const []);

    Box<User> user = Hive.box<User>('user');
    User? currentUser = user.get('user');

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
                          tr('sent_code_to_number'),
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
                        child: PinCodeTextField(
                          controller: controller ?? TextEditingController(),
                          enablePinAutofill: true,
                          autoFocus: true,
                          length: 4,
                          onChanged: (String value) {},
                          appContext: context,
                          keyboardType: TextInputType.number,
                          onCompleted: (String code) {
                            if (code.length == 4) {
                              otpCode.value = code;
                              trySignIn();
                            }
                          },
                          pinTheme: PinTheme(
                              borderRadius: BorderRadius.circular(25),
                              fieldWidth: 55,
                              shape: PinCodeFieldShape.box,
                              inactiveColor: Colors.grey,
                              activeColor: Colors.yellow.shade600,
                              selectedColor: Colors.yellow.shade600),
                        )),
                    Spacer(),
                    _isFinishedTimer.value
                        ? Container(
                            child: InkWell(
                              child: Text(
                                tr('get_new_code'),
                                style: TextStyle(
                                    color: Colors.yellow.shade600,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () {
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
                                    '${tr('code_not_received')} ${time.ceil().toString()} ${tr('seconds')}.',
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
                          text: tr('login'),
                        ))
                  ],
                ),
              ),
            )
          : FormBuilder(
              key: formKey,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.0),
                    Row(
                      children: [
                        Text(
                          tr('enter_your_number'),
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
                          tr('to_quickly_place_orders_and_receive_bonuses'),
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
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
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
                            setSelectorButtonAsPrefixIcon: true,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle:
                              TextStyle(color: Colors.black, fontSize: 24.0),
                          initialValue: number,
                          formatInput: true,
                          countrySelectorScrollControlled: false,
                          keyboardType: TextInputType.number,
                          inputBorder: InputBorder.none,
                          hintText: '',
                          errorMessage: tr('invalid_number'),
                          spaceBetweenSelectorAndTextField: 8,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.center,
                          inputDecoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            border: InputBorder.none,
                          ),
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 24.0),
                          maxLength: 12,
                          onSaved: (PhoneNumber number) {},
                          autoFocus: true,
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
                                  return tr('enter_your_name');
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: tr('your_name'),
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
                    _isShowNameField.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: FormBuilderDateTimePicker(
                              name: 'birth',
                              // onChanged: _onChanged,
                              inputType: InputType.date,
                              // style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  labelText: tr('birthday'),
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
                              initialTime: const TimeOfDay(hour: 8, minute: 0),
                              initialValue: currentUser?.birth != null
                                  ? DateTime.parse(currentUser!.birth!)
                                  : null,
                              validator: (val) {
                                if (val == null) {
                                  return tr('enter_your_birthday');
                                }
                                return null;
                              },
                              // enabled: true,
                            ),
                          )
                        : SizedBox(),
                    _isShowNameField.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text('Укажите ваш пол',
                              //     style: TextStyle(fontSize: 18)),
                              SizedBox(
                                width: 100,
                                child: ListTile(
                                  title: Text(tr('male')),
                                  leading: Radio<int>(
                                    activeColor: Colors.yellow.shade600,
                                    value: 1,
                                    groupValue: _gender.value,
                                    onChanged: (value) {
                                      _gender.value = value!;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: ListTile(
                                  title: Text(tr('female')),
                                  leading: Radio<int>(
                                    activeColor: Colors.yellow.shade600,
                                    value: 0,
                                    groupValue: _gender.value,
                                    onChanged: (value) {
                                      _gender.value = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
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
                        text: tr('get_code'),
                        onPressed: () async {
                          if (_isSendingPhone.value) {
                            return;
                          }
                          formKey.currentState!.save();
                          if (formKey.currentState != null &&
                              formKey.currentState!.validate()) {
                            _isSendingPhone.value = true;
                            Map<String, String> requestHeaders = {
                              'Content-type': 'application/json',
                              'Accept': 'application/json'
                            };
                            var url =
                                Uri.https('api.choparpizza.uz', '/api/keldi');
                            var response =
                                await http.get(url, headers: requestHeaders);
                            if (response.statusCode == 200) {
                              var json = jsonDecode(response.body);
                              Codec<String, String> stringToBase64 =
                                  utf8.fuse(base64);
                              String decoded =
                                  stringToBase64.decode(json['result']);

                              final buff = utf8.encode('Xa65vmthH15j');
                              final base64data = base64.encode(buff);
                              final randomString = randomAlphaNumeric(6);
                              final hexBuffer =
                                  utf8.encode('$randomString$base64data');
                              final hexString = HEX.encode(hexBuffer);

                              Map<String, String> requestHeaders = {
                                'Content-type': 'application/json',
                                'Accept': 'application/json',
                                'Authorization': 'Bearer $hexString'
                              };
                              url =
                                  Uri.https('api.choparpizza.uz', '/api/ss_zz');
                              var formData = {'phone': phoneNumber.value};
                              if (_isShowNameField.value) {
                                formData['name'] = nameFieldController.text;
                              }
                              var values = {...formKey.currentState!.value};
                              if (values['birth'] != null) {
                                formData['birth'] = values['birth'] =
                                    DateFormat('yyyy-MM-dd')
                                        .format(values['birth']);
                              }
                              formData['gender'] = _gender.value.toString();

                              response = await http.post(url,
                                  headers: requestHeaders,
                                  body: jsonEncode(formData));
                              if (response.statusCode == 200) {
                                json = jsonDecode(response.body);
                                if (json['error'] != null) {
                                  if (json['error'] ==
                                      'name_field_is_required') {
                                    _isShowNameField.value = true;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text(tr('name_field_is_required')),
                                      duration: Duration(seconds: 3),
                                    ));
                                  }
                                  if (json['error'] == 'user_is_blocked') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(tr(
                                                'you_are_deleting_your_account_please_contact_us'))));
                                  }
                                } else if (json['success'] != null) {
                                  Codec<String, String> stringToBase64 =
                                      utf8.fuse(base64);
                                  String decoded =
                                      stringToBase64.decode(json['success']);
                                  otpToken.value =
                                      jsonDecode(decoded)['user_token'];
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
