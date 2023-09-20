// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/models/user_profile.dart';
import 'package:app/widgets/review_detail_container.dart';
import 'package:app/widgets/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';

class ReviewAbout extends StatefulWidget {
  final UserProfile up;
  final bool status;
  final bool show; 
  const ReviewAbout(this.up, this.status, this.show, {Key? key}) : super(key: key);

  @override
  _ReviewAboutState createState() => _ReviewAboutState();
}

class _ReviewAboutState extends State<ReviewAbout> {
  bool loading = false;
  List<String> urls = [];
//  List<String> matches = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getUrls();
  }

  void getUrls() async {
    setState(() {
      loading = true;
    });
    List<String> ur = [];
    await FirebaseFirestore.instance
        .collection('UserMediaFiles')
        .where('userID', isEqualTo: widget.up.userID)
        .limit(4)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
        ur.add(doc.data()['url']);
      }
      setState(() {
        urls = ur;
        loading = false;
      });
    }).catchError((onError) {
      log(onError);
    });
  }

  void goBack() {
    Navigator.of(context).pop();
  }

  Widget getBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: goBack,
      color: Colors.white,
    );
  }

  List<Widget> getButton() {
    List<Widget> buttons = [];
    if (widget.show) {
      buttons.add(
        Row(children: const [
              Icon(Icons.check, color: whiteColor,), 
              Text("ACCEPT", style: TextStyle(color: whiteColor, fontSize: 14),),
              SizedBox(width: 05,),
              Icon(Icons.cancel, color: whiteColor,), 
              Text("REJECT", style: TextStyle(color: whiteColor, fontSize: 14),),
              SizedBox(width: 10,)
            ],)
      );
    } else {
      [];
    }
    return buttons;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,       
        appBar: 
         PreferredSize(
          child: CustomAppBar(getBackButton(),
              "Review ${widget.up.firstName} ${widget.up.lastName}", getButton(),),
          preferredSize: Size(MediaQuery.of(context).size.width, appBarHeight),
        ),               
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.8,
                    child: GridView.builder(
                      itemCount: urls.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return ReviewDetailContainer(urls[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${widget.up.firstName} ${widget.up.lastName}",
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                  Text(
                    widget.up.locationText,
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                  Text(
                    'DOB: ${Constants.stringFromTimestamp(widget.up.dob, 'justDate')}',
                    style: const TextStyle(color: Colors.deepPurple),
                  ),
                  // const Text(
                  //   'kenedwards@gmail.com',
                  //   style: TextStyle(color: Colors.deepPurple),
                  // ),
                  const SizedBox(height: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender: ',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.up.gender,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                        ),
                      )
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'About: ',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.up.about,
                            style: const TextStyle(color: Colors.deepPurple)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Interests: ',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          Constants.listToString(widget.up.interests),
                          style: const TextStyle(
                            color: Colors.deepPurple,
                          ),
                        ),
                      )
                    ],
                  ),
                  // if (widget.show == false)
                  // TextButton.icon(
                  //   onPressed: showMatches,
                  //   icon: const Icon(
                  //     Icons.favorite,
                  //     color: purpleColor,
                  //   ),
                  //   label: const Text(
                  //     "THEIR MATCHES",
                  //     style: TextStyle(
                  //       color: purpleColor,
                  //       decoration: TextDecoration.underline,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 10,),
                  const Text("Phone Number", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.phoneNo),
                  const SizedBox(height: 5,),
                  const Text("Height", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.height),
                  const SizedBox(height: 5,),
                  const Text("Father Name", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.fatherName),
                  const SizedBox(height: 5,),
                  const Text("Mother Name", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.motherName),
                  const SizedBox(height: 5,),
                  const Text("MoM's Maiden", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.momsMaiden),
                  const SizedBox(height: 5,),
                  const Text("Parents Marriage", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.parentsMarriage),
                  const SizedBox(height: 5,),
                  const Text("Siblings", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.siblings),
                  const Text("RabbiShul", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.rabbiShul),
                  const SizedBox(height: 5,),                 
                  const Text("Address", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.address),
                  const SizedBox(height: 5,),                 
                  const Text("Open To Moving", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.openToMoving),
                  const SizedBox(height: 5,),                
                  const Text("Religious Level", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.religiousLevel),               
                  const Text("School", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.school),
                  const SizedBox(height: 5,),                  
                  const Text("Work", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.work),
                  const Text("Hobbies", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.hobbies),
                  const SizedBox(height: 5,),                 
                  const Text("Reference Name", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.firstName),
                  const SizedBox(height: 5,),                 
                  const Text("Reference Phone", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.firstRefPhone),
                  const SizedBox(height: 5,),                
                  const Text("Reference Relation", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.firstRefRelation,),
                  const Text("Reference Name", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.lastRefName,),
                  const Text("Reference Phone", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.lastRefPhone,),
                  const SizedBox(height: 5,),                 
                  const Text("Reference Relation", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.lastRefRelation,),
                  const SizedBox(height: 5,),                 
                  const Text("looking For", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.lookingFor,),
                  const SizedBox(height: 5,),                
                  const Text("Lottery", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.lottery,),
                  const SizedBox(height: 5,),                
                  
                  const Text("Maritial Status", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.lottery,),

                  const SizedBox(height: 5,),                
                  const Text("Cohen", style: TextStyle(color: goldColor),),
                  const SizedBox(height: 5,),
                  UserInfoTile(widget.up.lottery,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
