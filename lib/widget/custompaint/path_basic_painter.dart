import 'package:flutter/material.dart';

class PathBasicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //练习1:绘制三角形
    final trianglePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final trianglePath = Path();
    trianglePath.moveTo(50, 150);
    trianglePath.lineTo(150, 50);
    trianglePath.lineTo(250, 150);
    trianglePath.close();
    canvas.drawPath(trianglePath, trianglePaint);

    //练习2:绘制梯形
    final trapezoidPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final trapezoidPath = Path();
    trapezoidPath.moveTo(30, 200);
    trapezoidPath.lineTo(80, 200); // 右下角
    trapezoidPath.lineTo(70, 250); // 右上角
    trapezoidPath.lineTo(40, 250); // 左上角
    trapezoidPath.close(); // 闭合

    canvas.drawPath(trapezoidPath, trapezoidPaint);

    final vPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final vPath = Path();
    vPath.moveTo(150, 200);
    vPath.lineTo(180, 250);
    vPath.lineTo(210, 200);

    canvas.drawPath(vPath, vPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
