import 'package:flutter/material.dart';

class ReviewDetailContainer extends StatefulWidget {
  final String url;
  const ReviewDetailContainer(this.url, {Key? key}) : super(key: key);

  @override
  _ReviewDetailContainerState createState() => _ReviewDetailContainerState();
}

class _ReviewDetailContainerState extends State<ReviewDetailContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 6, bottom: 6),
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.deepPurple),
          image: DecorationImage(
            image: NetworkImage(widget.url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
