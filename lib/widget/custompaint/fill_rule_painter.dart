import 'package:flutter/material.dart';

class FillRulePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final evenOddPath = Path()
      ..addOval(Rect.fromCenter(center: center, width: 150, height: 150))
      ..addOval(Rect.fromCenter(center: center, width: 100, height: 100))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(evenOddPath, Paint()..color = Colors.blue);
    // 标注
    _drawLabel(canvas, 'evenOdd: 奇数填充', Offset(center.dx, center.dy + 100));

    // ========== nonZero 规则（默认）：根据方向判断 ==========
    final nonZeroPath = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(center.dx + 200, center.dy),
          width: 150,
          height: 150,
        ),
      )
      ..addOval(
        Rect.fromCenter(
          center: Offset(center.dx + 200, center.dy),
          width: 100,
          height: 100,
        ),
      )
      ..fillType = PathFillType.nonZero;

    canvas.drawPath(nonZeroPath, Paint()..color = Colors.orange);

    _drawLabel(
      canvas,
      'nonZero: 全部填充',
      Offset(center.dx + 200, center.dy + 100),
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset position) {
    final span = TextSpan(
      text: text,
      style: TextStyle(fontSize: 12, color: Colors.black),
    );
    final painter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    painter.layout();
    painter.paint(canvas, Offset(position.dx - painter.width / 2, position.dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
