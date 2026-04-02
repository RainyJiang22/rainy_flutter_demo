import 'package:flutter/material.dart';

/// 粒子爆炸效果配置类
/// 用于自定义粒子效果的各种参数
class ParticleConfig {
  /// 粒子数量
  final int particleCount;

  /// 粒子颜色列表
  final List<Color> colors;

  /// 最小粒子大小
  final double minSize;

  /// 最大粒子大小
  final double maxSize;

  /// 最小初始速度
  final double minSpeed;

  /// 最大初始速度
  final double maxSpeed;

  /// 粒子生命周期（毫秒）
  final int lifetime;

  /// 重力加速度
  final double gravity;

  /// 是否启用衰减
  final bool enableFade;

  /// 是否启用大小变化
  final bool enableSizeChange;

  const ParticleConfig({
    this.particleCount = 50,
    this.colors = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.purple,
      Colors.blue,
      Colors.pink,
    ],
    this.minSize = 4.0,
    this.maxSize = 12.0,
    this.minSpeed = 100.0,
    this.maxSpeed = 300.0,
    this.lifetime = 1500,
    this.gravity = 200.0,
    this.enableFade = true,
    this.enableSizeChange = true,
  });

  /// 预设：烟花效果
  factory ParticleConfig.firework() => const ParticleConfig(
        particleCount: 80,
        colors: [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.white,
        ],
        minSize: 3.0,
        maxSize: 8.0,
        minSpeed: 150.0,
        maxSpeed: 350.0,
        lifetime: 2000,
        gravity: 150.0,
      );

  /// 预设：星星爆炸
  factory ParticleConfig.star() => const ParticleConfig(
        particleCount: 30,
        colors: [
          Colors.amber,
          Colors.yellow,
          Colors.orangeAccent,
        ],
        minSize: 6.0,
        maxSize: 15.0,
        minSpeed: 80.0,
        maxSpeed: 200.0,
        lifetime: 1800,
        gravity: 100.0,
      );

  /// 预设：彩色纸屑
  factory ParticleConfig.confetti() => const ParticleConfig(
        particleCount: 100,
        colors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
          Colors.purple,
          Colors.cyan,
        ],
        minSize: 5.0,
        maxSize: 10.0,
        minSpeed: 50.0,
        maxSpeed: 180.0,
        lifetime: 2500,
        gravity: 250.0,
      );
}
