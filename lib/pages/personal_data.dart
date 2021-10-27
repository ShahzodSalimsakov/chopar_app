import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalData extends StatelessWidget {
  const PersonalData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
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
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Имя',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 45,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              suffixIcon: IconButton(
                                padding: EdgeInsets.only(right: 17),
                                iconSize: 20,
                                onPressed: () {},
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Номер телефона',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 45,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              suffixIcon: IconButton(
                                padding: EdgeInsets.only(right: 17),
                                iconSize: 20,
                                onPressed: () {},
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Эл. почта',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 45,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              suffixIcon: IconButton(
                                padding: EdgeInsets.only(right: 17),
                                iconSize: 20,
                                onPressed: () {},
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'День рождения',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 2,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40)),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 2,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40)),
                          ),
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 4,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40)),
                          ),
                        )),
                      ],
                    )
                  ],
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 45,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 33),
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0))),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.yellow.shade600)),
                        child: Text('Сохранить',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        onPressed: () {}))),
          ],
        ));
  }
}
