import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          RawMaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close, size: 31.0, color: Colors.grey),
            padding: EdgeInsets.all(10.0),
            shape: CircleBorder(),
          ),
        ]),
        SvgPicture.asset('assets/images/logo.svg',
            semanticsLabel: 'Chopar logo'),
        SizedBox(
          height: 20,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 80),
            child: Text(
              'Chopar Pizza - национальная сеть пиццерий, специализирующаяся на пицце в лучших традициях востока.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(47, 94, 142, 1),
                  fontSize: 11,
                  height: 1.5),
            )),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {},
              child: FaIcon(FontAwesomeIcons.instagram),
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.yellow.shade800),
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
                onPrimary: Colors.yellow.shade800, // <-- Splash color
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              child: FaIcon(FontAwesomeIcons.facebook),
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.yellow.shade800),
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
                onPrimary: Colors.yellow.shade800, // <-- Splash color
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              child: FaIcon(FontAwesomeIcons.telegram),
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.yellow.shade800),
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
                onPrimary: Colors.yellow.shade800, // <-- Splash color
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              shrinkWrap: true,
              children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  contentPadding: EdgeInsets.all(0.00),
                  title: Text(
                    'Пользовательское соглашение',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => Bonuses(),
                  //     ),
                  //   );
                  // },
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.00),
                  title: Text(
                    'Политика конфиденциальности',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => Orders(),
                  //     ),
                  //   );
                  // },
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.00),
                  title: Text(
                    'Публичная оферта',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.00),
                  title: Text(
                    'Правила акций',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ]).toList(),
            ))
      ],
    )));
  }
}
