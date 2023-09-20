// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:app/screens/editProfile/edit_info.dart';
import 'package:app/screens/editProfile/edit_myinterest.dart';
import 'package:app/screens/editProfile/edit_profile_add_photo.dart';
import 'package:app/screens/get_started.dart';
import 'package:app/screens/side_nav.dart';
import 'package:app/widgets/maps/google_map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reports extends StatefulWidget {
  String name;

   Reports({Key? key, required this.name}) : super(key: key);

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  bool showFront = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController birthday = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "";
  String profileURL = "";
  String gender = "";
  String location = "";
  String lastName = "";
  //String birthday = "";
  String about = "";
  double lat = 0;
  double lng = 0;
  var formattedDate;
  List<String> interest = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    formattedDate = 'Enter your Date Of Birth';
    DateTime date = Constants.usersDOB;
    currentDate = Constants.usersDOB;
    formattedDate = "${date.day}-${date.month}-${date.year}";
    birthday.text = formattedDate;
    getPrefs();
  }

  TimeOfDay time = TimeOfDay.now();
  DateTime currentDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(DateTime.now().day - 1),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      formattedDate =
      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      birthday.text = formattedDate;
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  void next() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      loading = true;
    });
    if (user != null &&
        subjectController.text.isNotEmpty &&
        reportController.text.isNotEmpty
       ) {
      await FirebaseFirestore.instance.collection("reports").doc(user.uid).set({
        "subject": firstNameController.text,
        "report": lastNameController.text,
      },
          SetOptions(merge: true)).then((value) async {
        // SharedPreferences prefs = await Constants.getPrefs();
        // prefs.setString("firstname", firstNameController.text);
        // prefs.setString("lastName", lastNameController.text);
        // Constants.usersDOB = currentDate;
        // prefs.setString("locationText", location);
        // prefs.setString("about", aboutController.text);
        // prefs.setStringList("myInterest", interest);
        setState(() {
          loading = false;
        });
        //  Navigator.of(context).pop();
      }).catchError((onError) {
        log(onError.toString());
      });
    } else {
      Constants.showMessage(context, "Please fill the required field ");
    }
  }

  void getPrefs() async {
    SharedPreferences prefs = await Constants.getPrefs();
    firstNameController.text = prefs.getString("firstname") ?? "";
    lastNameController.text = prefs.getString("lastname") ?? "";
    aboutController.text = prefs.getString("about") ?? "";
    setState(() {
      profileURL = prefs.getString("profileURL") ?? Constants.noImage;
      location = prefs.getString("locationText") ?? "";
      interest = prefs.getStringList("myInterest") ?? [];
    });
  }

  void goToProfileMyInterests() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const EditMyInterests();
    }));
    getPrefs();
  }


  void goToEditProfileAddPhoto() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const EditProfileAddPhoto();
    }));
  }

  void editQuestions() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const EditInfo();
    }));
    getPrefs();
  }

  void openMap() async {
    if (await Constants.checkLocationPermission(context)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) {
            return GoogleMapPage(setLocation);
          },
        ),
      );
    }
  }

  void setLocation(String loc, double lt, double lg) {
    Navigator.of(context).pop();
    if (loc != "Checking ...") {
      lat = lt;
      lng = lg;
      location = loc;
    }
  }

  String listToString(List<String> list) {
    String result = "";
    for (String s in list) {
      if (result.isNotEmpty) {
        result += ", ";
      }
      result += s;
    }
    return result;
  }

  void deleteMyAccount() {
    FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences? prefs = Constants.prefs;
      prefs!.clear();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        return const GetStarted();
      }), (route) => false);
    }).catchError((onError) {
      Constants.showMessage(context, "Cannot logout, please try again later");
    });
  }

  abc() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer:  SideNav(),
      backgroundColor: greenBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios, color: goldColor),
        ),
        title: Text('Report ${widget.name}', style: TextStyle(color: goldColor)),
      ),
      body: loading
          ? Center(
        child: Column(
          children: const [
            CircularProgressIndicator(
              color: goldColor,
            ),
            Text(
              "Saving the information",
              style: TextStyle(color: goldColor),
            )
          ],
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                border: Border.all(color: redColor)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Free Account.",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Upgrade Now",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          )
                        ],
                      ),
                      */
                const SizedBox(height: 10),
                // edit photos


                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Center(
                    child: Container(
                      //height: MediaQuery.of(context).size.height / 1.6,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              controller: subjectController,
                              style: const TextStyle(color: blackColor),
                              keyboardType: TextInputType.name,
                              cursorColor: blackColor,
                              decoration: InputDecoration(
                                focusColor: blackColor,
                                fillColor: blackColor,
                                hoverColor: blackColor,
                                labelText: "Subject",
                                labelStyle:
                                const TextStyle(color: blackColor),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: blackColor,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: blackColor),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: blackColor),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            const SizedBox(height: 10),

                            TextField(
                              maxLines: 6,
                              textInputAction: TextInputAction.next,
                              autofocus: true,
                              controller: reportController,
                              style: const TextStyle(color: blackColor),
                              keyboardType: TextInputType.name,
                              cursorColor: blackColor,
                              decoration: InputDecoration(
                                focusColor: blackColor,
                                fillColor: blackColor,
                                hoverColor: blackColor,
                                labelText: "Report Details/Reason",
                                labelStyle:
                                const TextStyle(color: blackColor),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: blackColor,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: blackColor),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: blackColor),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ButtonIconLess(
                  'Send report',
                  redColor,
                  redColor,
                  whiteColor,
                  1.3,
                  18,
                  17,
                  next,
                ),
                const SizedBox(height: 50),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
