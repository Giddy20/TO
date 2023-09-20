import 'package:app/sign_up_screens/agreement.dart';
import 'package:app/widgets/check_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/profile/user_personal_details.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/new_entry_field.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool agreement = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  goToUserPersonalDetails() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const UserPersonalDetails();
    }));
  }

  void signUp() async {
    if (passController.text == confirmPassController.text) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passController.text)
            .then((value) {
          {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) {
              return const CheckProfile();
            }), (route) => route.isFirst);
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "email-already-in-use") {
          showMessage("Email Already In Use");
        } else if (e.code == "invalid-email") {
          showMessage("Invalid Email");
        } else if (e.code == "invalid-password") {
          showMessage("Invalid Password");
        } else if (passController.text != confirmPassController.text) {
          showMessage("Password does not match");
        } else {
          showMessage("Invalid Input");
        }
      } catch (e) {}
    } else {
      showMessage("Password does not match");
    }
  }

  goToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Login();
    }));
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showAgreement() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_){
      return const Agreement();
    }));

  }

  abc() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
        title: Text("Sign up",
          style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 22),),
      ),
      backgroundColor: greenBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: greenBackgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Create Account",
                            style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 29),),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Please sign up to continue...",
                            style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5),  fontSize: 18),),
                        ),
                        kLargeSpacing,
                        kLargeSpacing,
                        subText("Email"),
                        NewEntryField(
                          label:'Enter Email',
                          prefix: Icon(Icons.email_outlined, color:  lightGoldColor,),
                          textInputType: TextInputType.emailAddress,
                          controller: emailController,),
                        kSpacing,
                        subText('Password'),
                        NewEntryField(
                          label:'Enter Password',
                          obscure: true,
                          prefix:  Icon(Icons.lock_outline_rounded, color:  lightGoldColor,),
                          icon: Icons.remove_red_eye_outlined,
                          textInputType: TextInputType.text,
                          controller: passController,),
                        kSpacing,
                        subText('Confirm Password'),
                        NewEntryField(
                          label:'Enter Password',
                          obscure: true,
                          prefix:  Icon(Icons.lock_outline_rounded, color:  lightGoldColor,),
                          icon: Icons.remove_red_eye_outlined,
                          textInputType: TextInputType.text,
                          controller: confirmPassController,),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                                value: agreement,
                              side: BorderSide(color: whiteColor),
                              activeColor: lightGoldColor,
                                onChanged: ((value) {
                                  setState(() {
                                    agreement = value!;
                                  });
                                }
                            ),
                            ),
                            Expanded(
                              child: Text("I have read and agreed to the terms & conditions",
                                style: GoogleFonts.poppins( color:lightGoldColor,
                                decoration: TextDecoration.underline)
                                ),
                            ),
                          ],
                        ),
                        kLargeSpacing,
                        if (agreement)
                          ButtonIconLess(
                            'REGISTER',
                            redColor,
                            redColor,
                            whiteColor,
                            1.3,
                            18,
                            17,
                            signUp,
                          )
                        else
                          ButtonIconLess(
                            'SHOW TERMS & CONDITIONS',
                            redColor,
                            redColor,
                            whiteColor,
                            1.3,
                            18,
                            17,
                            showAgreement,
                          )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already a user?",
                          style: GoogleFonts.poppins(color: whiteColor, fontSize: 18),),
                        GestureDetector(
                          onTap: goToLogin,
                          child: Text("Log In",
                            style: GoogleFonts.poppins(color: lightGoldColor, fontSize: 18),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
