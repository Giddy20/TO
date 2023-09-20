// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PlanSlider extends StatefulWidget {
//  final List<String> photoURL;
  const PlanSlider({Key? key}) : super(key: key);

  @override
  _PlanSliderState createState() => _PlanSliderState();
}

class _PlanSliderState extends State<PlanSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<String> imageList = [
    'assets/pic1.jpg',
    'assets/pic2.jpg',
    'assets/pic3.jpg'
  ];

  List<Widget> getItems() {
    List<Widget> items = [];
    //  widget.photoURL.forEach((element) {
    //   items.add(
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage(imageList[1]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CarouselSlider(
            // items: imageSliders(context),
            carouselController: _controller,
            options: CarouselOptions(
                viewportFraction: 1,
                height: 500,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: getItems(),
          ),
        ),
      ],
    );
  }
}

/* List<Widget> imageSliders(BuildContext context) {
  return Constants.forSlider
      .map((item) => Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Column(
                  children: [
                    /*   Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, color: primaryColor),
                        SizedBox(width: 10),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),*/
                    /*  Text(
                        item.subTitle,
                      textAlign: TextAlign.center,
                    ),*/
                  ],
                ),
              ),
            ),
          ))
      .toList();
}*/
