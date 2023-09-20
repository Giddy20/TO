// ignore_for_file: file_names, use_key_in_widget_constructors, avoid_print

import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/providers/main_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwipeFav extends StatefulWidget {
  final String swipe;
  const SwipeFav(
    this.swipe,
  );

  @override
  _SwipeFavState createState() => _SwipeFavState();
}

class _SwipeFavState extends State<SwipeFav> {
  bool fav = false;
  bool loading = true;
  String favID = "";
  bool cancel = false;

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  void checkStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String docID = Constants.getID(user.uid, widget.swipe);
      await FirebaseFirestore.instance
          .collection('Likes')
          .doc(docID)
          .get()
          .then((doc) {
        if (doc.exists) {
          if (doc.data()![user.uid] == 'confirmed') {
            favID = docID;
            setState(() {
              fav = true;
              loading = false;
            });
          } else {
            favID = '';
            setState(() {
              fav = false;
              loading = false;
            });
          }
        } else {
          favID = '';
          setState(() {
            fav = false;
            loading = false;
          });
        }
      }).catchError((onError) {
        log(onError.toString());
      });
    }
  }

  void nextProfile() {
    setState(() {
      cancel = !cancel;
    });
    Provider.of<MainProvider>(context, listen: false).nextProfile();
  }

  void removeMatch() {
    setState(() {
      cancel = !cancel;
    });
    Provider.of<MainProvider>(context, listen: false).removeMatch();
  }

  void favourite() async {
    if (!fav) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !loading) {
        //String docID = user.uid + widget.swipe.userID;
        setState(() {
          loading = true;
        });
        String id = Constants.getID(user.uid, widget.swipe);
        DocumentReference favRef =
            FirebaseFirestore.instance.collection('Likes').doc(id);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(favRef);
          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            if (data[user.uid] == 'initiated') {
              Map<String, dynamic> dataToSend = {};
              dataToSend[user.uid] = 'confirmed';
              transaction.update(favRef, dataToSend);
            } else {
              throw Exception("error");
            }
          } else {
            Map<String, dynamic> data = {};
            data['users'] = [user.uid, widget.swipe];
            data[user.uid] = 'confirmed';
            data[widget.swipe] = 'initiated';
            data['timestamp'] = FieldValue.serverTimestamp();
            transaction.set(favRef, data);
          }
        }).then((value) {
          setState(() {
            loading = false;
            fav = true;
          });
          nextProfile();
        }).catchError((onError) {
          setState(() {
            loading = false;
          });
          log(onError);
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : GestureDetector(
            //onTap: favourite,
            child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Container(
                              height: 100,
                              width: 100,
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
          );
  }
}
