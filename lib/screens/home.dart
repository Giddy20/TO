import 'package:app/screens/get_started.dart';
import 'package:app/screens/my_profile.dart';
import 'package:app/screens/preferences.dart';
import 'package:app/widgets/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/screens/discover.dart';
import 'package:app/screens/messages.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/home_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";
  String profileURL = "";
  String gender = "";
  String location = "";
  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  abc() {}
  goToMessages() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Messages();
    }));
  }

  void logout() {
    FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences? prefs = Constants.prefs;
      prefs!.clear();
      Navigator.of(context).popUntil((route) => route.isFirst);
      await Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) {
        return const GetStarted();
      }));
    }).catchError((onError) {
//      Constants.showMessage(context, "Cannot logout, please try again later");
    });
  }

  goToDiscover() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Discover();
    }));
  }

  void getPrefs() async {
    Functions().checkProfile();
    SharedPreferences prefs = await Constants.getPrefs();
    setState(() {
      name = prefs.getString("firstname") ?? "";
      profileURL = prefs.getString("profileURL") ?? Constants.noImage;
      gender = prefs.getString("gender") ?? "";
      location = prefs.getString("location") ?? "";
      //  dob = prefs.getString("birthDay") ?? "";
    });
  }

  goToPreferences() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Preferences();
    }));
  }

  goToMyProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const MyProfile();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                  ),
                  child: Column(children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(
                        profileURL,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(name,
                        style:
                            const TextStyle(color: whiteColor, fontSize: 18)),
                    Text(location, style: const TextStyle(color: whiteColor)),
                  ])),
              const SizedBox(height: 30),
              HomeListTile(Icons.message, 'MESSAGES', goToMessages),
              HomeListTile(Icons.favorite_outline_outlined,
                  'MEET BEAUTIFUL PEOPLE', goToDiscover),
              HomeListTile(
                  Icons.settings_brightness, 'PREFERENCES', goToPreferences),
              HomeListTile(Icons.edit, 'EDIT PROFILE', goToMyProfile),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: ButtonIconLess('LOGOUT', Colors.purple, Colors.purple,
                Colors.white, 1.3, 18, 17, logout),
          ),
        ],
      ),
    ));
  }
}
