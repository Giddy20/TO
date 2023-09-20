// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print, prefer_typing_uninitialized_variables

import 'package:app/constants.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class GroupInterest extends StatefulWidget {
  final Function sendList;
  const GroupInterest(this.sendList, {Key? key}) : super(key: key);

  @override
  _GroupInterestState createState() => _GroupInterestState();
}

class _GroupInterestState extends State<GroupInterest> {
  var currentIndex;
  String hobby = "";
  List<bool> myInterest = [];
  String religion = "";
  var cont = false;
  List interestList = [
    'Music',
    "Soccer",
    "Movies",
    "Travel",
    "Food",
    "Fashion",
    "Dancing",
    "Gaming",
    "Singing",
    "Gym",
  ];

  @override
  void initState() {
    super.initState();
    interestList.forEach((element) {
      myInterest.add(false);
    });
  }

  select(selectedValue) {
    setState(() {
      myInterest.add(selectedValue);
    });
  }

  void next() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<String> hbs = [];
      for (int i = 0; i < myInterest.length; i++) {
        if (myInterest[i]) {
          hbs.add(interestList[i]);
        }
      }
      widget.sendList(hbs);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: lightPurpleColor,
          iconTheme: const IconThemeData(color: goldColor),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: lightPurpleColor,
        body: Column(
          children: [
            const Text(
              'PLEASE SELECT YOUR INTERESTS',
              style: TextStyle(
                fontSize: 18,
                color: goldColor,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: interestList.length,
                itemBuilder: (BuildContext context, int index) {
                  return myInterests(interestList[index], index);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ButtonIconLess('CONTINUE', goldColor, goldColor,
                  whiteColor, 1.3, 14, 17, next),
            ),
          ],
        ),
      ),
    );
  }

  Widget myInterests(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Container(
          decoration: BoxDecoration(
              color: lightPurpleColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: goldColor, width: 2)),
          child: Theme(
            data: Theme.of(context).copyWith(
                unselectedWidgetColor: lightPurpleColor,
                selectedRowColor: lightPurpleColor.withOpacity(0.6)),
            child: CheckboxListTile(
                title: Text(
                  text,
                  style: const TextStyle(color: goldColor),
                ),
                tileColor: lightPurpleColor,
                activeColor: greenBackgroundColor,
                checkColor: goldColor,
                selected: myInterest[index],
                value: myInterest[index],
                onChanged: //select()
                    (value) {
                  setState(() {
                    myInterest[index] = value!;
                    // hobbies.add(value.toString());
                  });
                }),
          )),
    ); //Center
  }
}
