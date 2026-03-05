import 'dart:math';
import 'package:flutter/material.dart';

// 设计图配色：赌场/嘉年华风格
const Color _kDeepRed = Color(0xFF8B0000);
const Color _kDeepBlue = Color(0xFF0A1628);
const Color _kGold = Color(0xFFFFD700);
const Color _kGoldDark = Color(0xFFB8860B);
const Color _kNeonYellow = Color(0xFFFFEB3B);
const Color _kNeonBlue = Color(0xFF00BCD4);

Widget showCustomWheel() {
  // 设计图 8 扇区：红蓝交替，JACKPOT / X COINS / TRY AGAIN
  final sectors = [
    WheelSector(background: _kDeepRed, label: 'JACKPOT'),
    WheelSector(background: _kDeepBlue, coins: 50),
    WheelSector(background: _kDeepRed, label: 'TRY AGAIN'),
    WheelSector(background: _kDeepBlue, coins: 100),
    WheelSector(background: _kDeepRed, coins: 25),
    WheelSector(background: _kDeepBlue, coins: 10),
    WheelSector(background: _kDeepRed, coins: 200),
    WheelSector(background: _kDeepBlue, label: 'TRY AGAIN'),
  ];
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A0A0A), Color(0xFF2D1810), Color(0xFF1A0A0A)],
      ),
    ),
    child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopBanner(),
          SizedBox(height: 12),
          CustomizableWheel(
            sectors: sectors,
            size: 320,
            spinDuration: const Duration(seconds: 6),
            animationCurve: Curves.easeOutCubic,
            wheelPadding: const EdgeInsets.symmetric(vertical: 8),
            onResult: (index) {
              debugPrint('中奖扇区: $index, 内容: ${sectors[index].displayText}');
            },
          ),
          SizedBox(height: 12),
          _buildBottomBanner(),
        ],
      ),
    ),
  );
}

Widget _buildTopBanner() {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _bannerText('SPIN', color: _kGold),
            _bannerText(' & ', color: _kNeonBlue),
            _bannerText('WIN!', color: _kGold),
          ],
        ),
      ),
    ),
  );
}

Widget _bannerText(String text, {required Color color}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w900,
      color: color,
      letterSpacing: 2,
      shadows: [
        Shadow(color: color.withValues(alpha: 0.8), blurRadius: 12),
        Shadow(
          color: Colors.black87,
          blurRadius: 2,
          offset: const Offset(1, 1),
        ),
      ],
    ),
  );
}

Widget _buildBottomBanner() {
  return SizedBox(
    width: double.infinity,
    height: 52,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          'GOLDEN COIN JACKPOT!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _kGold,
            letterSpacing: 1.5,
            shadows: [
              Shadow(color: _kGold.withValues(alpha: 0.9), blurRadius: 8),
              Shadow(
                color: Colors.black87,
                blurRadius: 2,
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// 弧形缎带背景：深红底 + 金色描边
class _CurvedBannerPainter extends CustomPainter {
  final bool isTop;

  _CurvedBannerPainter({required this.isTop});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width + 48,
      height: size.height * 2.4,
    );
    final startAngle = isTop ? pi * 0.18 : pi * 0.82;
    final sweepAngle = pi * 0.64;

    final fillPaint = Paint()
      ..color = _kDeepRed
      ..style = PaintingStyle.fill;
    canvas.drawArc(rect, startAngle, sweepAngle, true, fillPaint);

    final borderPaint = Paint()
      ..color = _kGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawArc(rect, startAngle, sweepAngle, true, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
        clipBehavior: Clip.none,
        children: [
          // 转盘
          Transform.rotate(
            angle: _angle,
            child: CustomPaint(
              size: Size(size, size),
              painter: WheelPainter(widget.sectors, _angle),
            ),
          ),
          // 顶部金色五角星指针（固定不动）
          if (widget.pointerIcon != null)
            Positioned(top: -8, child: widget.pointerIcon!)
          else
            Positioned(
              top: -14,
              child: CustomPaint(
                size: const Size(44, 44),
                painter: _StarPointerPainter(),
              ),
            ),
          // 中央 SPIN 按钮（金环 + 红橙渐变）
          Center(
            child: GestureDetector(
              onTap: _spinning ? null : startSpin,
              child: Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _kGoldDark.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                  border: Border.all(color: _kGold, width: 5),
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFFE65100),
                      Color(0xFFBF360C),
                    ],
                  ),
                ),
                child: Text(
                  'SPIN',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
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
  final Widget? content;

  /// 扇区背景色
  final Color background;

  /// 扇区边框颜色
  final Color borderColor;

  /// 扇区边框粗细
  final double borderWidth;

  /// 金币数量（与 label 二选一：有 label 时显示 label，否则显示 "$coins COINS"）
  final int coins;

  /// 扇区文案，如 "JACKPOT"、"TRY AGAIN"；为 null 时显示 "$coins COINS"
  final String? label;

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
    this.label,
    this.coinColor = Colors.amber,
    this.coinTextColor = Colors.white,
  });

  /// 用于展示的文本：优先 label，否则 "X COINS"
  String get displayText => label ?? '$coins COINS';

  @override
  String toString() {
    return 'WheelSector{label: $label, coins: $coins, background: $background}';
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
    final textRadius = radius * 0.58;
    const innerRadius = 48.0; // 中心按钮留空

    // 1. 扇区背景 + 扇区内小星星
    for (int i = 0; i < sectors.length; i++) {
      final sector = sectors[i];
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
      _drawSectorStars(
        canvas,
        center,
        radius,
        innerRadius,
        sectorAngle * i,
        sectorAngle,
      );
    }

    // 2. 扇区之间的细金线
    final linePaint = Paint()
      ..color = _kGold.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 0; i <= sectors.length; i++) {
      final a = sectorAngle * i;
      canvas.drawLine(
        center + Offset(cos(a) * innerRadius, sin(a) * innerRadius),
        center + Offset(cos(a) * radius, sin(a) * radius),
        linePaint,
      );
    }

    // 3. 外圈金边 + 灯泡
    const borderWidth = 12.0;
    final borderPaint = Paint()
      ..color = _kGoldDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(center, radius - borderWidth / 2, borderPaint);
    final goldRing = Paint()
      ..color = _kGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 6, goldRing);

    const bulbCount = 24;
    for (int i = 0; i < bulbCount; i++) {
      final a = (i / bulbCount) * 2 * pi - pi / 2;
      final bulbCenter =
          center + Offset(cos(a) * (radius - 6), sin(a) * (radius - 6));
      canvas.drawCircle(
        bulbCenter,
        5,
        Paint()..color = Colors.white.withValues(alpha: 0.95),
      );
      canvas.drawCircle(
        bulbCenter,
        5,
        Paint()
          ..color = _kGold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // 4. 扇区文案（JACKPOT / X COINS / TRY AGAIN）
    for (int i = 0; i < sectors.length; i++) {
      final sector = sectors[i];
      final sectorCenterAngle = sectorAngle * (i + 0.5);
      final actualAngle = sectorCenterAngle + rotationAngle;
      final contentCenterX = center.dx + cos(sectorCenterAngle) * textRadius;
      final contentCenterY = center.dy + sin(sectorCenterAngle) * textRadius;
      _drawSectorLabel(
        canvas,
        Offset(contentCenterX, contentCenterY),
        sector.displayText,
        actualAngle,
      );
    }
  }

  void _drawSectorStars(
    Canvas canvas,
    Offset center,
    double radius,
    double innerRadius,
    double startAngle,
    double sweepAngle,
  ) {
    final starColor = _kGold.withValues(alpha: 0.6);
    final starPaint = Paint()
      ..color = starColor
      ..style = PaintingStyle.fill;
    const starRadius = 4.0;
    const count = 6;
    for (int k = 0; k < count; k++) {
      final t = (k + 0.5) / count;
      final r = innerRadius + (radius - innerRadius - 20) * t;
      final a = startAngle + sweepAngle * (0.2 + 0.6 * (k % 3) / 3);
      final pos = center + Offset(cos(a) * r, sin(a) * r);
      _drawSmallStar(canvas, pos, starRadius, starPaint);
    }
  }

  void _drawSmallStar(Canvas canvas, Offset center, double r, Paint paint) {
    const points = 5;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? r : r * 0.5;
      final angle = (i * pi / points) - pi / 2;
      final p = center + Offset(cos(angle) * radius, sin(angle) * radius);
      if (i == 0)
        path.moveTo(p.dx, p.dy);
      else
        path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSectorLabel(
    Canvas canvas,
    Offset position,
    String text,
    double rotationAngle,
  ) {
    const fontSize = 14.0;
    final fillStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: _kNeonYellow,
      letterSpacing: 0.5,
    );
    final strokeStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = Colors.black87,
    );

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(-rotationAngle);
    // 先画描边再画填充，形成发光轮廓
    final strokePainter = TextPainter(
      text: TextSpan(text: text, style: strokeStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    strokePainter.layout();
    strokePainter.paint(
      canvas,
      Offset(-strokePainter.width / 2, -strokePainter.height / 2),
    );
    final fillPainter = TextPainter(
      text: TextSpan(text: text, style: fillStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    fillPainter.layout();
    fillPainter.paint(
      canvas,
      Offset(-fillPainter.width / 2, -fillPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 金色五角星指针（指向转盘顶部扇区）
class _StarPointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2 - 2;
    final innerR = outerR * 0.4;
    // 五角星：顶点朝下指向转盘
    const startAngle = -pi / 2;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final a1 = startAngle + (i * 2 * pi / 5);
      final a2 = startAngle + ((i + 0.5) * 2 * pi / 5);
      final p1 = center + Offset(cos(a1) * outerR, sin(a1) * outerR);
      final p2 = center + Offset(cos(a2) * innerR, sin(a2) * innerR);
      if (i == 0) path.moveTo(p1.dx, p1.dy);
      path.lineTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = _kGold
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = _kGoldDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
