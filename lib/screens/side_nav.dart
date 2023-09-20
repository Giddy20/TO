import 'package:app/constants.dart';
import 'package:app/screens/admin/createGroup/create_group.dart';
import 'package:app/screens/Swipe/discover.dart';
import 'package:app/screens/message/messages.dart';
import 'package:app/screens/my_calendar.dart';
import 'package:app/screens/settings/preferences.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/functions.dart';
import 'package:app/widgets/home_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'get_started.dart';
import 'my_profile.dart';

class SideNav extends StatefulWidget {

  const SideNav({Key? key}) : super(key: key);

  @override
  _SideNavState createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  String name = "";
  String profileURL = "";
  String gender = "";
  String location = "";
  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  goToCalendar() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const MyCalendar();
    }));
  }

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

  void goToPreferences() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Preferences();
    }));
  }

 void goToMyProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const MyProfile();
    }));
  }

  void goToAdmin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const CreateGroup();
    }));
  }
   void goToDiscover() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Discover();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: greenBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mediumSpace(),
                    Align(
                      alignment: Alignment.centerRight,
                        child:IconButton(
                          onPressed: (){
                           Navigator.pop(context);
                          },
                          icon: Icon(Icons.close, color: lightGoldColor,),
                        )
                    ),

                mediumSpace(),

                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        profileURL,
                      ),
                    ),
                  ),
                  smallHSpace(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: GoogleFonts.poppins(color: whiteColor, fontSize: 18, fontWeight: FontWeight.w600)),
                      Text(location, style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5), fontSize: 12)),
                    ],
                  ),
                ]),

        mediumSpace(),
        Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("Menu", style: GoogleFonts.poppins(color: whiteColor, fontSize: 22, fontWeight: FontWeight.w700)),
        ),
        mediumSpace(),
        //         HomeListTile(Icons.home_filled, 'Home',
        //             goToDiscover),
        // HomeListTile(Icons.favorite_outline_outlined, 'Matches',
        //           goToDiscover),
        //         HomeListTile(Icons.message, 'Chat', goToMessages),
                // HomeListTile(Icons.calendar_view_day_rounded, 'CALENDAR', goToCalendar),
                HomeListTile(
                    Icons.tune, 'Preferences', goToPreferences),

                if (Constants.isAdmin()) HomeListTile(Icons.edit, 'ADMIN', goToAdmin),

        // kSpacing,
        //           GestureDetector(
        //             onTap: goToMyProfile,
        //             child: Padding(
        //               padding: const EdgeInsets.only(right: 50),
        //               child: Container(
        //                 height: MediaQuery.of(context).size.height  * 0.06,
        //                 padding: const EdgeInsets.only(left: 0),
        //                 decoration: BoxDecoration(
        //                   gradient:  LinearGradient(
        //                       colors: [
        //                         Color(0xFFD7C299), Color(0xFF9F7632)
        //                       ],
        //                       stops: [0.0, 1.0],
        //                       begin: FractionalOffset.centerLeft,
        //                       end: FractionalOffset.centerRight,
        //                       tileMode: TileMode.repeated
        //                   ),
        //                   borderRadius: const BorderRadius.all(Radius.circular(12)),
        //                 ),
        //                 child: ListTile(
        //                   leading: Icon(Icons.person_2_outlined, color: whiteColor),
        //                   title: Text("Profile", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: whiteColor),),
        //                 ),
        //               ),
        //             ),
        //           ),
      ],
    ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: logout,
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: lightGoldColor, size: 24,),
                        tinyHSpace(),
                        Text("Log Out",
                        style: GoogleFonts.poppins(color: lightGoldColor, fontSize: 17, fontWeight: FontWeight.w600),),
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
        ));
  }
}
