// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/screens/approval.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/maps/google_map_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  TextEditingController iLiveInController = TextEditingController();

  String locationMessage = "Getting location ...";
  bool loading = false;
  double lat = 0;
  double lng = 0;
  String location = '';
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    setState(() {
      loading = true;
    });
    String locationData = await Constants.getLocation();
    if (locationData != "0-0") {
      List<String> location = locationData.split(":");
      lat = double.tryParse(location[0]) ?? 0;
      lng = double.tryParse(location[1]) ?? 0;
      setState(() {
        loading = false;
        locationMessage = "Located. Please tap on next to continue";
      });
    } else {
      setState(() {
        loading = false;
      });
      Constants.showMessage(
          context, "Please allow location in settings to proceed");
    }
  }

  void next() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && lat != 0 && lng != 0 && location.isNotEmpty) {
      setState(() {
        locationMessage = "Saving location ...";
      });
      FirebaseFirestore.instance.collection("profile").doc(user.uid).set({
        'location': {'lat': lat, 'lng': lng},
        'locationText': location
      }, SetOptions(merge: true)).then((value) async {
        SharedPreferences prefs = await Constants.getPrefs();
        prefs.setString(
          'locationText',
          location,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return const Approval();
            },
          ),
        );
      }).catchError((onError) {
        log(onError.toString());
      });
    } else {
      Constants.showMessage(context, "Please enter your location");
    }
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
    setState(() {
      location = loc;
      lat = lt;
      lng = lg;
    });
  }

  goToApproval() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Approval();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greenBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: whiteColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Image.asset('assets/logo.png'),
                        ),
                        const Text(
                          'PLEASE LET US KNOW WHERE YOU LIVE',
                          style: TextStyle(color: whiteColor, fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: openMap,
                          child: const Icon(
                            Icons.pin_drop_outlined,
                            size: 120,
                            color: lightGoldColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            if (location.isNotEmpty)
                              Text("Located: " + location,
                                  style: const TextStyle(
                                      color: lightGoldColor, fontSize: 18)),
                            if (location.isEmpty)
                              const Text("Press on Icon for Location",
                                  style: TextStyle(
                                      color: lightGoldColor, fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                    ButtonIconLess('CONTINUE', whiteColor, whiteColor,
                        whiteColor, 1.3, 14, 17, next),
                  ]),
            )));
  }
}
