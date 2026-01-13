import 'package:flutter/material.dart';

class Paper extends StatelessWidget {
  const Paper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white, child: CustomPaint(
      painter: PaperPainter(),
    ));
  }
}

class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    canvas.drawCircle(Offset(100, 100), 10, paint);

    final Paint linePaint = Paint();

    linePaint.color = Colors.blue;
    linePaint.strokeWidth = 4;
    linePaint.style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, 0), Offset(100, 100), linePaint);
    
    final Path path = Path();
    
    path.moveTo(100, 100);
    path.lineTo(200, 0);
    canvas.drawPath(path, paint..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
