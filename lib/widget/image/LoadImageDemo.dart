import 'dart:typed_data';
import 'package:flutter/material.dart';

/// 网络图片加载Demo
/// 展示多种加载网络图片的方式和最佳实践
class LoadImageDemo extends StatelessWidget {
  const LoadImageDemo({super.key});

  // 示例网络图片URL
  static const String imageUrl1 = 'https://picsum.photos/200/300';
  static const String imageUrl2 = 'https://picsum.photos/200/200';
  static const String imageUrl3 = 'https://picsum.photos/300/200';
  static const String errorUrl =
      'https://invalid-url.com/image.jpg'; // 用于演示错误处理

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络图片加载'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            '1. 基础方式 - Image.network',
            '最简单的网络图片加载方式',
            _buildBasicNetworkImage(),
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            '2. 带占位符和淡入效果 - FadeInImage',
            '加载时显示占位符，加载完成后淡入显示',
            _buildFadeInImage(),
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            '3. 错误处理',
            '加载失败时显示错误占位符',
            _buildErrorHandlingImage(),
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            '4. 自定义加载和错误状态',
            '使用Builder自定义加载中和错误时的显示',
            _buildCustomStateImage(),
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            '5. 圆形图片',
            '使用ClipOval或CircleAvatar',
            _buildCircularImage(),
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            '6. 圆角图片',
            '使用ClipRRect实现圆角效果',
            _buildRoundedImage(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String description,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  /// 基础网络图片加载
  Widget _buildBasicNetworkImage() {
    return Image.network(imageUrl1, width: 200, height: 200, fit: BoxFit.cover);
  }

  /// 带占位符的淡入图片
  Widget _buildFadeInImage() {
    return Column(
      children: [
        // 方式1: 使用透明占位符（简单快速）
        FadeInImage.memoryNetwork(
          placeholder: _transparentImage,
          image: imageUrl2,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 300),
          fadeOutDuration: const Duration(milliseconds: 100),
        ),
        const SizedBox(height: 16),
        // 方式2: 使用颜色占位符配合加载指示器（更好的用户体验）
        FadeInImage.memoryNetwork(
          placeholder: _transparentImage,
          image: imageUrl3,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          placeholderErrorBuilder: (context, error, stackTrace) {
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ],
    );
  }

  // 创建一个1x1的透明PNG图片作为占位符
  static final Uint8List _transparentImage = Uint8List.fromList([
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]);

  /// 错误处理
  Widget _buildErrorHandlingImage() {
    return Image.network(
      errorUrl,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 200,
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text('加载失败', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          width: 200,
          height: 200,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  /// 自定义加载和错误状态
  Widget _buildCustomStateImage() {
    return Image.network(
      imageUrl3,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                if (loadingProgress.expectedTotalBytes != null)
                  Text(
                    '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('图片加载失败', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }

  /// 圆形图片
  Widget _buildCircularImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 方式1: 使用ClipOval
        ClipOval(
          child: Image.network(
            imageUrl1,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 50),
              );
            },
          ),
        ),
        // 方式2: 使用CircleAvatar
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(imageUrl2),
          onBackgroundImageError: (exception, stackTrace) {
            // 错误处理
          },
          child: ClipOval(
            child: Image.network(
              imageUrl2,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, size: 50);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 圆角图片
  Widget _buildRoundedImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl3,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 200,
            height: 200,
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 50),
          );
        },
      ),
    );
  }
}
