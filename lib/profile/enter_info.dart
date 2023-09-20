// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/new_entry_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_photo.dart';

class EnterInfo extends StatefulWidget {
  const EnterInfo({Key? key}) : super(key: key);

  @override
  _EnterInfoState createState() => _EnterInfoState();
}

class _EnterInfoState extends State<EnterInfo> {
TextEditingController phoneNumber = TextEditingController();
TextEditingController fatherName = TextEditingController();
TextEditingController motherName = TextEditingController();
TextEditingController momsMaiden = TextEditingController();
TextEditingController parentsMarried = TextEditingController();
TextEditingController siblingsController = TextEditingController();
TextEditingController rabbiShul = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController openToMoving = TextEditingController();
TextEditingController school = TextEditingController();
TextEditingController work = TextEditingController();
TextEditingController hobbies = TextEditingController();
TextEditingController frefName = TextEditingController();
TextEditingController frefPhone = TextEditingController();
TextEditingController frefRelation = TextEditingController();
TextEditingController lrefName = TextEditingController();
TextEditingController lrefPhone = TextEditingController();
TextEditingController lrefRelation = TextEditingController();
TextEditingController aboutMe = TextEditingController();
TextEditingController lookingFor = TextEditingController();
TextEditingController lottery = TextEditingController();
  var currentIndex;
  String gender = "";
  bool cohen = false;
  String cohenValue = "";
  late FocusNode myFocusNode;
  var height = "4.0";
  var label = "0";
  String religionLevel = "";
  String maritialStatus = "";
  
  

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  goToAddPhoto() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const AddPhoto();
    }));
  }

  void getPrefs() async {
    SharedPreferences prefs = await Constants.getPrefs();
    setState(() {
      gender = prefs.getString("gender") ?? "";
    });
  }

Container _getSlider(context, bool disable) {
  return Container(
    alignment: Alignment.centerLeft,
    child: Slider(
        value: double.parse(height),
        min: 4.0,
        divisions: 80,
        label: label,
        max: 8.0,
        activeColor: Color(0xFF9F7632),
        inactiveColor: lightGreenColor,
        thumbColor: Color(0xFF9F7632),
        onChanged: (value) {
          setState(() {
            label = "${value.toStringAsFixed(2)}''  (${(value * 30.43).toStringAsFixed(1)}cm)";
            height = value.toString();
          });
        }),
  );
}


  void next() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && cohenValue.isNotEmpty && maritialStatus.isNotEmpty ) {
    await FirebaseFirestore.instance.collection("profile").doc(user.uid).set({
        'phoneNo': phoneNumber.text,
        'height': height,
        'fatherName': fatherName.text,
        'motherName': motherName.text,
        'momMaider': momsMaiden.text,
        'parentsMarriage': parentsMarried.text,
        'siblings': siblingsController.text,
        'rabbiShul': rabbiShul.text,
        'address': address.text,
        'openToMoving': openToMoving.text,
        'religionLevel': religionLevel,
        'school': school.text,
        'work': work.text,
        'hobbies': hobbies.text,
        'firstRefName': frefName.text,
        'firstRefPhone': frefPhone.text,
        'firstRefRelation': frefRelation.text,
        'lastRefName': lrefName.text,
        'lastRefPhone': lrefPhone.text,
        'lastRefRelation': lrefRelation.text, 
         'cohen': cohen,
        'aboutMe': aboutMe.text,
        'lookingFor': lookingFor.text,
        'lottery': lottery.text,
        'maritialStatus': maritialStatus,
        'cohenValue': cohenValue,
      }, SetOptions(merge: true)).then((value) async {
        SharedPreferences prefs = await Constants.getPrefs();
        prefs.setString("phoneNo", phoneNumber.text);
        prefs.setString("height", height);
        prefs.setString("fatherName", fatherName.text);
        prefs.setString("motherName", motherName.text);
        prefs.setString("momsMaiden", momsMaiden.text);
        prefs.setString("parentsMarriage", parentsMarried.text);
        prefs.setString("siblings", siblingsController.text);
        prefs.setString("rabbiShul", rabbiShul.text);
        prefs.setString("address", address.text);
        prefs.setString("openToMoving", openToMoving.text);
        prefs.setString("religionLevel", religionLevel);
        prefs.setString('school', school.text);
        prefs.setString('work', work.text);
        prefs.setString('hobbies', hobbies.text);
        prefs.setString('firstRefName', frefName.text);
        prefs.setString('firstRefPhone', frefPhone.text);
        prefs.setString('firstRefRelation', frefRelation.text);
        prefs.setString('lastRefName', lrefName.text);
        prefs.setString('lastRefPhone', lrefPhone.text);
        prefs.setString('lastRefRelation', lrefRelation.text);
        prefs.setString('aboutMe', aboutMe.text);
        prefs.setString('lookingFor', lookingFor.text);
        prefs.setString('lottery', lottery.text);
        prefs.setString('martialStatus', maritialStatus);
        prefs.setBool('cohen', cohen);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return const AddPhoto();
            },
          ),
        );
      }).catchError((onError) {
        log(onError.
        toString());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill the Cohen Or Maritial Status Field"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greenBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: greenBackgroundColor,
          iconTheme: const IconThemeData(color: whiteColor),
          title: Text('Enter Details', style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.w600)),

        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Column(
                children: [

                  // phone number field
                  // NewEntryField(
                  //     'Phone Number',
                  //     Colors.pinkAccent,
                  //     TextInputType.phone,
                  //     phoneNumber,
                  //     false,
                  //     Icons.mail,
                  //     Colors.transparent,
                  //     whiteColor,
                  //     false,
                  //     1,
                  //     1),
                  const SizedBox(
                    height: 20,
                  ),
                  // height
                  kSpacing,
                  subText("Height"),
                  _getSlider(context, false),
                  //  this is a father'name field
                  subText("Father's Name (optional)"),
                  NewEntryField(
                      label: "Enter Father's Name",
                      textInputType: TextInputType.name,
                      controller: fatherName,),
                kSpacing,
                  subText("Mother's Name (optional)"),
                  NewEntryField(
                    label: "Enter Mother's Name",
                    textInputType: TextInputType.name,
                    controller: motherName,),
                  kSpacing,
                  subText("Moms Maiden Name (optional)"),
                  NewEntryField(
                    label: "Enter Moms Maiden Name",
                    textInputType: TextInputType.name,
                    controller: momsMaiden,),
                  kSpacing,
                  subText("Are your parents married?"),
                  NewEntryField(
                    label: "Enter Parents Marital Status",
                    textInputType: TextInputType.name,
                    controller: parentsMarried,),
                  kSpacing,
                  subText("How many siblings do you have? and who they married"),
                  NewEntryField(
                    label: "Enter Details",
                    textInputType: TextInputType.name,
                    controller: siblingsController,),
                  kSpacing,
                  subText("Rabbi/Shul"),
                  NewEntryField(
                    label: "Enter Details",
                    textInputType: TextInputType.name,
                    controller: rabbiShul,),
                  kSpacing,
                  subText("In Which City & State do you live now?"),
                  NewEntryField(
                    label: "Address",
                    textInputType: TextInputType.name,
                    controller: address,),
                  kSpacing,
                  subText("Are you open to moving?"),
                  NewEntryField(
                    label: "Open to Moving?",
                    textInputType: TextInputType.name,
                    controller: openToMoving,),
                  kSpacing,
                  subText("Religious Level"),
                  // religous level
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        DropdownButton(
                          borderRadius: BorderRadius.circular(12),
                          alignment: Alignment.center,
                          enableFeedback: true,
                          underline: const Divider(
                            color: whiteColor,
                            thickness: 1,
                          ),
                          dropdownColor: greenBackgroundColor,
                          iconEnabledColor: whiteColor,
                          hint:
                              // seeking == null
                              //     ? Text('Dropdown')
                              //     :
                              Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 10.0, top: 2),
                            child: Text(religionLevel,
                                style: const TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'CaviarDreams',
                                )),
                          ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(
                            color: whiteColor,
                            fontFamily: 'CaviarDreams',
                          ),
                          items: [
                           "R0 - Not Religious (eats, doesn't pray, no Shabbat)",
                           "R1 - Regular religious- eats out dairy, Observes Shabbat",
                           "R2 - Doesn't eat out. Keeps kosher and Shabbat ",
                           "R3 - Girl wears skirts (boy who wants girl in skirts",
                           "RW - Girl skirts & cover hair - looking for working boy who wants skirts/hair and has a set learning schedule",
                           "RL - girl skirts & cover hair - looking for learning boy who wants skirts/ hair",
                          ].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (String? val) {
                            setState(
                              () {
                                religionLevel = val!;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  kSpacing,
                  subText("Schools Attended"),
                  NewEntryField(
                    label: "Enter Name of Schools",
                    textInputType: TextInputType.name,
                    controller: school,),
                  kSpacing,
                  subText("Work"),
                  NewEntryField(
                    label: "Enter Work Details",
                    textInputType: TextInputType.name,
                    controller: work,),
                  kSpacing,
                  subText("Hobbies,free time,talents"),
                  NewEntryField(
                    label: "Enter Hobbies",
                    textInputType: TextInputType.name,
                    controller: hobbies,),
                  kSpacing,
                  subText("2 References"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: NewEntryField(
                                label: "Name",
                                textInputType: TextInputType.name,
                                controller: frefName,),
                            ),
                            smallHSpace(),
                            Expanded(
                              child: NewEntryField(
                                label: "Phone Number",
                                textInputType: TextInputType.name,
                                controller: frefPhone,),
                            ),
                            smallHSpace(),
                            Expanded(
                              child: NewEntryField(
                                label: "Relation",
                                textInputType: TextInputType.name,
                                controller: frefRelation,),
                            ),

                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: NewEntryField(
                                label: "Name",
                                textInputType: TextInputType.name,
                                controller: lrefName,),
                            ),
                            smallHSpace(),
                            Expanded(
                              child: NewEntryField(
                                label: "Phone Number",
                                textInputType: TextInputType.name,
                                controller: lrefPhone,),
                            ),
                            smallHSpace(),
                            Expanded(
                              child: NewEntryField(
                                label: "Relation",
                                textInputType: TextInputType.name,
                                controller: lrefRelation,),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  kSpacing,
                  //  Cohen
                  if(gender == "male")
                  Card(
                    elevation: 0,
                    color: greenBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: greenBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (gender == "male")
                              subText("Are You COHEN ?"),
                            if (gender == "female")
                              subText("What is your maritial status ?"),
                            DropdownButton(
                              borderRadius: BorderRadius.circular(12),
                              alignment: Alignment.center,
                              enableFeedback: true,
                              underline: const Divider(
                                color: whiteColor,
                                thickness: 3,
                              ),
                              dropdownColor: greenBackgroundColor,
                              iconEnabledColor: whiteColor,
                              hint:
                                  // seeking == null
                                  //     ? Text('Dropdown')
                                  //     :
                                  Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 12.0),
                                child: Text(cohenValue,
                                    style: const TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'CaviarDreams',
                                    )),
                              ),
                              isExpanded: true,
                              iconSize: 30.0,
                              style: const TextStyle(
                                color: whiteColor,
                                fontFamily: 'CaviarDreams',
                              ),
                              items: [
                                'Yes',
                                'No',
                              ].map(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (String? val) {
                                if (val != null) {
                                  setState(
                                    () {
                                      cohenValue = val;
                                      cohen = val == "Yes" ? true : false;
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: greenBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: greenBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              const Text(
                                'What is your maritial status ?',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            DropdownButton(
                              borderRadius: BorderRadius.circular(12),
                              alignment: Alignment.center,
                              enableFeedback: true,
                              underline: const Divider(
                                color: whiteColor,
                                thickness: 3,
                              ),
                              dropdownColor: greenBackgroundColor,
                              iconEnabledColor: whiteColor,
                              hint:
                                  // seeking == null
                                  //     ? Text('Dropdown')
                                  //     :
                                  Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 12.0),
                                child: Text(maritialStatus,
                                    style: const TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'CaviarDreams',
                                    )),
                              ),
                              isExpanded: true,
                              iconSize: 30.0,
                              style: const TextStyle(
                                color: whiteColor,
                                fontFamily: 'CaviarDreams',
                              ),
                              items: [
                                'Single',
                                'Divorced',
                                'Widowed',
                              ].map(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (String? val) {
                                if (val != null) {
                                  setState(
                                    () {
                                      maritialStatus = val;
                                      cohenValue = "No";
                                      cohen = false;
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  kSpacing,
                  subText("If you won the lottery, what would you do and your priorities ?"),
                  NewEntryField(
                    label: "Enter Details",
                    textInputType: TextInputType.name,
                    controller: lottery,),

                  kSpacing,
                  kSpacing,
                  kSpacing,

                  ButtonIconLess('Continue', whiteColor, whiteColor, whiteColor,
                      1.3, 18, 17, next),
                    const SizedBox(height: 20,)


                ],
              ),
            ),
          ),
        ));
  }
}
