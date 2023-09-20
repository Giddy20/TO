import 'package:app/constants.dart';
import 'package:app/screens/admin/all_groups.dart';
import 'package:app/screens/admin/all_users.dart';
import 'package:app/screens/admin/createGroup/create_group.dart';
import 'package:app/screens/admin/review_new_profile.dart';
import 'package:app/screens/Swipe/discover.dart';
import 'package:app/screens/views.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/functions.dart';
import 'package:app/widgets/home_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../get_started.dart';
import '../my_profile.dart';

class AdminSideNav extends StatefulWidget {
  const AdminSideNav({Key? key}) : super(key: key);

  @override
  _AdminSideNavState createState() => _AdminSideNavState();
}

class _AdminSideNavState extends State<AdminSideNav> {
  String name = "";
  String profileURL = "";
  String gender = "";
  String location = "";

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  void goToReview() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const ReviewNewProfile();
    }));
  }

  void goToDiscover() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Views();
    }));
  }

  void goToCreateGroup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const CreateGroup();
    }));
  }

  void goToMyProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const MyProfile();
    }));
  }

  void goToGroups() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const AllGroups();
    }));
  }

  void goToUsers() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const AllUsers();
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

  void getPrefs() async {
    Functions().checkProfile();
    SharedPreferences prefs = await Constants.getPrefs();
    setState(() {
      name = prefs.getString("firstname") ?? "";
      profileURL = prefs.getString("profileURL") ?? Constants.noImage;
      gender = prefs.getString("gender") ?? "";
      location = prefs.getString("locationText") ?? "";
      //  dob = prefs.getString("birthDay") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
          child: ListView(
        children: [
          Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: goldColor,
              ),
              child: Column(children: const [
                SizedBox(height: 40),
                CircleAvatar(
                  backgroundColor: whiteColor,
                  radius: 50,
                  child: CircleAvatar(
                      backgroundColor: goldColor,
                      radius: 49,
                      child: Icon(Icons.shield_sharp)
                      //SvgPicture.asset('assets/adminLogo.svg'),
                      ),
                ),
                SizedBox(height: 20),
                Text(
                  "APPLICATION ADMIN",
                  style: TextStyle(color: whiteColor, fontSize: 18),
                ),
              ])),
          const SizedBox(height: 30),
          HomeListTile(Icons.add_task, 'REVIEW NEW PROFILES', goToReview),
          HomeListTile(Icons.add_box, 'CREATE GROUPS FOR UPCOMING EVENTS',
              goToCreateGroup),
          HomeListTile(Icons.group, 'ALL GROUPS', goToGroups),
          HomeListTile(Icons.person, 'APPLICATION USERS', goToUsers),
          HomeListTile(Icons.person, 'Leave Admin Dashboard', goToDiscover),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 90, horizontal: 30),
            child: ButtonIconLess('LOG OUT', goldColor, goldColor,
                Colors.white, 1.3, 18, 17, logout),
          ),
        ],
      )),
    );
  }
}
