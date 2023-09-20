import 'package:flutter/material.dart';
import 'package:app/widgets/members_list_tile.dart';

class PremierLeague extends StatefulWidget {
  const PremierLeague({Key? key}) : super(key: key);

  @override
  _PremierLeagueState createState() => _PremierLeagueState();
}

class _PremierLeagueState extends State<PremierLeague> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.purple),
          backgroundColor: Colors.transparent,
          title: const CircleAvatar(
            radius: 30,
            backgroundImage: ExactAssetImage(
              'assets/pic.jpg',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(children: const [
                        Text('Premier League Final',
                            style:
                                TextStyle(color: Colors.purple, fontSize: 17)),
                        SizedBox(height: 10),
                        Text('Group ',
                            style: TextStyle(
                              color: Colors.grey,
                            )),
                      ])),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('    500 members',
                        style: TextStyle(
                            color: Colors.purple, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  const MembersListTile('Kevin Anderson', 'assets/picmale.jpg'),
                  const MembersListTile(
                      'Joseph Simmons', 'assets/picmale2.jpg'),
                  const MembersListTile(
                      'Mrs. Samuels Payne', 'assets/profile_pic.jpg'),
                  const MembersListTile(
                      'Mrs.Mathew Hawkins', 'assets/pic3.jpg'),
                  const MembersListTile('Joshua Herrera', 'assets/picmale.jpg'),
                  const MembersListTile('Mrs.Daniel Parker', 'assets/pic2.jpg'),
                  const MembersListTile(
                      'Thomas Sanchez', 'assets/profile_pic.jpg'),
                  const MembersListTile('Kevin Anderson', 'assets/pic3.jpg'),
                  const MembersListTile(
                      'Kevin Anderson', 'assets/profile_pic.jpg'),
                ],
              ),
            ],
          ),
        ));
  }
}
