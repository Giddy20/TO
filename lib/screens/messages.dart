import 'package:flutter/material.dart';
import 'package:app/constants.dart';
import 'package:app/screens/premier_league.dart';
import 'package:app/widgets/messages_list_tile.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  goToPremierLeague() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const PremierLeague();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const Icon(Icons.menu, color: blackColor),
          title: const Text(
            'MESSAGES',
            style: TextStyle(color: blackColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
             const SizedBox(height: 15),
             const Align(
                alignment: Alignment.centerLeft,
                child: Text('Groups for upcoming events',
                    style: TextStyle(
                        color: goldColor, fontWeight: FontWeight.bold)),
              ),
              GestureDetector(
                onTap: goToPremierLeague,
                child: const MessagesListTile('Premier League Final',
                    "Ken:I don't like Arsenal Loll ", 'assets/pic.jpg'),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('    Chat',
                    style: TextStyle(
                        color: goldColor, fontWeight: FontWeight.bold)),
              ),
              const MessagesListTile('Kevin Anderson', "Let's hangout this weekend ",
                  'assets/profile_pic.jpg'),
              const MessagesListTile(
                  'Joseph Simmons',
                  "Yes that movie was great. I\nwill see it again ",
                  'assets/pic1.jpg'),
              const MessagesListTile(
                  'Samuel payne', "I Like Long drives", 'assets/pic2.jpg'),
              const MessagesListTile('Matthew Hawkins', "Let's hangout this weekend ",
                  'assets/pic1.jpg'),
              const MessagesListTile('Joshua Herrera', "Let's hangout this weekend ",
                  'assets/pic2.jpg'),
              const MessagesListTile('Kevin Anderson', "Let's hangout this weekend ",
                  'assets/pic1.jpg'),
              const MessagesListTile('Kevin Anderson', "Let's hangout this weekend ",
                  'assets/pic2.jpg'),
              const MessagesListTile('Kevin Anderson', "Let's hangout this weekend ",
                  'assets/pic1.jpg'),
            ],
          ),
        ));
  }
}
