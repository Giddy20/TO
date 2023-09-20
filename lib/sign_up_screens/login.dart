import 'package:app/sign_up_screens/agreement.dart';
import 'package:app/sign_up_screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/check_profile.dart';
import 'package:app/widgets/new_entry_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool agreement = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  void login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passController.text)
          .then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) {
          return const CheckProfile();
        }), (route) => route.isFirst);
      }).catchError((onError) {
        showMessage("Wrong email or password, please try again");
      });
    } catch (e) {
      showMessage("Wrong email or password, please try again");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  goToRegister() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const Register();
    }));
  }

  void showAgreement() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
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
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Image.asset('assets/logo.png'),
                        ),
                        kLargeSpacing,
                        kSpacing,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Login",
                            style: GoogleFonts.poppins(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 28),),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Please login to continue...",
                            style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.5),  fontSize: 18),),
                        ),
                        kLargeSpacing,
                        Column(children: [
                          subText("Email"),
                          NewEntryField(
                            label:'Email',
                            prefix: Icon(Icons.email_outlined, color:  lightGoldColor,),
                            textInputType: TextInputType.emailAddress,
                            controller: emailController,),
                         kSpacing,
                          subText('Password'),
                          NewEntryField(
                            label:'Password',
                            obscure: true,
                            prefix:  Icon(Icons.lock_outline_rounded, color:  lightGoldColor,),
                            icon: Icons.remove_red_eye_outlined,
                            textInputType: TextInputType.text,
                            controller: passController,),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?",
                    style: GoogleFonts.poppins(color: lightGoldColor, fontSize: 15),),
                ),

                          kSpacing,
                          kLargeSpacing,

                         

                          ButtonIconLess(
                            'LOGIN',
                            redColor,
                            redColor,
                            whiteColor,
                            1.3,
                            18,
                            17,
                            login,
                          )

                      ],
                    ),

                  ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("New User?",
                          style: GoogleFonts.poppins(color: whiteColor, fontSize: 15),),
                        GestureDetector(
                          onTap: goToRegister,
                          child: Text(" Sign up",
                            style: GoogleFonts.poppins(color: lightGoldColor, fontSize: 15),),
                        ),
                      ],
                    ),
                ]
              ),
              ),
          )
            ),
        ),
        ),
      );

  }
}
