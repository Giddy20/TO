// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/new_entry_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({Key? key}) : super(key: key);

  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
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
  TextEditingController about = TextEditingController();
  TextEditingController lookingFor = TextEditingController();
  TextEditingController lottery = TextEditingController();
  var currentIndex;
  String gender = "";
  bool cohen = false;
  String cohenValue = "NO";
  late FocusNode myFocusNode;
  String height = "";
  String religionLevel = "";
  String maritialStatus = "";

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  void getPrefs() async {
    SharedPreferences prefs = await Constants.getPrefs();
    setState(() {
      gender = prefs.getString("gender") ?? "";
      height = prefs.getString("height") ?? "";
      religionLevel = prefs.getString("religionLevel") ?? "";
      cohen = prefs.getBool("cohen") ?? false;
      maritialStatus = prefs.getString("martialStatus") ?? "";
    });
    phoneNumber.text = prefs.getString("phoneNo") ?? "";
    fatherName.text = prefs.getString("fatherName") ?? "";
    motherName.text = prefs.getString("motherName") ?? "";
    momsMaiden.text = prefs.getString("momsMaider") ?? "";
    parentsMarried.text = prefs.getString("parentsMarriage") ?? "";
    siblingsController.text = prefs.getString("siblings") ?? "";
    rabbiShul.text = prefs.getString("rabbiShul") ?? "";
    address.text = prefs.getString("address") ?? "";
    openToMoving.text = prefs.getString("openToMoving") ?? "";
    school.text = prefs.getString("school") ?? "";
    work.text = prefs.getString("work") ?? "";
    frefName.text = prefs.getString("firstRefName") ?? "";
    frefPhone.text = prefs.getString("firstRefPhone") ?? "";
    frefRelation.text = prefs.getString("firstRefRelation") ?? "";
    lrefName.text = prefs.getString("lastRefName") ?? "";
    lrefPhone.text = prefs.getString("lastRefPhone") ?? "";
    hobbies.text = prefs.getString("hobbies") ?? "";
    lrefRelation.text = prefs.getString("lastRefRelation") ?? "";
    about.text = prefs.getString("about") ?? "";
    lookingFor.text = prefs.getString("lookingFor") ?? "";
    lottery.text = prefs.getString("lottery") ?? "";
  }

  void next() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && cohenValue.isNotEmpty && maritialStatus.isNotEmpty) {
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
        'about': about.text,
        'lookingFor': lookingFor.text,
        'lottery': lottery.text,
        'maritialStatus': maritialStatus,
        'startMatch': true,
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
        prefs.setString('about', about.text);
        prefs.setString('lookingFor', lookingFor.text);
        prefs.setString('lottery', lottery.text);
        prefs.setString('martialStatus', maritialStatus);
        prefs.setBool('cohen', cohen);
        Navigator.of(context).pop();
      }).catchError((onError) {
        log(onError.toString());
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
          iconTheme: const IconThemeData(color:  blackColor),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Container(
                padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: redColor)
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Image.asset('assets/logo.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // phone number field
                    // NewEntryField(
                    //     'Phone Number',
                    //     blackColor,
                    //     TextInputType.phone,
                    //     phoneNumber,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    const SizedBox(
                      height: 20,
                    ),
                    // height
                    Card(
                      elevation: 1,
                      color: greenBackgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: greenBackgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 6.0, left: 12, right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Height',
                                style: TextStyle(
                                  color:  blackColor,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 14,
                                ),
                              ),
                              DropdownButton(
                                borderRadius: BorderRadius.circular(12),
                                alignment: Alignment.center,
                                enableFeedback: true,
                                underline: const Divider(
                                  color:  blackColor,
                                  thickness: 1.5,
                                ),
                                dropdownColor: greenBackgroundColor,
                                iconEnabledColor:  blackColor,
                                hint:
                                    // seeking == null
                                    //     ? Text('Dropdown')
                                    //     :
                                    Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 12.0),
                                  child: Text(height,
                                      style: const TextStyle(
                                        color:  blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'CaviarDreams',
                                      )),
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: const TextStyle(
                                  color:  blackColor,
                                  fontFamily: 'CaviarDreams',
                                ),
                                items: [
                                  "4' 6\" (137 cm)",
                                  "4' 7\" (140 cm)",
                                  "4' 8\" (142 cm)",
                                  "4' 9\" (145 cm)",
                                  "4' 10\" (147 cm)",
                                  "4' 11\" (150 cm)",
                                  "5' 0\" (152 cm)",
                                  "5' 1\" (155 cm)",
                                  "5' 2\" (157 cm)",
                                  "5' 3\" (160 cm)",
                                  "5' 4\" (163 cm)",
                                  "5' 5\" (165 cm)",
                                  " 5' 6\" (168 cm)",
                                  "5' 7\" (170 cm)",
                                  "5' 8\" (173 cm)",
                                  "5' 9\" (175 cm)",
                                  "5' 10\" (178 cm)",
                                  "  5' 11\" (180 cm)",
                                  " 6' 0\" (183 cm)",
                                  " 6' 1\" (185 cm)",
                                  " 6' 2\" (188 cm)",
                                  "6' 3\" (191 cm)",
                                  "6' 4\" (193 cm)",
                                  " 6' 5\" (195 cm)",
                                  " 6' 6\" (198 cm)",
                                  "  6' 7\" (201 cm)",
                                  " 6' 8\" (203 cm)",
                                  " 6' 9\" (205 cm)",
                                  "6' 10\" (208 cm)",
                                  "6' 11\" (210 cm)",
                                  " 7' 0\" (213 cm)",
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
                                      height = val!;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //  this is a father'name field
                    NewEntryField(label: "Father's Name"),
                    const SizedBox(
                      height: 20,
                    ),
                    // this is a mother's name field
                    NewEntryField(label: "Mother's Name"),
                    const SizedBox(
                      height: 20,
                    ),
                    // moms maider name
                    // NewEntryField(
                    //     "Moms Maiden",
                    //     blackColor,
                    //     TextInputType.name,
                    //     momsMaiden,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // //  parents maritial status
                    // NewEntryField(
                    //     'Are your parents married?',
                    //     blackColor,
                    //     TextInputType.text,
                    //     parentsMarried,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // //  siblings
                    // NewEntryField(
                    //     'How many siblings do you have? and who they married',
                    //     blackColor,
                    //     TextInputType.text,
                    //     siblingsController,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     4,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // rabbi shul status
                    // NewEntryField(
                    //     'Rabbi|Shul',
                    //     blackColor,
                    //     TextInputType.name,
                    //     rabbiShul,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // address
                    // NewEntryField(
                    //     'In Which City & State do you live now?',
                    //     blackColor,
                    //     TextInputType.streetAddress,
                    //     address,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // open to moving ??
                    // NewEntryField(
                    //     'Are you open to moving?',
                    //     blackColor,
                    //     TextInputType.text,
                    //     openToMoving,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // religous level
                    // Card(
                    //   elevation: 1,
                    //   color: greenBackgroundColor,
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20)),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 105,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12),
                    //       color: greenBackgroundColor,
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(16.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const Text(
                    //             'Religious Level',
                    //             style: TextStyle(
                    //               color: blackColor,
                    //               fontWeight: FontWeight.w100,
                    //               fontSize: 14,
                    //             ),
                    //           ),
                    //           DropdownButton(
                    //             borderRadius: BorderRadius.circular(12),
                    //             alignment: Alignment.center,
                    //             enableFeedback: true,
                    //             underline: const Divider(
                    //               color: blackColor,
                    //               thickness: 1.5,
                    //             ),
                    //             dropdownColor: greenBackgroundColor,
                    //             iconEnabledColor: blackColor,
                    //             hint:
                    //                 // seeking == null
                    //                 //     ? Text('Dropdown')
                    //                 //     :
                    //                 Padding(
                    //               padding: const EdgeInsets.only(
                    //                   left: 8.0, bottom: 12.0),
                    //               child: Text(religionLevel,
                    //                   style: const TextStyle(
                    //                     color: blackColor,
                    //                     fontWeight: FontWeight.w400,
                    //                     fontFamily: 'CaviarDreams',
                    //                   )),
                    //             ),
                    //             isExpanded: true,
                    //             iconSize: 30.0,
                    //             style: const TextStyle(
                    //               color: blackColor,
                    //               fontFamily: 'CaviarDreams',
                    //             ),
                    //             items: [
                    //               "R0 - Not Religious (eats, doesn't pray, no Shabbat)",
                    //               "R1 - Regular religious- eats out dairy, Observes Shabbat",
                    //               "R2 - Doesn't eat out. Keeps kosher and Shabbat ",
                    //               "R3 - Girl wears skirts (boy who wants girl in skirts",
                    //               "RW - Girl skirts & cover hair - looking for working boy who wants skirts/hair and has a set learning schedule",
                    //               "RL - girl skirts & cover hair - looking for learning boy who wants skirts/ hair",
                    //             ].map(
                    //               (val) {
                    //                 return DropdownMenuItem<String>(
                    //                   value: val,
                    //                   child: Text(val),
                    //                 );
                    //               },
                    //             ).toList(),
                    //             onChanged: (String? val) {
                    //               setState(
                    //                 () {
                    //                   religionLevel = val!;
                    //                 },
                    //               );
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // //  School
                    // NewEntryField(
                    //     'Schools Attended',
                    //     blackColor,
                    //     TextInputType.text,
                    //     school,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     4,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // work?
                    // NewEntryField(
                    //     'Work',
                    //     blackColor,
                    //     TextInputType.text,
                    //     work,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     4,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // //  hobbies
                    // NewEntryField(
                    //     'Hobbies,free time,talents',
                    //     blackColor,
                    //     TextInputType.text,
                    //     hobbies,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     4,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // references
                    // const Text(
                    //   "2 References",
                    //   style: TextStyle(
                    //       fontSize: 14,
                    //       color:blackColor,
                    //       fontWeight: FontWeight.w400),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: NewEntryField(
                    //           'Name',
                    //           blackColor,
                    //           TextInputType.text,
                    //           frefName,
                    //           false,
                    //           Icons.mail,
                    //           Colors.transparent,
                    //           blackColor,
                    //           false,
                    //           1,
                    //           1),
                    //     ),
                    //     Expanded(
                    //       child: NewEntryField(
                    //           'Phone Number',
                    //           blackColor,
                    //           TextInputType.text,
                    //           frefPhone,
                    //           false,
                    //           Icons.mail,
                    //           Colors.transparent,
                    //           blackColor,
                    //           false,
                    //           1,
                    //           1),
                    //     ),
                    //     Expanded(
                    //       child: NewEntryField(
                    //           'Relation',
                    //           blackColor,
                    //           TextInputType.text,
                    //           frefRelation,
                    //           false,
                    //           Icons.mail,
                    //           Colors.transparent,
                    //           blackColor,
                    //           false,
                    //           1,
                    //           1),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: NewEntryField(
                    //           'Name',
                    //           blackColor,
                    //           TextInputType.text,
                    //           lrefName,
                    //           false,
                    //           Icons.mail,
                    //           Colors.transparent,
                    //           blackColor,
                    //           false,
                    //           1,
                    //           1),
                    //     ),
                    //     Expanded(
                    //       child: NewEntryField(
                    //           'Phone Number',
                    //           blackColor,
                    //           TextInputType.text,
                    //           lrefPhone,
                    //           false,
                    //           Icons.mail,
                    //           Colors.transparent,
                    //           blackColor,
                    //           false,
                    //           1,
                    //           1),
                    //     ),
                    //     Expanded(
                    //       child: NewEntryField(
                    //           'Relation',
                    //           blackColor,
                    //           TextInputType.text,
                    //           lrefRelation,
                    //           false,
                    //           Icons.mail,
                    //           Colors.transparent,
                    //           blackColor,
                    //           false,
                    //           1,
                    //           1),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // //  about
                    // NewEntryField(
                    //     'Describe Yourself in 4 words',
                    //     blackColor,
                    //     TextInputType.text,
                    //     about,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // lookingFor
                    // NewEntryField(
                    //     'what are you looking for',
                    //     blackColor,
                    //     TextInputType.text,
                    //     lookingFor,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // //  Cohen
                    // if (gender == "male")
                    //   Card(
                    //     elevation: 0,
                    //     color: greenBackgroundColor,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)),
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 95,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(12),
                    //         color: greenBackgroundColor,
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             const Text(
                    //               'Are You COHEN ?',
                    //               style: TextStyle(
                    //                 color: blackColor,
                    //                 // fontWeight: FontWeight.bold,
                    //                 fontSize: 16,
                    //               ),
                    //             ),
                    //             DropdownButton(
                    //               borderRadius: BorderRadius.circular(12),
                    //               alignment: Alignment.center,
                    //               enableFeedback: true,
                    //               underline: const Divider(
                    //                 color: blackColor,
                    //                 thickness: 3,
                    //               ),
                    //               dropdownColor: greenBackgroundColor,
                    //               iconEnabledColor: blackColor,
                    //               hint:
                    //                   // seeking == null
                    //                   //     ? Text('Dropdown')
                    //                   //     :
                    //                   Padding(
                    //                 padding: const EdgeInsets.only(
                    //                     left: 8.0, bottom: 12.0),
                    //                 child: Text(cohenValue,
                    //                     style: const TextStyle(
                    //                       color: blackColor,
                    //                       fontWeight: FontWeight.w500,
                    //                       fontFamily: 'CaviarDreams',
                    //                     )),
                    //               ),
                    //               isExpanded: true,
                    //               iconSize: 30.0,
                    //               style: const TextStyle(
                    //                 color: blackColor,
                    //                 fontFamily: 'CaviarDreams',
                    //               ),
                    //               items: [
                    //                 'Yes',
                    //                 'No',
                    //               ].map(
                    //                 (val) {
                    //                   return DropdownMenuItem<String>(
                    //                     value: val,
                    //                     child: Text(val),
                    //                   );
                    //                 },
                    //               ).toList(),
                    //               onChanged: (String? val) {
                    //                 if (val != null) {
                    //                   setState(
                    //                     () {
                    //                       cohenValue = val;
                    //                       cohen = val == "Yes" ? true : false;
                    //                     },
                    //                   );
                    //                 }
                    //               },
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // Card(
                    //   elevation: 0,
                    //   color: greenBackgroundColor,
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20)),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 95,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12),
                    //       color: greenBackgroundColor,
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           const Text(
                    //             'What is your maritial status ?',
                    //             style: TextStyle(
                    //               color: blackColor,
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 16,
                    //             ),
                    //           ),
                    //           DropdownButton(
                    //             borderRadius: BorderRadius.circular(12),
                    //             alignment: Alignment.center,
                    //             enableFeedback: true,
                    //             underline: const Divider(
                    //               color: blackColor,
                    //               thickness: 3,
                    //             ),
                    //             dropdownColor: greenBackgroundColor,
                    //             iconEnabledColor: blackColor,
                    //             hint:
                    //                 // seeking == null
                    //                 //     ? Text('Dropdown')
                    //                 //     :
                    //                 Padding(
                    //               padding: const EdgeInsets.only(
                    //                   left: 8.0, bottom: 12.0),
                    //               child: Text(maritialStatus,
                    //                   style: const TextStyle(
                    //                     color: blackColor,
                    //                     fontWeight: FontWeight.w500,
                    //                     fontFamily: 'CaviarDreams',
                    //                   )),
                    //             ),
                    //             isExpanded: true,
                    //             iconSize: 30.0,
                    //             style: const TextStyle(
                    //               color: blackColor,
                    //               fontFamily: 'CaviarDreams',
                    //             ),
                    //             items: [
                    //               'Single',
                    //               'Divorced',
                    //               'Widowed',
                    //             ].map(
                    //               (val) {
                    //                 return DropdownMenuItem<String>(
                    //                   value: val,
                    //                   child: Text(val),
                    //                 );
                    //               },
                    //             ).toList(),
                    //             onChanged: (String? val) {
                    //               if (val != null) {
                    //                 setState(
                    //                   () {
                    //                     maritialStatus = val;
                    //                   },
                    //                 );
                    //               }
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // // lottery
                    // NewEntryField(
                    //     'If you won the lottery, what would you do and your priorities ?',
                    //     blackColor,
                    //     TextInputType.text,
                    //     lottery,
                    //     false,
                    //     Icons.mail,
                    //     Colors.transparent,
                    //     blackColor,
                    //     false,
                    //     1,
                    //     1),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonIconLess('Save', blackColor, blackColor, whiteColor,
                        1.3, 18, 17, next),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
