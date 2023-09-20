// ignore_for_file: file_names, unused_field

import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class NewEntryField extends StatefulWidget {
  String? label;
  TextInputType? textInputType;
  TextEditingController? controller;
  bool obscure;
  IconData? icon;
  Widget? prefix;
  Color? color;
  int maximumLines;

  NewEntryField({
    Key? key,
    this.label,
    this.textInputType,
    this.controller,
    this.obscure = false,
    this.icon,
    this.prefix,
    this.color,
    this.maximumLines = 1,
  }) : super(key: key);
  @override
  _NewEntryFieldState createState() => _NewEntryFieldState();
}

class _NewEntryFieldState extends State<NewEntryField> {
  bool _passwordVisible = false;
 

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: GoogleFonts.poppins(
                  color: whiteColor,
                fontSize: 18
              ),
              textInputAction: TextInputAction.next,
              autofocus: true,
              obscuringCharacter: "*",
              obscureText: widget.obscure,
              controller: widget.controller,
              keyboardType: widget.textInputType,
              cursorColor: lightGoldColor,
              cursorWidth: 1,
              maxLines: widget.maximumLines,
              decoration: InputDecoration(
                focusColor: whiteColor,
                filled: true,
                fillColor: lightGreenColor,
                suffixIcon: Icon(widget.icon, color:  lightGoldColor,),
                prefixIcon: widget.prefix,
                hoverColor: blackColor,
                hintText: widget.label,
                hintStyle:  textStyle(17),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: lightGreenColor,),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: lightGoldColor),
                  borderRadius: BorderRadius.circular(14),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: lightGreenColor),
                  borderRadius: BorderRadius.circular(14),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
