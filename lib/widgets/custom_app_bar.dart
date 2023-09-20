import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAppBar extends StatelessWidget {
  final Widget back;
  final String title;
  final List<Widget> actions;
  const CustomAppBar(this.back, this.title, this.actions,{Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: goldColor,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 60,
        child: Row(
          children: [
            back,
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            for(int i = 0; i < actions.length; i++)
            actions[i]
          ],
        ),
      ),
    );
  }
}
