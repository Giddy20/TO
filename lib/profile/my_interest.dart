// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/profile/enter_info.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyInterests extends StatefulWidget {
  const MyInterests({Key? key}) : super(key: key);

  @override
  _MyInterestsState createState() => _MyInterestsState();
}

class _MyInterestsState extends State<MyInterests> {
  var currentIndex;
  String hobby = "";
  List<bool> myInterest = [];
  String religion = "";
  var cont = false;
  List<String> selectedInterest = [];
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
      if (hbs.isNotEmpty) {
      await FirebaseFirestore.instance.collection("profile").doc(user.uid).set(
            {'myInterest': hbs}, SetOptions(merge: true)).then((value) async {
          SharedPreferences prefs = await Constants.getPrefs();
          prefs.setStringList("myInterest", hbs);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return const EnterInfo();
              },
            ),
          );
        }).catchError((onError) {
          log(onError.toString());
        });
      } else {
        Constants.showMessage(context, "Please Select Atleast 1 Interest");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: greenBackgroundColor,
          iconTheme: const IconThemeData(color: whiteColor),
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: greenBackgroundColor,
        body: Column(
          children: [
            SizedBox(
                  width: 80,
                  child: Image.asset('assets/logo.png'),),
            const Text(
              'PLEASE SELECT YOUR INTERESTS',
              style: TextStyle(
                fontSize: 18,
                color: whiteColor,
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
              child: ButtonIconLess('Continue', whiteColor, whiteColor,
                  whiteColor, 1.3, 16, 17, next),
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
              color: greenBackgroundColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: whiteColor, width: 2)),
          child: Theme(
            data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.transparent,
                selectedRowColor: Colors.grey.shade800.withOpacity(0.6)),
            child: CheckboxListTile(
                title: Text(
                  text,
                  style: const TextStyle(color: whiteColor),
                ),
                tileColor: greenBackgroundColor,
                activeColor: greenBackgroundColor,
                checkColor: whiteColor,
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
