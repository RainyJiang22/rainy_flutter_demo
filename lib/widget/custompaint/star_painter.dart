import 'dart:math';

import 'package:flutter/material.dart';

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(size.width / 2, size.height / 2);

    //五角星参数
    final outerRadius = 80.0;
    final innerRadius = outerRadius * 0.4;
    const points = 5;

    final path = Path();

    for(int i = 0;i<points * 2;i++) {
      final radius = i.isEven ? outerRadius : innerRadius;

      final angle = -pi /2  + (i * pi / points);

      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;

      if(i == 0) {
        path.moveTo(x,y);
      } else {
        path.lineTo(x,y);
      }
    }

    path.close();

    // 绘制填充
    final fillPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 绘制描边
    final strokePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, strokePaint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
