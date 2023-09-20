// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants.dart';
import 'package:app/profile/enter_info.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/new_entry_field.dart';

import 'my_interest.dart';

class UserPersonalDetails extends StatefulWidget {
  const UserPersonalDetails({Key? key}) : super(key: key);

  @override
  _UserPersonalDetailsState createState() => _UserPersonalDetailsState();
}

class _UserPersonalDetailsState extends State<UserPersonalDetails> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController bithdayController = TextEditingController();
  var cont = false;
  var formattedDate;
   DateTime? pickedDate;
  var currentIndex;
  String selectedGender = "";
  int index = 0;
  bool approved = false;
  List gender = [
    'female',
    'male',
  ];

  @override
  void initState() {
    super.initState();
    formattedDate = 'Enter Birthday';
  }

 

  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(DateTime.now().day - 1),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        var date = DateTime.parse(pickedDate.toString());
        formattedDate = "${date.day}-${date.month}-${date.year}";
        currentDate = pickedDate!;
      });
    }
  }

  goToEnterInfo() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const EnterInfo();
    }));
  }

  void next() async {
    print("d");
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && selectedGender.isNotEmpty && pickedDate != null && firstNameController.text
    .isNotEmpty && lastNameController.text.isNotEmpty && pickedDate != null 
    && aboutMeController.text.isNotEmpty) {
    await FirebaseFirestore.instance
    .collection("profile")
    .doc(user.uid)
    .set({
        'birthDay': pickedDate,
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'gender': selectedGender,
        'about': aboutMeController.text,
        'approved': approved,
      }, SetOptions(merge: true)).then((value) async {
        SharedPreferences prefs = await Constants.getPrefs();
        prefs.setString("birthDay", pickedDate.toString());
        prefs.setString("firstname", firstNameController.text);
        prefs.setString("lastname", lastNameController.text);
        prefs.setString("gender", selectedGender);
        prefs.setString("about", aboutMeController.text);
        prefs.setBool('approved', approved);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return const MyInterests();
            },
          ),
        );
      }).catchError((onError) {
        log(onError.toString());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill the empty fields "),
      ));
    }
  }

  abc() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: whiteColor),
      ),
      backgroundColor: greenBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(children: [
                    SizedBox(
                    width: 80,
                    child: Image.asset('assets/logo.png'),),
                   kLargeSpacing,
                   kLargeSpacing,
                    subText("First Name"),
                    NewEntryField(
                        label:'Enter Name',
                        textInputType: TextInputType.text,
                        controller: firstNameController,
                       ),
                    kSpacing,
                    subText("Last Name"),
                    NewEntryField(
                      label:'Last name',
                      textInputType: TextInputType.text,
                      controller: lastNameController,),
                    kSpacing,
                    subText("Birthday"),
                    tinySpace(),
                    Padding(
                      padding: const EdgeInsets.only(right:10.0),
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: lightGreenColor,
                              border: Border.all(color: lightGreenColor)),
                          child: ListTile(
                              leading: Text(
                                formattedDate.toString(),
                                style: GoogleFonts.poppins(color: whiteColor, fontSize: 17),
                              ),
                              trailing: const Icon(Icons.calendar_today,
                                  color: whiteColor)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 50),
                        const Text(
                          'Gender :',
                          style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        genders(gender[0], 0),
                        genders(gender[1], 1),
                      ],
                    ),
                    const SizedBox(height: 10),

                    NewEntryField(
                      label:'About Me',
                      textInputType: TextInputType.text,
                      maximumLines: 2,
                      controller: aboutMeController,),
                  ],),
                  kLargeSpacing,
                  kLargeSpacing,
                  ButtonIconLess('Continue', whiteColor, whiteColor, whiteColor,
                      1.3, 16, 17,
                       next),
                ],
              ),
            ),
          ),
        
      ),
    );
  }

  Widget genders(String text, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 14,
        width: MediaQuery.of(context).size.width / 4,
        decoration: currentIndex == index
            ? BoxDecoration(
                border: Border.all(color: whiteColor, width: 2),
                borderRadius: BorderRadius.circular(05),

              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
        // ignore: deprecated_member_use
        child: ElevatedButton(
          // elevation: 0,
          // color: Colors.transparent,
          // highlightElevation: 0,
          // highlightColor: Colors.white.withOpacity(0.2),
          // shape: const StadiumBorder(),
          style: ButtonStyle(
            backgroundColor: currentIndex == index ? MaterialStateProperty.all( Color(0xFF9F7632)) : MaterialStateProperty.all(Color(0xFFD7C299))
          ),
          onPressed: () {
            setState(() {
              currentIndex = index;
              selectedGender = gender[currentIndex];
              //  print(selectedGender);
              currentIndex == index ? cont = true : cont = false;
            });
          },
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.w600,
              color: currentIndex == index ? whiteColor : whiteColor,
            //  letterSpacing: 0.10,
            ),
          ),
        ),
      ),
    );
  }
}
