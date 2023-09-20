// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:app/constants.dart';

class HomeListTile extends StatefulWidget {
  final IconData icon;
  final String text;
  final function;
  const HomeListTile(this.icon, this.text, this.function, {Key? key})
      : super(key: key);

  @override
  _HomeListTileState createState() => _HomeListTileState();
}

class _HomeListTileState extends State<HomeListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: ListTile(
        leading: Icon(widget.icon, color: Color(0xFF93A096)),
        title: Text(widget.text, style: TextStyle(fontWeight: FontWeight.w200, fontSize: 18, color: Color(0xFF93A096)),),
      ),
    );
  }
}
