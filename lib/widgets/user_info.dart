// ignore_for_file: file_names, unused_field

import 'package:flutter/material.dart';
import 'package:app/constants.dart';

class UserInfoTile extends StatefulWidget {
  final String text;
  const UserInfoTile(
    this.text, {
    Key? key,
  }) : super(key: key);
  @override
  _UserInfoTileState createState() => _UserInfoTileState();
}

class _UserInfoTileState extends State<UserInfoTile> {
  bool _passwordVisible = false;
 

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

void changeText(String text) {
  setState(() {
    text = widget.text;
  });
}


  @override
  Widget build(BuildContext context) {
    return 
    // Container(
    //   decoration: BoxDecoration(
    //     color: whiteColor,
    //     shape: BoxShape.rectangle,
    //     borderRadius: BorderRadius.circular(14),
    //   ),
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: TextField(
    //           onChanged: changeText,
    //           controller: widget.text,
    //           readOnly: true,
    //           style: const TextStyle(color: pinkAccent),
    //           textInputAction: TextInputAction.next,
    //           autofocus: true,
    //           obscureText: false,
    //           cursorColor: pinkAccent,
    //           maxLines: 1,
    //           decoration: InputDecoration(
    //             focusColor: pinkAccent,
    //             fillColor: pinkAccent,
    //             hoverColor: pinkAccent,
    //             labelText: widget.title,
    //             labelStyle: const  TextStyle(color: purpleColor, fontSize: 14),
    //             border: OutlineInputBorder(
    //               borderSide: const BorderSide(
    //                 color: pinkAccent,
    //               ),
    //               borderRadius: BorderRadius.circular(11),
    //             ),
    //             focusedBorder: OutlineInputBorder(
    //               borderSide: const BorderSide(color: purpleColor),
    //               borderRadius: BorderRadius.circular(11),
    //             ),
    //             enabledBorder: OutlineInputBorder(
    //               borderSide: const  BorderSide(color: purpleColor),
    //               borderRadius: BorderRadius.circular(11),
    //             ),
    //             contentPadding: const EdgeInsets.symmetric(
    //               horizontal: 20,
    //               vertical: 10,
    //             ),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         width: 10,
    //       ),
    //     ],
    //   ),
    // );
          
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: goldColor)
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(widget.text,
                style: const TextStyle(color: goldColor),),
              ),);
          
        
       
    
  }
}
