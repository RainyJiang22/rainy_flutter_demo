import 'package:flutter/material.dart';

class ImageScaleDemo extends StatelessWidget {
  const ImageScaleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('图片伸缩')),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
                children: [
                  Image.network(
                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 10),
                  Text("BoxFit.fill")
                ]
            ),
            SizedBox(height: 10.0),
            Row(
                children: [
                  Image.network(
                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Text("BoxFit.cover")
                ]
            ),
            SizedBox(height: 10.0),
            Row(
                children: [
                  Image.network(
                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
                    width: 100.0,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 10),
                  Text("BoxFit.contain")
                ]
            ),
            SizedBox(height: 10.0),
            Row(
                children: [
                  Image.network(
                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
                    width: 100.0,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(width: 10),
                  Text("BoxFit.fitWidth")
                ]
            ),
            SizedBox(height: 10.0),
            Row(
                children: [
                  Image.network(
                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
                    width: 100.0,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(width: 10),
                  Text("BoxFit.fitHeight")
                ]
            ),
            SizedBox(height: 10.0),
            Row(
                children: [
                  Image.network(
                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
                    width: 100.0,
                    fit: BoxFit.scaleDown,
                  ),
                  SizedBox(width: 10),
                  Text("BoxFit.fitHeight")
                ]
            ),
            Row(
                children: [
                  Image.network(
                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4",
                    width: 100.0,
                    fit: BoxFit.none,
                  ),
                  SizedBox(width: 10),
                  Text("BoxFit.none")
                ]
            ),
          ],
        ),
      ),
    );
  }
}
