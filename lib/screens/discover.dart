import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/screens/my_profile.dart';
import 'package:app/screens/preferences.dart';


class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
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

  goToViewProfile() {
    /*
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const ViewProfile();
    }));
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: greenBackgroundColor,
        title: Stack(
          children: [
            Container(
                width: 80,
                decoration: BoxDecoration(
                    color: greenBackgroundColor,
                    borderRadius: BorderRadius.circular(40)),
                child: const Positioned(
                  left: 22,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: whiteColor,
                    child: Text(
                      'We',
                      style: TextStyle(
                          color: whiteColor,
                          fontFamily: 'Aliqa',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: goToMyProfile,
            child: const Icon(Icons.menu, color: whiteColor)),
        actions: const [
          Icon(Icons.message_outlined, color: whiteColor),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height / 1.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: const DecorationImage(
                      image: ExactAssetImage('assets/picmale.jpg'),
                      fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: goToPreferences,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            border: Border.all(color: whiteColor, width: 6),
                            shape: BoxShape.circle),
                        child: GestureDetector(
                          //       onTap: goToMatch,
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: whiteColor,
                            foregroundColor: whiteColor,
                            child: Icon(
                              Icons.settings_backup_restore,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          border: Border.all(color: whiteColor, width: 6),
                          shape: BoxShape.circle),
                      child: GestureDetector(
                        onTap: goToViewProfile,
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: whiteColor,
                          foregroundColor: whiteColor,
                          child: Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      border: Border.all(color: whiteColor, width: 6),
                      shape: BoxShape.circle),
                  child: GestureDetector(
                    //       onTap: goToMatch,
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: whiteColor,
                      foregroundColor: whiteColor,
                      child: Icon(
                        Icons.cancel,
                        color: blackColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      border: Border.all(color: whiteColor, width: 6),
                      shape: BoxShape.circle),
                  child: GestureDetector(
                    //       onTap: goToMatch,
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: whiteColor,
                      foregroundColor: whiteColor,
                      child: Icon(
                        Icons.favorite,
                        color: whiteColor,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          border: Border.all(color: whiteColor, width: 6),
                          shape: BoxShape.circle),
                      child: GestureDetector(
                        //       onTap: goToMatch,
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: whiteColor,
                          foregroundColor: whiteColor,
                          child: Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.purple,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          border: Border.all(color: whiteColor, width: 6),
                          shape: BoxShape.circle),
                      child: GestureDetector(
                        //       onTap: goToMatch,
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: whiteColor,
                          foregroundColor: whiteColor,
                          child: Icon(
                            Icons.message,
                            color: Colors.purple,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
