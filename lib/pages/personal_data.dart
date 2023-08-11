import 'package:auto_route/auto_route.dart';
import 'package:chopar_app/models/user.dart';
import 'package:chopar_app/widgets/ui/styled_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/basket.dart';
import '../models/basket_item_quantity.dart';

@RoutePage()
class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({Key? key}) : super(key: key);

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool isLoading = false;
  bool deleteIsLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  logout() async {
    Box<User> transaction = Hive.box<User>('user');
    User currentUser = transaction.get('user')!;
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${currentUser.userToken}'
    };
    var url = Uri.https('api.choparpizza.uz', '/api/logout');
    var formData = {};
    var response = await http.post(url,
        headers: requestHeaders, body: jsonEncode(formData));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
    }
    transaction.delete('user');
    Box<Basket> basketBox = Hive.box<Basket>('basket');
    basketBox.delete('basket');
    Box<BasketItemQuantity> basketItemQuantityBox =
        Hive.box<BasketItemQuantity>('basketItemQuantity');
    await basketItemQuantityBox.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<User>>(
        valueListenable: Hive.box<User>('user').listenable(),
        builder: (context, box, _) {
          User? currentUser = box.get('user');
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                centerTitle: true,
                title: Text('Личные данные',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              ),
              body: Stack(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      height: MediaQuery.of(context).size.height * 0.53,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormBuilder(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                children: [
                                  FormBuilderTextField(
                                    name: 'name',
                                    initialValue: currentUser?.name ?? '',
                                    // validator: (value) => value?.length == 0 ? 'Поле обязательно для заполнения' : '',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText:
                                              'Поле обязательно для заполнения')
                                    ]),
                                    decoration: InputDecoration(
                                        labelText: 'Имя',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.0, color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.0, color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(40))),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FormBuilderPhoneField(
                                    name: 'phone',
                                    initialValue: currentUser?.phone ?? '',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                          errorText:
                                              'Поле обязательно для заполнения'),
                                      FormBuilderValidators.minLength(13,
                                          errorText: 'Заполнено неверно')
                                    ]),
                                    decoration: InputDecoration(
                                        labelText: 'Номер телефона',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.0, color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.0, color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(40))),
                                    // onChanged: _onChanged,
                                    priorityListByIsoCode: ['UZ'],
                                    defaultSelectedCountryIsoCode: 'UZ',
                                    countryFilterByIsoCode: ['Uz'],
                                    isSearchable: false,
                                    autocorrect: true,
                                    // validator: ,
                                    // validator: FormBuilderValidators.compose([
                                    //   FormBuilderValidators.numeric(context),
                                    //   FormBuilderValidators.required(context),
                                    // ]),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FormBuilderTextField(
                                    name: 'email',
                                    initialValue: currentUser?.email ?? '',
                                    decoration: InputDecoration(
                                      labelText: 'Эл. почта',
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1.0),
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FormBuilderDateTimePicker(
                                      name: 'birth',
                                      // onChanged: _onChanged,
                                      inputType: InputType.date,
                                      decoration: InputDecoration(
                                        labelText: 'День рождения',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                      ),
                                      initialTime:
                                          TimeOfDay(hour: 8, minute: 0),
                                      initialValue: currentUser?.birth != null
                                          ? DateTime.parse(currentUser!.birth!)
                                          : null
                                      // initialValue: DateTime.now(),
                                      // enabled: true,
                                      ),
                                ],
                              )),
                        ],
                      )),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 140,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                  // height: 60,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: DefaultStyledButton(
                                      width: MediaQuery.of(context).size.width -
                                          30,
                                      isLoading: deleteIsLoading == true
                                          ? deleteIsLoading
                                          : null,
                                      text: 'Удалить аккаунт',
                                      onPressed: () async {
                                        setState(() {
                                          deleteIsLoading = true;
                                        });
                                        Map<String, String> requestHeaders = {
                                          'Content-type': 'application/json',
                                          'Accept': 'application/json',
                                          'Authorization':
                                              'Bearer ${currentUser!.userToken}'
                                        };
                                        var url = Uri.https(
                                            'api.choparpizza.uz',
                                            '/api/delete');

                                        var response = await http.post(url,
                                            headers: requestHeaders);
                                        if (response.statusCode == 200) {
                                          await logout();
                                          Navigator.of(context).pop();
                                        }

                                        setState(() {
                                          deleteIsLoading = false;
                                        });
                                      })),
                              DefaultStyledButton(
                                width: MediaQuery.of(context).size.width - 30,
                                isLoading: isLoading == true ? isLoading : null,
                                text: 'Сохранить',
                                onPressed: () async {
                                  _formKey.currentState!.save();
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Map<String, String> requestHeaders = {
                                      'Content-type': 'application/json',
                                      'Accept': 'application/json',
                                      'Authorization':
                                          'Bearer ${currentUser!.userToken}'
                                    };
                                    var url = Uri.https(
                                        'api.choparpizza.uz', '/api/me');
                                    var values =
                                        Map.of(_formKey.currentState!.value);
                                    if (values['email'] == null) {
                                      values['email'] = '';
                                    }
                                    if (values['birth'] != null) {
                                      values['birth'] = DateFormat('yyyy-MM-dd')
                                          .format(values['birth']);
                                    }
                                    var response = await http.post(url,
                                        headers: requestHeaders,
                                        body: jsonEncode(values));
                                    if (response.statusCode == 200) {
                                      var result = jsonDecode(response.body);
                                      User authorizedUser =
                                          User.fromJson(result['data']);
                                      Box<User> transaction =
                                          Hive.box<User>('user');
                                      transaction.put('user', authorizedUser);
                                      Navigator.of(context).pop();
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                              ),
                            ],
                          ))),
                ],
              ));
        });
  }
}
