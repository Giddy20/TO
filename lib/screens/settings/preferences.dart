import 'package:app/screens/side_nav.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  List li = ["Men", "Women"];
  String seeking = "";
  int _currentSliderValue = 1;
  RangeLabels labels = const RangeLabels('1', "100");
  RangeValues values = const RangeValues(18, 100);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getData();
  }

  void saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      int minAge = values.start.toInt();
      int maxAge = values.end.toInt();
      await FirebaseFirestore.instance.collection("profile").doc(user.uid).set({
        'minAge': minAge,
        'maxAge': maxAge,
        'distance': _currentSliderValue,
        'startMatch': true,
      }, SetOptions(merge: true)).then((value) {
        Navigator.of(context).pop();
        savePrefs();
      }).catchError((onError) {});
    }
  }

  void getData() async {
    SharedPreferences prefs = await Constants.getPrefs();
    int minAge = prefs.getInt("minAge") ?? 18;
    int maxAge = prefs.getInt("maxAge") ?? 100;
    RangeValues ageRange = RangeValues(minAge.toDouble(), maxAge.toDouble());
    setState(() {
      values = ageRange;
      _currentSliderValue = prefs.getInt("distance") ?? 100;
    });
  }

  void savePrefs() async {
    SharedPreferences prefs = await Constants.getPrefs();
    prefs.setInt("minAge", values.start.toInt());
    prefs.setInt("maxAge", values.end.toInt());
    prefs.setInt("distance", _currentSliderValue);
    // prefs.setString("phoneNumber", newPhoneNumber);
  }

  next() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer:  SideNav(),
        backgroundColor: greenBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Preferences',
            style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
            onTap: () {
             Navigator.pop(context);
            },
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 13.0),
              child: Icon(Icons.arrow_back_ios)
            ),
          ),
          iconTheme: const IconThemeData(color: whiteColor),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
            child: Container(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          color: lightGreenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          child: Container(
                            color: lightGreenColor,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Maximum Distance",
                                      style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5), fontSize: 15),
                                    ),
                                    Text(
                                      _currentSliderValue.toString() + " ml",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: whiteColor.withOpacity(0.5),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Slider(
                                      activeColor: goldColor,
                                      inactiveColor: greenBackgroundColor,
                                      value: _currentSliderValue.toDouble(),
                                      min: 0,
                                      max: 100,
                                      label:
                                          _currentSliderValue.round().toString(),
                                      onChanged: (value) {
                                        setState(() {
                                          _currentSliderValue = value.toInt();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(height: 15),
                        Card(
                          color: lightGreenColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          child: Container(
                            color: lightGreenColor,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: lightGreenColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text(
                                                'Age Range',
                                                style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5), fontSize: 15),
                                              ),
                                              Text(
                                                values.start.toInt().toString() +
                                                    "-" +
                                                    values.end.toInt().toString(),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: whiteColor.withOpacity(0.5)),
                                              )
                                            ],
                                          ),
                                          RangeSlider(
                                            activeColor: goldColor,
                                            inactiveColor: greenBackgroundColor,
                                            min: 18,
                                            max: 100,
                                            values: values,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  values = value;
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                         Text(
                            'These preferences are used by WeSwipe to suggest the best possible matches.Some match suggestions may not fall in these brackets',
                            textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5), fontSize: 16),)
                      ],
                    ),
                  ),
                  ButtonIconLess('Continue', redColor, redColor, whiteColor,
                      1.3, 18, 17, saveProfile),
                ],
              ),
            ),
          ),
        ));
  }
}
