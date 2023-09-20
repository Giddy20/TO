import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/screens/get_started.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GetStarted()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greenBackgroundColor,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 3,
            decoration: const BoxDecoration(
              color: greenBackgroundColor,
            ),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200,
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
        ));
  }
}
