import 'package:app/constants.dart';
import 'package:app/screens/admin/review_new_profile.dart';
import 'package:app/screens/admin/admin_side_nav.dart';
import 'package:app/widgets/button_icon_less.dart';
import 'package:app/widgets/review_detail_container.dart';
import 'package:flutter/material.dart';

class ReviewProfileDetails extends StatefulWidget {
  const ReviewProfileDetails({Key? key}) : super(key: key);

  @override
  _ReviewProfileDetailsState createState() => _ReviewProfileDetailsState();
}

class _ReviewProfileDetailsState extends State<ReviewProfileDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  abc() {}
  goToAccept() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                'Are you Sure you want to Accept Ken Edwards?',
                style: TextStyle(color: Colors.deepPurple, fontSize: 14),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonIconLess('YES', Colors.deepPurple, Colors.deepPurple,
                      whiteColor, 3.5, 23, 16, abc),
                  ButtonIconLess('NO', Colors.deepPurple, Colors.deepPurple,
                      whiteColor, 3.5, 23, 16, abc)
                ],
              ));
        });
  }

  void  goToReviewProfile() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const ReviewNewProfile();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: const AdminSideNav(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 16,
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: goToReviewProfile,
                        child: const Icon(Icons.arrow_back, color: whiteColor),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Review Ken Edwards',
                        style: TextStyle(
                            color: whiteColor, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                      onPressed: goToAccept,
                      icon: const Icon(
                        Icons.check,
                        color: Colors.deepPurple,
                      ),
                      label: const Text(
                        'ACCEPT',
                        style: TextStyle(color: Colors.deepPurple),
                      )),
                  TextButton.icon(
                      onPressed: goToAccept,
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.deepPurple,
                      ),
                      label: const Text(
                        'REJECT',
                        style: TextStyle(color: Colors.deepPurple),
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ReviewDetailContainer(""),
                  ReviewDetailContainer(""),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ReviewDetailContainer(""),
                  ReviewDetailContainer(""),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'ken Edwards',
                style: TextStyle(color: Colors.deepPurple),
              ),
              const Text(
                'London, UK',
                style: TextStyle(color: Colors.deepPurple),
              ),
              const Text(
                'DOB: 2/11/1996',
                style: TextStyle(color: Colors.deepPurple),
              ),
              const Text(
                'kenedwards@gmail.com',
                style: TextStyle(color: Colors.deepPurple),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Gender:',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Male',
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  )
                ],
              ),
              RichText(
                text: const TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'About:',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'I am an entrepreneur liviing in London. I\n have a textile business. I am here to join \ngroups for events where I can socialize',
                        style: TextStyle(color: Colors.deepPurple)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Interests:',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Gym, Music',
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  )
                ],
              ),
            ]),
          ),
        )));
  }
}
