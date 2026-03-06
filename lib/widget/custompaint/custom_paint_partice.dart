import 'dart:ui';

import 'package:first_flutter_demo/widget/custompaint/add_shape_painter.dart';
import 'package:first_flutter_demo/widget/custompaint/arc_path_painter.dart';
import 'package:first_flutter_demo/widget/custompaint/basic_text_painter.dart';
import 'package:first_flutter_demo/widget/custompaint/bezier_curve_painter.dart';
import 'package:first_flutter_demo/widget/custompaint/fill_rule_painter.dart';
import 'package:first_flutter_demo/widget/custompaint/path_basic_painter.dart';
import 'package:first_flutter_demo/widget/custompaint/path_relative_painter.dart';
import 'package:first_flutter_demo/widget/custompaint/star_painter.dart';
import 'package:flutter/material.dart';

class CustomPaintPracticePage extends StatelessWidget {
  const CustomPaintPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CustomPaint 练习")),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.grey[200],
          child: CustomPaint(painter: BasicTextPainter()),
        ),
      ),
    );
  }
}

class MyFirstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // final center = Offset(size.width / 2, size.height / 2);
    //
    // final radius = 80.0;
    // // 填充样式一
    // final fillPaint = Paint();
    // fillPaint
    //   ..color = Colors.blue.withValues(alpha: 0.3)
    //   ..style = PaintingStyle.fill;
    // canvas.drawCircle(center, radius, fillPaint);
    //
    // //填充样式二
    // final strokePaint = Paint();
    // strokePaint
    //   ..color = Colors.red
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 4;
    // canvas.drawCircle(center, radius, strokePaint);

    // final paint = Paint();
    // paint
    //   ..color = Colors.green
    //   ..style = PaintingStyle.fill;
    //
    // final rect = Rect.fromLTWH(50, 50, 80, 60);
    // canvas.drawRect(rect, paint);
    //
    // final rrectPaint = Paint();
    // rrectPaint
    //   ..color = Colors.orange
    //   ..style = PaintingStyle.fill;
    //
    // final rrect = RRect.fromRectAndRadius(
    //   Rect.fromLTWH(150, 50, 80, 60),
    //   // 矩形区域
    //   Radius.circular(10), // 圆角半径
    // );
    // canvas.drawRRect(rrect, rrectPaint);
    //
    // //从中心点定义矩形
    // final centerRect = Rect.fromCenter(
    //   center: Offset(size.width / 2, size.height / 2 + 50),
    //   width: 100,
    //   height: 60,
    // );
    // canvas.drawRect(centerRect, Paint()..color = Colors.purple);

    // final paint = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3
    //   ..strokeCap = StrokeCap.round;
    //
    // canvas.drawLine(Offset(20, 20), Offset(100, 20), paint);
    //
    // final points = [
    //   Offset(20, 60),
    //   Offset(80, 100),
    //   Offset(140, 60),
    //   Offset(200, 100),
    // ];
    //
    // //连接所有点形成折线
    // canvas.drawPoints(PointMode.polygon, points, paint);
    //
    // //绘制散点
    // final dotPaint = Paint()
    // ..color = Colors.red
    // ..style = PaintingStyle.fill
    // ..strokeWidth  =8;
    // canvas.drawPoints(
    //   PointMode.points,
    //   [
    //     Offset(250,60),
    //     Offset(260,80),
    //     Offset(270,100)
    //   ],
    //   dotPaint
    // );

    //综合练习
    final center = Offset(size.width / 2, size.height / 2);

    //1.脸部
    final facePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 100, facePaint);

    //脸部描边
    final faceStroke = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, 100, faceStroke);

    //3.左眼、右眼
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(center.dx - 35, center.dy - 20), 12, eyePaint);
    canvas.drawCircle(Offset(center.dx + 35, center.dy - 20), 12, eyePaint);

    //4.嘴巴
    final mouthPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + 10),
      width: 60,
      height: 50,
    );

    canvas.drawArc(mouthRect, 0.2, 2.7, false, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // 返回 true：每次 setState 都会重新调用 paint()
    // 返回 false：不会重绘，除非 CustomPainter 实例变了

    // 当绘制内容不变时，返回 false 可以提升性能
    return false; //不需要重新绘制
  }
}
