import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);
  final instagramLink = 'https://www.instagram.com/choparpizza/';
  final facebookLink = 'https://www.facebook.com/choparpizza';
  final telegramLink = 'https://telegram.me/Chopar_bot';

  @override
  Widget build(BuildContext context) {
    void _launchURLInstagram() async => await canLaunch(instagramLink)
        ? await launch(instagramLink)
        : throw 'Could not launch $instagramLink';
    void _launchURLFacebook() async => await canLaunch(facebookLink)
        ? await launch(facebookLink)
        : throw 'Could not launch $facebookLink';
    void _launchURLTelegram() async => await canLaunch(telegramLink)
        ? await launch(telegramLink)
        : throw 'Could not launch $telegramLink';
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          // RawMaterialButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: Icon(Icons.close, size: 31.0, color: Colors.grey),
          //   shape: CircleBorder(),
          // ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.grey,
              size: 31,
            ),
            onPressed: () => Navigator.of(context).pop(),
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
              onPressed: () {
                _launchURLInstagram();
              },
              child: FaIcon(FontAwesomeIcons.instagram),
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.yellow.shade800),
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
                onPrimary: Colors.yellow.shade800, // <-- Splash color
              ),
            ),
            OutlinedButton(
              onPressed: () {
                _launchURLFacebook();
              },
              child: FaIcon(FontAwesomeIcons.facebook),
              style: ElevatedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.yellow.shade800),
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
                onPrimary: Colors.yellow.shade800, // <-- Splash color
              ),
            ),
            OutlinedButton(
              onPressed: () {
                _launchURLTelegram();
              },
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
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
                            title: Text('Пользовательское соглашение',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ),
                          body: SafeArea(
                              child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                                'Possedit usu sole erant grandia quisque caelo. Diremit mea corpore temperiemque. Subdita quisque nuper ignotas. Natus locoque illi ensis. Indigestaque tegit nova quarum uno et? Vis auroram habentia deducite. Adsiduis longo fratrum tegit lucis humanas. Calidis alta mixtam nebulas satus grandia altae naturae.'),
                          )),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.00),
                  title: Text(
                    'Политика конфиденциальности',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
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
                            title: Text('Политика конфиденциальности',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ),
                          body: SafeArea(
                              child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                                'Possedit usu sole erant grandia quisque caelo. Diremit mea corpore temperiemque. Subdita quisque nuper ignotas. Natus locoque illi ensis. Indigestaque tegit nova quarum uno et? Vis auroram habentia deducite. Adsiduis longo fratrum tegit lucis humanas. Calidis alta mixtam nebulas satus grandia altae naturae.'),
                          )),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.00),
                  title: Text(
                    'Публичная оферта',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
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
                            title: Text('Публичная оферта',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ),
                          body: SafeArea(
                              child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                                'Possedit usu sole erant grandia quisque caelo. Diremit mea corpore temperiemque. Subdita quisque nuper ignotas. Natus locoque illi ensis. Indigestaque tegit nova quarum uno et? Vis auroram habentia deducite. Adsiduis longo fratrum tegit lucis humanas. Calidis alta mixtam nebulas satus grandia altae naturae.'),
                          )),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0.00),
                  title: Text(
                    'Правила акций',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
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
                            title: Text('Правила акций',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                          ),
                          body: SafeArea(
                              child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                                'Possedit usu sole erant grandia quisque caelo. Diremit mea corpore temperiemque. Subdita quisque nuper ignotas. Natus locoque illi ensis. Indigestaque tegit nova quarum uno et? Vis auroram habentia deducite. Adsiduis longo fratrum tegit lucis humanas. Calidis alta mixtam nebulas satus grandia altae naturae.'),
                          )),
                        ),
                      ),
                    );
                  },
                ),
              ]).toList(),
            ))
      ],
    )));
  }
}
