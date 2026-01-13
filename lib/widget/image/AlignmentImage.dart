import 'package:flutter/material.dart';

class Alignmentimage extends StatelessWidget {
  const Alignmentimage({super.key});

  @override
  Widget build(BuildContext context) {
    var alignment = [
      Alignment.center,
      Alignment.centerLeft,
      Alignment.centerRight,
      Alignment.topCenter,
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomCenter,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ];
    var imgLi = alignment
        .map(
          (alignment) => Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                width: 90,
                height: 120,
                color: Colors.grey.withAlpha(88),
                child: Image(
                  image: AssetImage("assets/images/ic_launcher_round.webp"),
                  width: 60,
                  height: 60,
                  alignment: alignment,
                ),
              ),
              Text(alignment.toString()),
            ],
          ),
        )
        .toList();

    var imageAlignment = Wrap(children: imgLi);

    return Scaffold(
      appBar: AppBar(title: Text('图片align位置')),
      body: Container(
        child: imageAlignment,
      ),
    );
  }
}
