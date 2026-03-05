import 'dart:math';

import 'package:flutter/material.dart';

//绘制弧形arcto
class ArcPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rect = Rect.fromCenter(center: center, width: 150, height: 150);

    final arcPath = Path();
    arcPath.arcTo(rect, -pi / 2, pi * 1.5, false);

    canvas.drawPath(arcPath, paint);

    final paint2 = Paint()
    ..color = Colors.orange
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

    final arcPath2 = Path();
    arcPath2.moveTo(50,200);

    arcPath2.arcToPoint(
      Offset(200,200),
      radius: Radius.circular(50),
      clockwise: true //顺时针方向
    );
    canvas.drawPath(arcPath2, paint2);

    // ========== 3. addArc：添加完整的扇形弧线 ==========
    final paint3 = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final piePath = Path();
    piePath.moveTo(center.dx, center.dy + 120);  // 移动到圆心
    piePath.addArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 120), width: 80,
          height: 80),
      -pi / 2,  // 起始角度
      pi / 2,   // 扫描角度（90度扇形）
    );
    piePath.close();  // 闭合形成扇形

    canvas.drawPath(piePath, paint3);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
