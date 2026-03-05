import 'package:flutter/material.dart';

/// 快速添加形状练习
class AddShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    // ========== 1. addPolygon：添加多边形 ==========
    final polygonPath = Path();
    polygonPath.addPolygon(
      [
        Offset(50, 100),
        Offset(100, 50),
        Offset(150, 100),
        Offset(130, 160),
        Offset(70, 160),
      ],
      true, // close：是否闭合
    );
    canvas.drawPath(polygonPath, paint..color = Colors.blue);

    // ========== 2. addRRect：添加圆角矩形 ==========
    final rrectPath = Path();
    rrectPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(180, 50, 80, 60),
        Radius.circular(15),
      ),
    );
    canvas.drawPath(rrectPath, paint..color = Colors.orange);

    // ========== 3. addOval：添加椭圆 ==========
    final ovalPath = Path();
    ovalPath.addOval(
      Rect.fromLTWH(50, 180, 120, 80), // 宽 > 高 = 横椭圆
    );
    canvas.drawPath(ovalPath, paint..color = Colors.green);

    // ========== 4. addPath：合并多个路径 ==========
    final path1 = Path()..addOval(Rect.fromLTWH(200, 180, 50, 50));
    final path2 = Path()..addOval(Rect.fromLTWH(230, 200, 50, 50));

    final combinedPath = Path();
    combinedPath.addPath(path1, Offset.zero);
    combinedPath.addPath(path2, Offset.zero);

    canvas.drawPath(combinedPath, paint..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
