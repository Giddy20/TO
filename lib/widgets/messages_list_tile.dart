import 'package:flutter/material.dart';


class MessagesListTile extends StatefulWidget {
  final String text;
  final String subtitle;
  final String image;
  const MessagesListTile(this.text, this.subtitle, this.image, {Key? key})
      : super(key: key);

  @override
  _MessagesListTileState createState() => _MessagesListTileState();
}

class _MessagesListTileState extends State<MessagesListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 27,
          child: CircleAvatar(
              radius: 25, backgroundImage: ExactAssetImage(widget.image)),
        ),
        title: Text(widget.text),
        subtitle: Text(widget.subtitle),
        trailing: const Text('08:00 PM'));
  }
}
