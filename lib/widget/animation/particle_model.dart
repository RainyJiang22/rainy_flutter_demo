import 'dart:math';
import 'package:flutter/material.dart';
import 'particle_config.dart';

/// 单个粒子的数据模型
class ParticleModel {
  /// 粒子位置
  Offset position;

  /// 粒子速度（像素/秒）
  Offset velocity;

  /// 粒子颜色
  Color color;

  /// 粒子大小
  double size;

  /// 剩余生命时间（毫秒）
  double life;

  /// 最大生命时间
  final double maxLife;

  /// 初始大小（用于大小变化计算）
  final double initialSize;

  ParticleModel({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
    required this.maxLife,
  }) : initialSize = size;

  /// 创建随机粒子
  factory ParticleModel.random({
    required Offset center,
    required ParticleConfig config,
    required Random random,
  }) {
    // 随机角度（0 到 2π）
    final angle = random.nextDouble() * 2 * pi;

    // 随机速度大小
    final speed = config.minSpeed +
        random.nextDouble() * (config.maxSpeed - config.minSpeed);

    // 根据角度计算x和y方向的速度
    final vx = cos(angle) * speed;
    final vy = sin(angle) * speed;

    // 随机大小
    final size = config.minSize +
        random.nextDouble() * (config.maxSize - config.minSize);

    // 随机颜色
    final color = config.colors[random.nextInt(config.colors.length)];

    // 生命周期（添加一些随机变化）
    final life = config.lifetime.toDouble() * (0.7 + random.nextDouble() * 0.6);

    return ParticleModel(
      position: center,
      velocity: Offset(vx, vy),
      color: color,
      size: size,
      life: life,
      maxLife: life,
    );
  }

  /// 更新粒子状态
  void update(double dt, double gravity, bool enableFade, bool enableSizeChange) {
    // 更新位置
    position = position + velocity * dt;

    // 应用重力
    velocity = velocity + Offset(0, gravity * dt);

    // 减少生命
    life -= dt * 1000;

    // 根据生命值调整大小
    if (enableSizeChange) {
      final lifeRatio = (life / maxLife).clamp(0.0, 1.0);
      size = initialSize * lifeRatio;
    }
  }

  /// 获取当前透明度
  double get opacity => (life / maxLife).clamp(0.0, 1.0);

  /// 判断粒子是否存活
  bool get isAlive => life > 0;
}
