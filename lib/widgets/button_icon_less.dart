import 'package:flutter/material.dart';

class ButtonIconLess extends StatefulWidget {
  final String name;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback function;
  const ButtonIconLess(this.name, this.color, this.borderColor, this.textColor,
      this.width, this.height, this.fontSize, this.function,
      {Key? key})
      : super(key: key);

  @override
  _ButtonIconLessState createState() => _ButtonIconLessState();
}

class _ButtonIconLessState extends State<ButtonIconLess> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        height: MediaQuery.of(context).size.height / widget.height,
        width: MediaQuery.of(context).size.width / widget.width,
        decoration: BoxDecoration(
          gradient:  LinearGradient(
              colors: [
                Color(0xFFD7C299), Color(0xFF9F7632)
              ],
              stops: [0.0, 1.0],
              begin: FractionalOffset.centerLeft,
              end: FractionalOffset.centerRight,
              tileMode: TileMode.repeated
          ),
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                      color: widget.textColor, fontSize: widget.fontSize, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
