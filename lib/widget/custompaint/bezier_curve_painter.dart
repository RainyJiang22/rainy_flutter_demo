import 'package:flutter/material.dart';

/// 贝塞尔曲线练习
class BezierCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final helperPaint = Paint()
    ..color = Colors.grey
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

    final startPoint = Offset(50,center.dy);
    final controlPoint = Offset(center.dx, center.dy - 80);
    final endPoint = Offset(size.width - 50, center.dy);

    // 画辅助线
    canvas.drawLine(startPoint, controlPoint, helperPaint);
    canvas.drawLine(controlPoint, endPoint, helperPaint);

    // 画控制点（小红点）
    canvas.drawCircle(controlPoint, 5, Paint()..color = Colors.red);

    // 画曲线
    final curvePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final quadPath = Path();
    quadPath.moveTo(startPoint.dx, startPoint.dy);
    quadPath.quadraticBezierTo(
      controlPoint.dx, controlPoint.dy,  // 控制点
      endPoint.dx, endPoint.dy,          // 终点
    );
    canvas.drawPath(quadPath, curvePaint);



    // ========== 2. 三次贝塞尔曲线 cubicTo ==========
    final controlPoint1 = Offset(100, center.dy + 150);
    final controlPoint2 = Offset(size.width - 100, center.dy + 150);
    final cubicEndPoint = Offset(size.width - 50, center.dy + 100);

    // 画辅助线
    final cubicStartPoint = Offset(50, center.dy + 100);
    canvas.drawLine(cubicStartPoint, controlPoint1, helperPaint);
    canvas.drawLine(controlPoint2, cubicEndPoint, helperPaint);

    // 画控制点
    canvas.drawCircle(controlPoint1, 5, Paint()..color = Colors.green);
    canvas.drawCircle(controlPoint2, 5, Paint()..color = Colors.green);

    // 画曲线
    final cubicPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final cubicPath = Path();
    cubicPath.moveTo(cubicStartPoint.dx, cubicStartPoint.dy);
    cubicPath.cubicTo(
      controlPoint1.dx, controlPoint1.dy,  // 第一个控制点
      controlPoint2.dx, controlPoint2.dy,  // 第二个控制点
      cubicEndPoint.dx, cubicEndPoint.dy,  // 终点
    );
    canvas.drawPath(cubicPath, cubicPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
