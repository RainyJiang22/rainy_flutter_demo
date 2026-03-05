import 'dart:math';
import 'package:flutter/material.dart';

Widget showCustomWheel() {
  final sectors = [
    WheelSector(coins: 100, background: Colors.red),
    WheelSector(coins: 200, background: Colors.green),
    WheelSector(coins: 500, background: Colors.blue),
    WheelSector(coins: 50, background: Colors.grey),
    WheelSector(coins: 1000, background: Colors.orange),
    WheelSector(coins: 300, background: Colors.lightBlue),
    WheelSector(coins: 150, background: Colors.pinkAccent),
    WheelSector(coins: 80, background: Colors.cyanAccent),
  ];
  return CustomizableWheel(
    sectors: sectors,
    size: 320,
    spinDuration: Duration(seconds: 8),
    animationCurve: Curves.easeOutExpo,
    wheelPadding: EdgeInsets.symmetric(vertical: 189),
    onResult: (index) {
      print("中奖扇区: $index, 金币数量: ${sectors[index].coins}");
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
  int _targetIndex = 0;

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
        widget.onResult?.call(_targetIndex);
      }
    });
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
    _targetIndex = rand.nextInt(widget.sectors.length);
    final sectorAngle = 2 * pi / widget.sectors.length;

    // 计算目标角度：使指针指向目标扇形的中心
    // 指针在顶部（-pi/2），扇形从0度开始
    // 目标：转盘旋转后，目标扇形的中心对准顶部指针
    // 扇形 i 的中心角度 = sectorAngle * (i + 0.5)
    // 需要让这个中心角度转到 -pi/2（顶部）
    // 所以旋转角度 = -pi/2 - sectorAngle * (targetIndex + 0.5)
    // 但转盘是顺时针转的，所以角度是正值
    final targetSectorCenter = sectorAngle * (_targetIndex + 0.5);
    final stopAngle = 2 * pi * rounds + (pi / 2 - targetSectorCenter);

    _animation = Tween<double>(begin: _angle, end: _angle + stopAngle).animate(
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
          // 转盘
          Transform.rotate(
            angle: _angle,
            child: CustomPaint(
              size: Size(size, size),
              painter: WheelPainter(widget.sectors, _angle),
            ),
          ),
          // 顶部指针（固定不动）
          if (widget.pointerIcon != null)
            Positioned(
              top: 0,
              child: widget.pointerIcon!,
            )
          else
          // 中央的抽奖按钮（带指针）
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 按钮上方的指针（向下的三角形）
                Transform.rotate(
                  angle:  pi,
                  child: CustomPaint(
                    size: Size(20, 12),
                    painter: _PointerPainter(Colors.amber),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(28),
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: startSpin,
                  child: Text(
                    "抽奖",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WheelSector {
  /// 中心内容，可以是 Text/Icon（高阶自定义可扩展为 Widget）
  final Widget? content;

  /// 扇区背景色
  final Color background;

  /// 扇区边框颜色
  final Color borderColor;

  /// 扇区边框粗细
  final double borderWidth;

  /// 金币数量
  final int coins;

  /// 金币图标颜色
  final Color coinColor;

  /// 金币数量文本颜色
  final Color coinTextColor;

  WheelSector({
    this.content,
    required this.background,
    this.borderColor = Colors.white,
    this.borderWidth = 2,
    this.coins = 0,
    this.coinColor = Colors.amber,
    this.coinTextColor = Colors.white,
  });

  @override
  String toString() {
    return 'WheelSector{content: $content, background: $background, borderColor: $borderColor, borderWidth: $borderWidth, coins: $coins}';
  }
}

class WheelPainter extends CustomPainter {
  final List<WheelSector> sectors;
  final double rotationAngle;

  WheelPainter(this.sectors, this.rotationAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sectorAngle = 2 * pi / sectors.length;
    final textRadius = radius * 0.65;

    for (int i = 0; i < sectors.length; i++) {
      final sector = sectors[i];
      // 背景
      final paint = Paint()
        ..color = sector.background
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        sectorAngle * i,
        sectorAngle,
        true,
        paint,
      );
      // 边框
      if (sector.borderWidth > 0) {
        final borderPaint = Paint()
          ..color = sector.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = sector.borderWidth;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          sectorAngle * i,
          sectorAngle,
          true,
          borderPaint,
        );
      }

      // 扇区中心角度（基于转盘当前旋转角度计算实际角度）
      final sectorCenterAngle = sectorAngle * (i + 0.5);
      final actualAngle = sectorCenterAngle + rotationAngle;

      // 扇区内容中心位置
      final contentCenterX = center.dx + cos(sectorCenterAngle) * textRadius;
      final contentCenterY = center.dy + sin(sectorCenterAngle) * textRadius;

      // 绘制金币图标 + 数量
      if (sector.coins > 0) {
        _drawCoinWithText(
          canvas,
          Offset(contentCenterX, contentCenterY),
          sector.coins,
          actualAngle,
          sector.coinColor,
          sector.coinTextColor,
        );
      } else if (sector.content != null) {
        // 兼容原有 content 方式
        final builder = sector.content;
        if (builder is Text) {
          canvas.save();
          canvas.translate(contentCenterX, contentCenterY);
          canvas.rotate(-actualAngle);

          final textStyle =
              builder.style ?? TextStyle(fontSize: 16, color: Colors.white);
          final span = TextSpan(text: (builder.data ?? ""), style: textStyle);
          final tp = TextPainter(
            text: span,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          );
          tp.layout();
          tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
          canvas.restore();
        }
      }
    }
  }

  /// 绘制金币图标和数量文本（上下垂直排列，保持正立）
  void _drawCoinWithText(
    Canvas canvas,
    Offset position,
    int coins,
    double rotationAngle,
    Color coinColor,
    Color textColor,
  ) {
    const double iconSize = 28;
    const double spacing = 4;

    // 绘制金币图标
    final iconSpan = TextSpan(
      text: '🪙',
      style: TextStyle(fontSize: iconSize,color: Colors.yellow),
    );
    final iconPainter = TextPainter(
      text: iconSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    iconPainter.layout();

    // 绘制金币数量文本
    final textSpan = TextSpan(
      text: coins.toString(),
      style: TextStyle(
        fontSize: 16,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    // 保存画布状态
    canvas.save();

    // 移动到内容中心位置
    canvas.translate(position.dx, position.dy);

    // 旋转画布使文字保持正立（抵消转盘旋转角度）
    canvas.rotate(-rotationAngle);

    // 计算总高度（图标 + 间距 + 文字）
    final totalHeight = iconPainter.height + spacing + textPainter.height;
    final startY = -totalHeight / 2;

    // 绘制金币图标（居中）
    iconPainter.paint(
      canvas,
      Offset(-iconPainter.width / 2, startY),
    );

    // 绘制数量文本（居中）
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, startY + iconPainter.height + spacing),
    );

    // 恢复画布状态
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 指针绘制器（绘制向下箭头，指向转盘边缘）
class _PointerPainter extends CustomPainter {
  final Color color;

  _PointerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // 向下的三角形
    path.moveTo(0, 0); // 左上角
    path.lineTo(size.width, 0); // 右上角
    path.lineTo(size.width / 2, size.height); // 底部顶点（向下）
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
