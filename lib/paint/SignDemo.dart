import 'package:flutter/material.dart';

class SignatureDemo extends StatelessWidget {
  const SignatureDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Signdemo());
  }
}

class Signdemo extends StatefulWidget {
  const Signdemo({super.key});

  @override
  State<StatefulWidget> createState() => SignState();
}

class SignState extends State<Signdemo> {
  List<Offset?> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox? referenceBox = context.findRenderObject() as RenderBox;
          Offset locationPosition = referenceBox.globalToLocal(
            details.globalPosition,
          );
          _points = List.from(_points)..add(locationPosition);
        });
      },
      onPanEnd: (details) => _points.add(null),
      child: CustomPaint(painter: SignPainter(_points), size: Size.infinite),
    );
  }
}

class SignPainter extends CustomPainter {
  SignPainter(this.points);

  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
