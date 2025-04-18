import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WorkTimeWidget extends StatefulWidget {
  const WorkTimeWidget({Key? key}) : super(key: key);

  @override
  State<WorkTimeWidget> createState() => _WorkTimeWidgetState();
}

// class _WorkTimeWidgetState extends State<WorkTimeWidget> {
//   var workTimeModalOpened = false;
//   late Flushbar _closeWorkModal;

//   workTimeDialog() async {
//     var startTime = DateTime.now();
//     DateTime dateC = DateTime.now();
//     startTime.minute;

//     DateTime dateA = DateTime(dateC.year, dateC.month, dateC.day, 2, 45);
//     DateTime dateB = DateTime(dateC.year, dateC.month, dateC.day, 10);
//     if (dateA.isBefore(dateC) && dateB.isAfter(dateC)) {
//       await Future.delayed(Duration(milliseconds: 50));
//       if (!workTimeModalOpened) {
//         _closeWorkModal = Flushbar(
//             message: "Откроемся в 10:00",
//             flushbarPosition: FlushbarPosition.TOP,
//             flushbarStyle: FlushbarStyle.FLOATING,
//             reverseAnimationCurve: Curves.decelerate,
//             forwardAnimationCurve: Curves.elasticOut,
//             backgroundColor: Colors.black87,
//             isDismissible: false,
//             duration: Duration(days: 4),
//             icon: Container(
//               padding: EdgeInsets.only(left: 10),
//               child: Icon(
//                 Icons.lock_clock,
//                 color: Colors.white,
//                 size: 40,
//               ),
//             ),
//             messageText: Container(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Text(
//                 "Откроемся в 10:00",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 20.0,
//                     color: Colors.white,
//                     fontFamily: "ShadowsIntoLightTwo"),
//               ),
//             ),
//             margin: EdgeInsets.all(10),
//             borderRadius: BorderRadius.circular(10));
//         setState(() {
//           workTimeModalOpened = true;
//         });
//         _closeWorkModal.show(context);
//       }
//     } else {
//       if (workTimeModalOpened && _closeWorkModal != null) {
//         _closeWorkModal.dismiss();
//       }
//       setState(() {
//         workTimeModalOpened = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Timer.periodic(new Duration(seconds: 1), (timer) {
//       workTimeDialog();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox();
//   }
// }

class _WorkTimeWidgetState extends State<WorkTimeWidget> {
  var workTimeModalOpened = false;
  late Flushbar _closeWorkModal;

  Timer? _timer; // Declare a Timer variable

  workTimeDialog() async {
    var startTime = DateTime.now();
    DateTime dateC = DateTime.now();
    startTime.minute;

    DateTime dateA = DateTime(dateC.year, dateC.month, dateC.day, 2, 45);
    DateTime dateB = DateTime(dateC.year, dateC.month, dateC.day, 10);
    if (dateA.isBefore(dateC) && dateB.isAfter(dateC)) {
      await Future.delayed(Duration(milliseconds: 50));
      if (!workTimeModalOpened) {
        _closeWorkModal = Flushbar(
            message: "${tr('open_at')} 10:00",
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundColor: Colors.black87,
            isDismissible: false,
            duration: Duration(days: 4),
            icon: Container(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.lock_clock,
                color: Colors.white,
                size: 40,
              ),
            ),
            messageText: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "${tr('open_at')} 10:00",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: "ShadowsIntoLightTwo"),
              ),
            ),
            margin: EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(10));
        if (mounted) {
          setState(() {
            workTimeModalOpened = true;
          });
        }
        _closeWorkModal.show(context);
      }
    } else {
      if (workTimeModalOpened) {
        _closeWorkModal.dismiss();
      }
      if (mounted) {
        setState(() {
          workTimeModalOpened = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      workTimeDialog();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
