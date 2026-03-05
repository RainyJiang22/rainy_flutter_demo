import 'dart:math';

import 'package:flutter/material.dart';

class ArcProgressPainter extends CustomPainter {
  final double progress;

  ArcProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // ========== 1. 背景圆弧 ==========
    final bgPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final bgRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      bgRect,
      -pi / 2, // 从顶部开始
      2 * pi, // 完整圆
      false, // 不连接中心
      bgPaint,
    );

    // ========== 2. 进度圆弧 ==========
    final progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress; // 根据进度计算角度
    canvas.drawArc(
      bgRect,
      -pi / 2, // 从顶部开始
      sweepAngle, // 扫描角度
      false,
      progressPaint,
    );

    // ========== 3. 中心文字 ==========
    final textSpan = TextSpan(
      text: '${(progress * 100).toInt()}%',
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant ArcProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
