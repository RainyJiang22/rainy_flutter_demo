import 'dart:math';
import 'package:flutter/material.dart';
import 'particle_model.dart';
import 'particle_config.dart';
import 'particle_explosion_painter.dart';

/// 粒子爆炸效果Demo页面
class ParticleExplosionDemo extends StatefulWidget {
  const ParticleExplosionDemo({super.key});

  @override
  State<ParticleExplosionDemo> createState() => _ParticleExplosionDemoState();
}

class _ParticleExplosionDemoState extends State<ParticleExplosionDemo>
    with SingleTickerProviderStateMixin {
  /// 动画控制器
  late AnimationController _controller;

  /// 粒子列表
  final List<ParticleModel> _particles = [];

  /// 当前配置
  ParticleConfig _config = const ParticleConfig();

  /// 随机数生成器
  final Random _random = Random();

  /// 上次更新时间
  DateTime? _lastUpdateTime;

  /// 爆炸计数
  int _explosionCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(_onAnimationTick);

    _lastUpdateTime = DateTime.now();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 动画帧回调
  void _onAnimationTick() {
    final now = DateTime.now();
    final dt = _lastUpdateTime != null
        ? now.difference(_lastUpdateTime!).inMicroseconds / 1000000.0
        : 0.016;
    _lastUpdateTime = now;

    // 限制 dt 最大值，防止切换应用后回来产生跳跃
    final clampedDt = dt.clamp(0.0, 0.1);

    // 更新所有粒子
    for (final particle in _particles) {
      particle.update(
        clampedDt,
        _config.gravity,
        _config.enableFade,
        _config.enableSizeChange,
      );
    }

    // 移除死亡的粒子
    _particles.removeWhere((p) => !p.isAlive);

    // 如果没有粒子了，停止动画
    if (_particles.isEmpty) {
      _controller.stop();
    }

    setState(() {});
  }

  /// 触发爆炸
  void _explode(Offset position) {
    // 生成新粒子
    for (int i = 0; i < _config.particleCount; i++) {
      _particles.add(
        ParticleModel.random(
          center: position,
          config: _config,
          random: _random,
        ),
      );
    }

    _explosionCount++;

    // 启动动画（如果未运行）
    if (!_controller.isAnimating) {
      _lastUpdateTime = DateTime.now();
      _controller.repeat();
    }
  }

  /// 切换配置预设
  void _changeConfig() {
    final configs = [
      const ParticleConfig(),
      ParticleConfig.firework(),
      ParticleConfig.star(),
      ParticleConfig.confetti(),
    ];
    final currentIndex = configs.indexOf(_config);
    final nextIndex = (currentIndex + 1) % configs.length;
    setState(() {
      _config = configs[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('粒子爆炸效果'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GestureDetector(
        onTapDown: (details) {
          _explode(details.localPosition);
        },
        child: Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // 粒子绘制层
              CustomPaint(
                painter: ParticleExplosionPainter(
                  particles: _particles,
                  config: _config,
                ),
                size: Size.infinite,
              ),
              // 提示文字
              Positioned(
                left: 0,
                right: 0,
                bottom: 100,
                child: Column(
                  children: [
                    Text(
                      '点击屏幕任意位置触发爆炸',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '已触发爆炸: $_explosionCount 次',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '当前预设: ${_getConfigName()}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeConfig,
        tooltip: '切换效果',
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }

  String _getConfigName() {
    if (_config == const ParticleConfig()) return '默认';
    if (_config == ParticleConfig.firework()) return '烟花';
    if (_config == ParticleConfig.star()) return '星星';
    if (_config == ParticleConfig.confetti()) return '彩纸';
    return '自定义';
  }
}
