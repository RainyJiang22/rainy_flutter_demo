import 'package:flutter/material.dart';

class RouteHeroApp extends StatelessWidget {
  const RouteHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '路由与hero动画',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const GalleryHomePage(),
    );
  }
}

class GalleryHomePage extends StatelessWidget {
  const GalleryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('路由过渡 +Hero')),
      body: Center(
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            Navigator.of(context).push(_buildDetailRoute());
          },
          child: Hero(
            tag: 'demo-card',
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)]
                )
              ),
              alignment: Alignment.center,
              child: const FlutterLogo(size: 96),
            ),
          ),
        ),
      ),
    );
  }
}

Route<void> _buildDetailRoute() {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (context, animation, secondaryAnimation) {
      return DetailPage();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('详情页')),
      body: Center(
        child: Hero(
          tag: 'demo-card',
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 24,
                  offset: Offset(0, 12),
                  color: Colors.black26,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const FlutterLogo(size: 140),
          ),
        ),
      ),
    );
  }
}
