import 'package:flutter/material.dart';

class ClipTestDemo extends StatelessWidget {
  const ClipTestDemo({super.key});

  @override
  Widget build(BuildContext context) {
    Widget avatar = Image.asset("images/avatar.png", width: 60.0);
    return Scaffold(
      appBar: AppBar(title: Text("Clip Test Demo")),
      body: Center(
        child: Column(
          children: [
            avatar,

            ///圆形
            ClipOval(child: avatar),

            ///圆角矩形
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(5.0),
              child: avatar,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  widthFactor: .5,
                  child: avatar,
                ),
                Text("你好世界", style: TextStyle(color: Colors.green)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///将溢出部分裁剪
                ClipRRect(
                  child: Align(
                    alignment: Alignment.topLeft,
                    widthFactor: .5,
                    child: avatar,
                  ),
                ),
                Text("你好世界", style: TextStyle(color: Colors.green)),
              ],
            ),
            DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
              child: ClipRect(
                clipper: MyClipper(),
                child: avatar,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(10.0, 15.0, 40.0, 30.0);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}
