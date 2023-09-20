import 'package:flutter/material.dart';
import 'package:app/constants.dart';

class MembersListTile extends StatefulWidget {
  final String text;
  final String image;
  const MembersListTile(this.text, this.image, {Key? key}) : super(key: key);

  @override
  _MembersListTileState createState() => _MembersListTileState();
}

class _MembersListTileState extends State<MembersListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 27,
          child: CircleAvatar(
              radius: 25, backgroundImage: ExactAssetImage(widget.image)),
        ),
        title: Text(
          widget.text,
          style: const TextStyle(color: whiteColor),
        ),
      ),
    );
  }
}
