import 'package:flutter/material.dart';

class DefaultStyledButton extends StatelessWidget {
  final double width;
  final onPressed;
  final String text;
  final List<Color>? color;
  final double? height;
  final Color? textColor;
  final double? textSize;
  final bool? isLoading;

  const DefaultStyledButton(
      {Key? key,
      required this.width,
      required this.onPressed,
      required this.text,
      this.color,
      this.height,
      this.textColor,
      this.textSize,
      this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: ElevatedButton(
        child: Ink(
          height: height != null ? height : 45.0,
          width: double.maxFinite,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: color != null
                      ? color!
                      : [Colors.yellow.shade300, Colors.yellow.shade700],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(25.0)),
          child: Center(
            child: isLoading != null
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text,
                    style: TextStyle(
                        fontSize: textSize != null ? textSize : 18.0,
                        color: textColor != null ? textColor : Colors.white,
                        fontWeight: FontWeight.w700),
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
