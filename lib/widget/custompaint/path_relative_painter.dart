//相对移动练习
import 'package:flutter/material.dart';

class PathRelativePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();

    path.moveTo(50, 50);

    path.relativeLineTo(100, 0);
    path.relativeLineTo(0, 50);
    path.relativeLineTo(-50, 50);
    path.relativeLineTo(-50, -50);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
