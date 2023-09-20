import 'package:flutter/material.dart';

import '../constants.dart';

class AdminCustomAppBar extends StatelessWidget {
  final Widget back;
  final String title;
  final List<Widget> actions;
  final String iconURL;
  const AdminCustomAppBar(this.back, this.title, this.actions,this.iconURL,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: goldColor,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 80,
        child: Row(
          children: [
            back,
            CircleAvatar(
              backgroundImage: NetworkImage(iconURL)),
            const  SizedBox(width: 10,),
            Text(
                title,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.w600,
                  ),
              ),
            const SizedBox(width: 20,),
            for(int i = 0; i < actions.length; i++)
            actions[i]
          ],
        ),
      ),
    );
  }
}
