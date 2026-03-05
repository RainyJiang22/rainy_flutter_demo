import 'dart:math';
import 'package:flutter/material.dart';

Widget showCustomWheel() {
  final sectors = [
    WheelSector(content: Text('一等奖'), background: Colors.red),
    WheelSector(content: Text('二等奖'), background: Colors.green),
    WheelSector(content: Text('三等奖'), background: Colors.blue),
    WheelSector(content: Text('四等奖'), background: Colors.grey),
    WheelSector(content: Text('五等奖'), background: Colors.orange),
    WheelSector(content: Text('六等奖'), background: Colors.lightBlue),
    WheelSector(content: Text('幸运奖'), background: Colors.pinkAccent),
    WheelSector(content: Text('安慰奖'), background: Colors.cyanAccent),
  ];
  return CustomizableWheel(
    sectors: sectors,
    size: 320,
    spinDuration: Duration(seconds: 8),
    animationCurve: Curves.easeOutExpo,
    wheelPadding: EdgeInsets.symmetric(vertical: 189),
    onResult: (index) {
      print("中奖扇区: $index, 参数是${sectors[index].toString()}");
    },
  );
}

class CustomizableWheelDemo extends StatelessWidget {
  const CustomizableWheelDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('幸运大转盘')),
      body: Center(child: showCustomWheel()),
    );
  }
}

class CustomizableWheel extends StatefulWidget {
  final List<WheelSector> sectors;
  final double size;
  final Widget? pointerIcon;
  final Duration spinDuration;
  final Curve animationCurve;
  final EdgeInsets wheelPadding;
  final Function(int index)? onResult;

  const CustomizableWheel({
    required this.sectors,
    this.size = 300,
    this.pointerIcon,
    this.spinDuration = const Duration(seconds: 4),
    this.animationCurve = Curves.decelerate,
    this.wheelPadding = const EdgeInsets.all(0),
    this.onResult,
    super.key,
  });

  @override
  State<CustomizableWheel> createState() => _CustomizableWheelState();
}

class _CustomizableWheelState extends State<CustomizableWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _angle = 0;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.spinDuration,
    );
    _controller.addListener(() {
      setState(() {
        _angle = _animation.value;
      });
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _spinning = false;
        });
        final selectedIndex =
            widget.sectors.length -
            ((normalizeAngle(_angle) * widget.sectors.length / (2 * pi))
                    .round()) %
                widget.sectors.length;
        widget.onResult?.call(selectedIndex % widget.sectors.length);
      }
    });
  }

  double normalizeAngle(double rad) {
    return rad % (2 * pi);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startSpin() {
    if (_spinning) return;
    setState(() {
      _spinning = true;
    });
    final rand = Random();
    final rounds = rand.nextInt(6) + 6;
    final targetIndex = rand.nextInt(widget.sectors.length);
    final sectorAngle = 2 * pi / widget.sectors.length;
    final toAngle =
        _angle + 2 * pi * rounds + sectorAngle * targetIndex + sectorAngle / 2;
    _animation = Tween<double>(begin: _angle, end: toAngle).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;

    return Padding(
      padding: widget.wheelPadding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: _angle,
            child: CustomPaint(
              size: Size(size, size),
              painter: WheelPainter(widget.sectors),
            ),
          ),
          // 指针组件（顶部居中）
          if (widget.pointerIcon != null)
            Column(
              children: [
                Center(child: widget.pointerIcon)
              ],
            )
          else
            // Positioned(
            //   top: 0,
            //   child: Icon(
            //     Icons.arrow_drop_down,
            //     size: 48,
            //     color: Colors.redAccent,
            //   ),
            // ),
          // 中央的抽奖按钮
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(32),
                backgroundColor: Colors.amber,
              ),
              onPressed: startSpin,
              child: Text(
                _spinning ? "抽奖中..." : "开始抽奖",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WheelSector {
  /// 中心内容，可以是 Text/Icon（高阶自定义可扩展为 Widget）
  final Widget content;

  /// 扇区背景色
  final Color background;

  /// 扇区边框颜色
  final Color borderColor;

  /// 扇区边框粗细
  final double borderWidth;

  WheelSector({
    required this.content,
    required this.background,
    this.borderColor = Colors.white,
    this.borderWidth = 2,
  });

  @override
  String toString() {
    return 'WheelSector{content: $content, background: $background, borderColor: $borderColor, borderWidth: $borderWidth}';
  }
}

class WheelPainter extends CustomPainter {
  final List<WheelSector> sectors;

  WheelPainter(this.sectors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sectorAngle = 2 * pi / sectors.length;
    final textRadius = radius * 0.7;

    for (int i = 0; i < sectors.length; i++) {
      // 背景
      final paint = Paint()
        ..color = sectors[i].background
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        sectorAngle * i,
        sectorAngle,
        true,
        paint,
      );
      // 边框
      if (sectors[i].borderWidth > 0) {
        final borderPaint = Paint()
          ..color = sectors[i].borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = sectors[i].borderWidth;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          sectorAngle * i,
          sectorAngle,
          true,
          borderPaint,
        );
      }
      // 扇区内容
      final angle = sectorAngle * (i + 0.5);
      final builder = sectors[i].content;
      // 将 Widget 转为图片并绘制（需用 toPicture/toImage，或用 overlays/Stack 方案，简化如下只支持 Text）
      if (builder is Text) {
        final textStyle =
            builder.style ?? TextStyle(fontSize: 16, color: Colors.white);
        final span = TextSpan(text: (builder.data ?? ""), style: textStyle);
        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        tp.layout();
        final dx = center.dx + cos(angle) * textRadius - tp.width / 2;
        final dy = center.dy + sin(angle) * textRadius - tp.height / 2;
        tp.paint(canvas, Offset(dx, dy));
      } else {
        // 你可以用 RenderRepaintBoundary 实现 Widget 绘制到 Canvas，高级部分略（常用的是只用 Text 或 Icon 简化）
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
