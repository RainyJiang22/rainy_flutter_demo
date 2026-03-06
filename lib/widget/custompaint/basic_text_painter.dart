

import 'package:flutter/material.dart';

class BasicTextPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: 'Hello Flutter',
      style: TextStyle(
        fontSize: 24,
        color: Colors.black,
      )
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr
    );
    textPainter.layout();

    textPainter.paint(canvas,Offset(50,50));
    // ========== 2. 绘制带背景的文字 ==========
    // 先画背景矩形
    final bgTextSpan = TextSpan(
      text: '带背景的文字',
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
        backgroundColor: Colors.blue,  // 背景色
      ),
    );

    final bgPainter = TextPainter(
      text: bgTextSpan,
      textDirection: TextDirection.ltr,
    );
    bgPainter.layout();
    bgPainter.paint(canvas, Offset(50, 100));

    // ========== 3. 富文本（多种样式）==========
    final richTextSpan = TextSpan(
      children: [
        TextSpan(
          text: '红色',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
        TextSpan(
          text: ' + ',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        TextSpan(
          text: '蓝色',
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
        TextSpan(
          text: ' = ',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        TextSpan(
          text: '紫色',
          style: TextStyle(fontSize: 18, color: Colors.purple, fontWeight:
          FontWeight.bold),
        ),
      ],
    );

    final richPainter = TextPainter(
      text: richTextSpan,
      textDirection: TextDirection.ltr,
    );
    richPainter.layout();
    richPainter.paint(canvas, Offset(50, 150));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}