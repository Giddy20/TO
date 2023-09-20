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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_service.dart';
import '../widgets/new_entry_field.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool showFront = true;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController locationController = TextEditingController();
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

  var password = '';

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
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        location != null &&
        aboutController.text.isNotEmpty &&
        interest.isNotEmpty) {
      await FirebaseFirestore.instance.collection("profile").doc(user.uid).set({
        "firstname": firstNameController.text,
        "lastName": lastNameController.text,
        "birthDay": currentDate,
        "locationText": location,
        "about": aboutController.text,
        "myInterest": interest,
      }, SetOptions(merge: true)).then((value) async {
        SharedPreferences prefs = await Constants.getPrefs();
        prefs.setString("firstname", firstNameController.text);
        prefs.setString("lastName", lastNameController.text);
        Constants.usersDOB = currentDate;
        prefs.setString("locationText", location);
        prefs.setString("about", aboutController.text);
        prefs.setStringList("myInterest", interest);
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
    locationController.text = prefs.getString("locationText") ?? "";
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
      // drawer:  SideNav(),
      backgroundColor: greenBackgroundColor,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   // leading: GestureDetector(
      //   //   onTap: () {
      //   //     _scaffoldKey.currentState!.openDrawer();
      //   //   },
      //   //   child:Padding(
      //   //     padding:  EdgeInsets.symmetric(horizontal: 13.0),
      //   //     child: SvgPicture.asset("assets/menu.svg"),
      //   //   ),
      //   // ),
      //   title: Text('Profile', style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.w600)),
      // ),
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

                  child: Column(
                    children: [

                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                color: whiteColor,
                                shape: BoxShape.circle
                            ),
                            child: CircleAvatar(
                              radius: 59,
                              backgroundImage: NetworkImage(
                                profileURL,
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: const BoxDecoration(
                                    color: whiteColor,
                                    shape: BoxShape.circle,
                                  gradient:  LinearGradient(
                                      colors: [
                                        Color(0xFFD7C299), Color(0xFF9F7632)
                                      ],
                                      stops: [0.0, 1.0],
                                      begin: FractionalOffset.centerLeft,
                                      end: FractionalOffset.centerRight,
                                      tileMode: TileMode.repeated
                                  ),
                                ),
                                child: Icon(Icons.add_a_photo_outlined, color: whiteColor, size: 22,)
                              )
                          ),
                        ],
                      ),
                      kLargeSpacing,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Information",
                          style: textStyle(18).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      kSpacing,
                      subText("First Name"),
                      NewEntryField(
                        label: "Enter First Name",
                        textInputType: TextInputType.name,
                        controller: firstNameController,),
                      kSpacing,
                      subText("Last Name"),
                      NewEntryField(
                        label: "Enter Last Name",
                        textInputType: TextInputType.name,
                        controller: lastNameController,),
                      kSpacing,
                      subText("Date of Birth"),
                      tinySpace(),
                      Padding(
                        padding: const EdgeInsets.only(right:0.0),
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
                                    color: lightGoldColor)),
                          ),
                        ),
                      ),
                      kSpacing,
                      subText("Location"),
                      NewEntryField(
                        label: "Enter Location",
                        textInputType: TextInputType.name,
                        controller: locationController,
                      icon: Icons.location_pin,
                      ),
                      kSpacing,
                      subText("About"),
                      NewEntryField(
                        label: "Write here....",
                        textInputType: TextInputType.name,
                        maximumLines: 2,
                        controller: aboutController,),

                      kLargeSpacing,
                      kLargeSpacing,

                      const SizedBox(height: 20),
                      ButtonIconLess(
                        'Update',
                        lightGoldColor,
                        lightGoldColor,
                        whiteColor,
                        1.3,
                        18,
                        17,
                        next,
                      ),
                      const SizedBox(height: 50),
                      TextButton(
                        onPressed: (){
                          Alert(
                            context: context,
                            content: SizedBox(
                              height: 200,
                              child: Column(
                                children: [
                                  const Text("Confirm account Deletion",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  const SizedBox(height: 30,),
                                  const Text("Input your password",
                                    style: TextStyle(
                                        fontSize: 15
                                    ),),
                                  TextField(
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      onChanged: (val){
                                        setState(() {
                                          password = val;
                                        });
                                      }
                                  ),
                                  const SizedBox(height: 10,),

                                  DialogButton(
                                    color: goldColor,
                                    onPressed: () async{
                                      String? email = FirebaseAuth.instance.currentUser?.email;
                                      await AuthService().deleteUser(email!, password).then((value) {
                                        deleteMyAccount();
                                      });
                                    },
                                    child: const Text('Delete',
                                      textAlign: TextAlign.center,
                                      style:  TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            buttons: [
                              DialogButton(
                                color: blackColor,
                                onPressed: () async{
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white, fontSize: 20,  fontWeight: FontWeight.w600),
                                ),
                              ),

                            ],
                          ).show();
                        },
                        child: const Text(
                          "Delete My Account",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
