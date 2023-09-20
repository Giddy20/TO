import 'package:flutter/material.dart';


import '../constants.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  List li = ["Show Everyone", "Men", "Women"];
  String seeking = "";
  int _currentSliderValue = 1;
  RangeLabels labels = const RangeLabels('1', "100");
  RangeValues values = const RangeValues(18, 100);

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }

  // void saveProfile() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     int minAge = values.start.toInt();
  //     int maxAge = values.end.toInt();
  //     await FirebaseFirestore.instance.collection("profile").doc(user.uid).set({
  //       'minAge': minAge,
  //       'maxAge': maxAge,
  //       'distance': _currentSliderValue,
  //       'seeking': seeking,
  //       'startMatch': true,
  //     }, SetOptions(merge: true)).then((value) {
  //       Navigator.of(context).pop();
  //       savePrefs();
  //     }).catchError((onError) {});
  //   }
  // }

  // void getData() async {
  //   SharedPreferences prefs = await Constants.getPrefs();
  //   int minAge = prefs.getInt("minAge") ?? 18;
  //   int maxAge = prefs.getInt("maxAge") ?? 100;
  //   RangeValues ageRange = RangeValues(minAge.toDouble(), maxAge.toDouble());
  //   setState(() {
  //     values = ageRange;
  //     _currentSliderValue = prefs.getInt("distance") ?? 100;
  //     seeking = prefs.getString("seeking") ?? "";
  //   });
  // }

  // void savePrefs() async {
  //   SharedPreferences prefs = await Constants.getPrefs();
  //   prefs.setInt("minAge", values.start.toInt());
  //   prefs.setInt("maxAge", values.end.toInt());
  //   prefs.setInt("distance", _currentSliderValue);
  //   prefs.setString("seeking", seeking);
  //   // prefs.setString("phoneNumber", newPhoneNumber);
  // }

  next() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'PREFERENCES',
            style: TextStyle(color: blackColor),
          ),
          iconTheme: const IconThemeData(color: blackColor),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30),
                  child: Column(
                    children: [
                      Card(
                        color: greenBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        child: Container(
                          color: greenBackgroundColor,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "MAXIMUM DISTANCE",
                                    style: TextStyle(color: blackColor),
                                  ),
                                  Text(
                                    _currentSliderValue.toString() + " ml",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: blackColor,
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
                                    activeColor: blackColor,
                                    inactiveColor: whiteColorShade,
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
                        color: greenBackgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        child: Container(
                          color: greenBackgroundColor,
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
                                  height: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: greenBackgroundColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Age Range',
                                              style: TextStyle(
                                                color: blackColor,
                                                //  fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              values.start.toInt().toString() +
                                                  "-" +
                                                  values.end.toInt().toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: blackColor),
                                            )
                                          ],
                                        ),
                                        RangeSlider(
                                          activeColor: blackColor,
                                          inactiveColor:
                                          blackColor.withOpacity(0.3),
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
                      const Text(
                          'These preferences are used by WeSwipe to suggest the best possible matches.Some match suggestions may not fall in these brackets',
                          textAlign: TextAlign.justify)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
