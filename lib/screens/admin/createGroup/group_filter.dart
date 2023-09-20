import 'package:app/constants.dart';
import 'package:app/screens/admin/createGroup/create_group.dart';
import 'package:app/screens/admin/createGroup/group_interest.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/new_entry_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupFilters extends StatefulWidget {
  final String groupName;
  final String eventName;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay time;
  final String eventLocation;
  final String price;
  final String iconURL;
  const GroupFilters(this.groupName, this.eventName, this.startDate,
      this.endDate, this.time, this.eventLocation, this.price, this.iconURL,
      {Key? key})
      : super(key: key);

  @override
  _GroupFiltersState createState() => _GroupFiltersState();
}

class _GroupFiltersState extends State<GroupFilters> {
  TextEditingController interestsController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  RangeValues values = const RangeValues(18, 100);
  var currentIndex;
  var cont = false;
  String selectedGender = "";
  int index = 0;
  List<String> interests = [];
  List gender = ['female', 'male', 'Both'];

  void getPrefs() async {
    SharedPreferences prefs = await Constants.adminPrefs();
    setState(() {
      interests = prefs.getStringList("groupInterest") ?? [];
      //    education = prefs.getString("school") ?? "";
      //  dob = prefs.getString("birthDay") ?? "";
    });
  }

  void createGroups() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const CreateGroup();
    }));
  }

  void getList(List<String> ints) {
    interests = ints;
  }

  goToProfileMyInterests() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return GroupInterest(getList);
    }));
    //  getPrefs();
  }

  void saveProfile() async {
    if (selectedGender.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        int minAge = values.start.toInt();
        int maxAge = values.end.toInt();
        await FirebaseFirestore.instance.collection("adminEvent").add({
          'minAge': minAge,
          'maxAge': maxAge,
          'country': countryController.text,
          'city': cityController.text,
          'gender': selectedGender,
          'groupName': widget.groupName,
          'eventName': widget.eventName,
          'startDate': widget.startDate,
          'endDate': widget.endDate,
          'startsAT': widget.startDate,
          'eventLocation': widget.eventLocation,
          'ticketPrice': widget.price,
          'groupInterest': interests,
          'iconURL': widget.iconURL,
        }).then((value) async {
          // final prefs = await SharedPreferences.getInstance();
          // prefs.remove('groupInterest');
          Navigator.of(context).pop();
        }).catchError((onError) {});
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill the empty fields"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 16,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          color: goldColor,
                          borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: createGroups,
                            child:
                                const Icon(Icons.arrow_back, color: whiteColor),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Filters to add people',
                            style: TextStyle(
                                color: whiteColor, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Card(
                  color: lightPurpleColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  margin: EdgeInsets.zero,
                  child: Container(
                    color: lightPurpleColor,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: lightPurpleColor,
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
                                          color: goldColor,
                                          //  fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        values.start.toInt().toString() +
                                            "-" +
                                            values.end.toInt().toString(),
                                        style: const TextStyle(
                                            fontSize: 12, color: goldColor),
                                      )
                                    ],
                                  ),
                                  RangeSlider(
                                    activeColor: goldColor,
                                    inactiveColor: goldColor.withOpacity(0.3),
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
                const SizedBox(height: 30),
                const Text(
                  "Add Interest",
                  style: TextStyle(color: goldColor),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GestureDetector(
                    onTap: goToProfileMyInterests,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(width: 1),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          interests.toString(),
                          style: const TextStyle(color: goldColor),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //   child: NewEntryField(
                //       'Country(optional)',
                //       goldColor,
                //       TextInputType.text,
                //       countryController,
                //       false,
                //       Icons.mail,
                //       Colors.transparent,
                //       goldColor,
                //       false,
                //       1,
                //       1),
                // ),
                // const SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //   child: NewEntryField(
                //       'City(optional)',
                //       goldColor,
                //       TextInputType.text,
                //       cityController,
                //       false,
                //       Icons.mail,
                //       Colors.transparent,
                //       goldColor,
                //       false,
                //       1,
                //       1),
                // ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    const Text(
                      'Gender :',
                      style: TextStyle(color: goldColor, fontSize: 16),
                    ),
                    genders(gender[0], 0),
                    genders(gender[1], 1),
                    genders(gender[2], 2),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ButtonIconLess('CONTINUE', goldColor, goldColor,
                      whiteColor, 1.2, 14, 16, saveProfile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget genders(String text, int index) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 14,
        width: MediaQuery.of(context).size.width / 5,
        decoration: currentIndex == index
            ? BoxDecoration(
                border: Border.all(color: goldColor, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: lightPurpleColor,
              )
            : BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: goldColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
        // ignore: deprecated_member_use
        child: ElevatedButton(
          // color: Colors.transparent,
          // highlightElevation: 0,
          // highlightColor: Colors.white.withOpacity(0.2),
          // shape: const StadiumBorder(),
          onPressed: () {
            setState(() {
              currentIndex = index;
              selectedGender = gender[currentIndex];
              //  print(selectedGender);
              currentIndex == index ? cont = true : cont = false;
            });
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              //fontWeight: FontWeight.bold,
              color: currentIndex == index ? goldColor : goldColor,
              //  letterSpacing: 0.10,
            ),
          ),
        ),
      ),
    );
  }
}
