import 'package:flutter/material.dart';

class DefaultStyledButton extends StatelessWidget {
  final double width;
  final onPressed;
  final String text;

  const DefaultStyledButton(
      {Key? key,
      required this.width,
      required this.onPressed,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        child: Ink(
          height: 45.0,
          width: double.maxFinite,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.yellow.shade200, Colors.yellow.shade600],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(25.0)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
