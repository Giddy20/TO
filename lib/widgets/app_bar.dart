import 'package:flutter/material.dart';
import 'package:app/constants.dart';

Widget myAppBarWithRoundedBackButton(String title, BuildContext context) {
  return AppBar(
    toolbarHeight: 70,
    elevation: 0,
    centerTitle: true,
    backgroundColor: whiteColor,
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: Container(
            padding: const EdgeInsets.only(left: 3),
            height: 35,
            width: 35,
            child: IconButton(
              onPressed: () {
                try {
                  Navigator.of(context).pop();
                  // (MaterialPageRoute(builder: (_) {
                  //   return const Personal();
                  // }));
                } catch (e) {}
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: blackColor,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        color: blackColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
