// ignore_for_file: unnecessary_null_comparison

import 'package:app/constants.dart';
import 'package:app/providers/iap_provider.dart';
import 'package:app/providers/main_providers.dart';
import 'package:app/screens/get_started.dart';
import 'package:app/sign_up_screens/login.dart';
import 'package:app/splashscreen/splashscreen.dart';

import 'package:app/widgets/check_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const MyApp()
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider<MainProvider>(
    //       create: (context) => MainProvider(),
    //     ),
    //     ChangeNotifierProvider<IAPProvider>(
    //       create: (context) => IAPProvider(),
    //     ),
    //   ],
    //   child: const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Future<FirebaseApp> getApp() async {
    await Constants.getPrefs();
    final FirebaseApp initialization = await Firebase.initializeApp();
    return initialization;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T.O',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: getApp(),
        builder: (context, appsnapshot) {
          if (appsnapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.active) {
                  if (userSnapshot.hasData) {
                    User user = userSnapshot.data as User;
                    if (user != null) {
                      return const CheckProfile();
                    } else {
                      return const SplashScreen();
                    }
                  } else {
                    return const SplashScreen();
                  }
                } else {
                  return const GetStarted();
                }
              },
            );
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
