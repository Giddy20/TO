import 'package:app/models/image_model.dart';
import 'package:app/widgets/image_widget.dart';
import 'package:flutter/material.dart';

class GridScreen extends StatefulWidget {
  final List<ImageModel> profileURL;
  const GridScreen(this.profileURL,{Key? key})
      : super(key: key);

  @override
  _GridScreenState createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  void abc() {}
  List images = [
    'assets/femalepic1.jpg',
    'assets/femalepic8.jpg',
    'assets/femalepic13.jpg',
    'assets/femalepic13.jpg',
  ];
  // void tapped() {
  //   widget.tapped(context, );
  // }

  @override
  Widget build(BuildContext context) {
    final double itemHeight =
        (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 3.55;
    final double itemWidth = MediaQuery.of(context).size.width / 2;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          childAspectRatio: (itemWidth / itemHeight),
          children: List.generate(
            widget.profileURL.length,
            (index) {
              return ImageWidget(widget.profileURL[index]);
            },
          ),
        ),
    );
  }
}
