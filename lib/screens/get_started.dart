import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/sign_up_screens/login.dart';
import 'package:app/sign_up_screens/register.dart';

import 'package:app/widgets/button_icon_less.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  goToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Login();
    }));
  }

  goToRegister() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Register();
    }));
  }

  abc() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: greenBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Align(
                    alignment: Alignment.center,
                    child: Text(
                      'GET TO KNOW PEOPLE VIRTUALLY\n    BEFORE MEETING AT EVENTS',
                      style: TextStyle(color: lightGoldColor, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Image.asset('assets/logo.png'),
                  ),
                  Column(
                    children: [
                      ButtonIconLess(
                        'LOGIN',
                        redColor,
                        redColor,
                        whiteColor,
                        1.4,
                        14,
                        17,
                        goToLogin,
                      ),
                      const SizedBox(height: 20),
                      ButtonIconLess(
                        'REGISTER',
                        redColor,
                        redColor,
                        whiteColor,
                        1.4,
                        14,
                        17,
                        goToRegister,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
