import 'package:flutter/material.dart';
import 'particle_model.dart';
import 'particle_config.dart';

/// 粒子爆炸效果绘制器
class ParticleExplosionPainter extends CustomPainter {
  /// 粒子列表
  final List<ParticleModel> particles;

  /// 配置参数
  final ParticleConfig config;

  ParticleExplosionPainter({
    required this.particles,
    required this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      if (!particle.isAlive) continue;

      // 计算当前透明度
      final opacity = config.enableFade ? particle.opacity : 1.0;

      // 创建画笔
      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      // 绘制粒子（圆形）
      canvas.drawCircle(
        particle.position,
        particle.size / 2,
        paint,
      );

      // 绘制光晕效果
      if (opacity > 0.5) {
        final glowPaint = Paint()
          ..color = particle.color.withValues(alpha: opacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(
          particle.position,
          particle.size / 2 + 2,
          glowPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticleExplosionPainter oldDelegate) {
    // 当粒子列表引用变化或粒子数量变化时重绘
    return particles != oldDelegate.particles ||
        particles.length != oldDelegate.particles.length;
  }
}
