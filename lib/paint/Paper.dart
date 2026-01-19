import 'package:flutter/material.dart';

class Paper extends StatelessWidget {
  const Paper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(painter: PaperPainter()),
    );
  }
}

class PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // final Paint paint = Paint();
    // canvas.drawCircle(Offset(100, 100), 10, paint);
    // final Paint linePaint = Paint();
    //
    // linePaint.color = Colors.blue;
    // linePaint.strokeWidth = 4;
    // linePaint.style = PaintingStyle.stroke;
    // canvas.drawLine(Offset(0, 0), Offset(100, 100), linePaint);
    //
    // final Path path = Path();
    //
    // path.moveTo(100, 100);
    // path.lineTo(200, 0);
    // canvas.drawPath(path, paint..color = Colors.red);

    //drawIsAntiAliasColor(canvas);
    // drawStyleStrokeWidth(canvas);
    //drawStrokeCap(canvas);
    drawStrokeJoin(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void drawIsAntiAliasColor(Canvas canvas) {
    Paint paint = Paint();
    canvas.drawCircle(
      Offset(180, 180),
      170,
      paint
        ..color = Colors.blue
        ..strokeWidth,
    );
    canvas.drawCircle(
      Offset(180, 380),
      170,
      paint
        ..color = Colors.red
        ..strokeWidth,
    );
  }

  //测试style和strokeWidth
  void drawStyleStrokeWidth(Canvas canvas) {
    Paint paint = Paint()..color = Colors.red;
    canvas.drawCircle(
      Offset(180, 180),
      150,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 50,
    );

    canvas.drawCircle(
      Offset(180 + 360.0, 180),
      150,
      paint
        ..strokeWidth = 50
        ..style = PaintingStyle.fill,
    );
  }

  //线帽类型strokecap
  //StrokeCap.butt 不出头，round 圆头， square 方头
  void drawStrokeCap(Canvas canvas) {
    Paint paint =  Paint();
    paint
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..strokeWidth = 20;
    canvas.drawLine(
        Offset(50, 50), Offset(50, 150), paint..strokeCap = StrokeCap.butt);
    canvas.drawLine(Offset(50 + 50.0, 50), Offset(50 + 50.0, 150),
        paint..strokeCap = StrokeCap.round);
    canvas.drawLine(Offset(50 + 50.0 * 2, 50), Offset(50 + 50.0 * 2, 150),
        paint..strokeCap = StrokeCap.square);
  }

  //线接类型strokeJoin
  void drawStrokeJoin(Canvas canvas) {
    Paint paint =  Paint();
    Path path =  Path();
    paint
      ..style = PaintingStyle.stroke
      ..color = Colors.blue
      ..strokeWidth = 20;
    path.moveTo(50, 50);
    path.lineTo(50, 150);
    path.relativeLineTo(100, -50);
    path.relativeLineTo(0, 100);
    canvas.drawPath(path, paint..strokeJoin = StrokeJoin.bevel);

    path.reset();
    path.moveTo(50 + 150.0, 50);
    path.lineTo(50 + 150.0, 150);
    path.relativeLineTo(100, -50);
    path.relativeLineTo(0, 100);
    canvas.drawPath(path, paint..strokeJoin = StrokeJoin.miter);

    path.reset();
    path.moveTo(50 + 150.0 * 2, 50);
    path.lineTo(50 + 150.0 * 2, 150);
    path.relativeLineTo(100, -50);
    path.relativeLineTo(0, 100);
    canvas.drawPath(path, paint..strokeJoin = StrokeJoin.round);
  }





}
