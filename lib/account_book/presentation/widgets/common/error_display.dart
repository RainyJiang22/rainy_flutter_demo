import 'package:flutter/material.dart';

/// 错误显示组件
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 网络错误显示
class NetworkError extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkError({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorDisplay(
      message: '网络连接失败，请检查网络设置',
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
    );
  }
}

/// 数据加载错误显示
class DataLoadError extends StatelessWidget {
  final VoidCallback? onRetry;

  const DataLoadError({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorDisplay(
      message: '数据加载失败，请稍后重试',
      icon: Icons.cloud_off_outlined,
      onRetry: onRetry,
    );
  }
}
