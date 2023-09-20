import 'package:app/screens/admin/app_user.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  bool loading = false;
  List<String> users = [];
  List<bool> status = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loading = true;
      });
      List<String> u = [];
      List<bool> s = [];
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('getUsersForAdmin');
      final results = await callable();
      if (results.data != 'error') {
        List<dynamic> data = results.data;
        for (var element in data) {
          if (element['uid'] != user.uid) {
            u.add(element['uid'].toString());
            s.add(element['disabled']);
          }
        }
        setState(() {
          users = u;
          status = s;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        Constants.showMessage(context, "Error, please try again later");
      }
    }
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
  abc () {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: CustomAppBar(getBackButton(), "Application Users", const [],),
          preferredSize: Size(MediaQuery.of(context).size.width, appBarHeight),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return AppUser(users[index], status[index],false);
                },
              ),
      ),
    );
  }
}
