import 'package:chopar_app/widgets/bonus/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:overlay_dialog/overlay_dialog.dart';

class BonusModal extends StatelessWidget {
  const BonusModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(alignment: Alignment.bottomCenter, children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue,
          ),
          padding: EdgeInsets.all(10),
          height: 400,
          width: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Chopar '.toUpperCase(),
                    style:
                        TextStyle(color: Colors.yellow.shade600, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(EasyLocalization.of(context)!.locale.toString() == 'ru' ? tr('gives') : tr('gift'), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Text(EasyLocalization.of(context)!.locale.toString() == 'ru' ? tr('gift') : tr('gives'), style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
              Image.network('https://choparpizza.uz/surpriseMainLogo.png', height: 250,),
              GestureDetector(
                  child: Container(
                      width:240,
                      height: 70,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          // color: Colors.black,
                          image: DecorationImage(
                              image:NetworkImage('https://choparpizza.uz/surpriseButton.png'),
                              fit:BoxFit.cover
                          ), // button text
                      ),
                      child: Text(tr('get_a_gift'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),)
                  ),onTap:(){
                DialogHelper().hide(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BonusIndex(),
                  ),
                );
              }
              )
            ],
          ),
        )
      ]),
    );
  }
}
