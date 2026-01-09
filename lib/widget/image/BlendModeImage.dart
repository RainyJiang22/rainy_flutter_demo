import 'package:flutter/material.dart';

class BlendModeImage extends StatelessWidget {
  const BlendModeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BlendMode')),
      body: Wrap(
        children: BlendMode.values
            .toList()
            .map((mode) =>
            Column(children: <Widget>[
              Container(
                  margin: EdgeInsets.all(5),
                  width: 60,
                  height: 60,
                  color: Colors.grey,
                  child: Image(
                      image: AssetImage("assets/images/ic_launcher_round.webp"),
                      color: Colors.transparent,
                      colorBlendMode: mode)),
              Text(mode.toString().split(".")[1])
            ]))
            .toList(),
      )
    );
  }
}