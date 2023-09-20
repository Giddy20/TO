// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:app/constants.dart';
import 'package:flutter/material.dart';


class AddPhotoGridScreen extends StatefulWidget {
  final List<String> profileURL;
  final function;
  const AddPhotoGridScreen(this.profileURL, this.function, {Key? key})
      : super(key: key);

  @override
  _AddPhotoGridScreenState createState() => _AddPhotoGridScreenState();
}

class _AddPhotoGridScreenState extends State<AddPhotoGridScreen> {
  void abc() {}
  List images = [
    'assets/femalepic1.jpg',
    'assets/femalepic8.jpg',
    'assets/femalepic13.jpg',
    'assets/femalepic13.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    final double itemHeight =
        (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 3.20;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    return Padding(
      padding: const EdgeInsets.all(16),
      child:
       GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: (itemWidth/ itemHeight),
          children: 
            List.generate(widget.profileURL.length, (index) {
              return GestureDetector(
                child: widget.profileURL[index].isEmpty ?
                Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        // image: const DecorationImage(
                        //  image: ExactAssetImage('assets/placeHolder.png'),
                        //   fit: BoxFit.fitHeight,
                        // ),
                        border:
                            Border.all(color: Colors.blueGrey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  //const Text("Please Add Photos"),
                  Positioned(
                      bottom: 15,
                      right: 15,
                      child: GestureDetector(
                        onTap: widget.function,
                        child: const Icon(
                          Icons.add_circle_outline_outlined,
                          size: 35,
                          color: goldColor,
                        ),
                      ),
                    ),
                  
                ]) :
                Stack(
                  children: [
                  if (widget.profileURL.isNotEmpty) 
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        image: DecorationImage(
                          image: NetworkImage(widget.profileURL[index]),
                          fit: BoxFit.cover,
                        ),
                        border:
                            Border.all(color: Colors.blueGrey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  Positioned(
                      bottom: 15,
                      right: 15,
                      child: GestureDetector(
                        onTap: widget.function,
                        child: const Icon(
                          Icons.add_circle_outline_outlined,
                          size: 35,
                          color: goldColor,
                        ),
                      ),
                    ),
                  
                ]),
              );
            })
          ,
          ),
      );
  }
}
