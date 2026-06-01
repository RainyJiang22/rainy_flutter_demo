
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimationShowcaseApp());
}

/// 综合练习项目
class AnimationShowcaseApp extends StatelessWidget {
  const AnimationShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '第9章综合练习',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0F766E),
      ),
      home: const ShowcaseHomePage(),
    );
  }
}

class ShowcaseHomePage extends StatefulWidget {
  const ShowcaseHomePage({super.key});

  @override
  State<ShowcaseHomePage> createState() => _ShowcaseHomePageState();
}

class _ShowcaseHomePageState extends State<ShowcaseHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _panelHeight;
  late final Animation<double> _panelOpacity;
  late final Animation<Offset> _panelOffset;

  int _count = 0;
  bool _highlight = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scale = Tween<double>(begin: 0.92, end: 1.08).chain(
      CurveTween(curve: Curves.easeInOut),
    ).animate(_controller);

    _panelHeight = Tween<double>(begin: 120, end: 220).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _panelOpacity = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _panelOffset = Tween<Offset>(
      begin: const Offset(0.16, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutBack),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playOrReverse() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _incrementCounter() {
    setState(() {
      _count++;
      _highlight = !_highlight;
    });
  }

  void _openDetailPage() {
    Navigator.of(context).push(_buildShowcaseRoute(_highlight));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('第9章动画展示台'),
        actions: [
          IconButton(
            onPressed: _playOrReverse,
            icon: const Icon(Icons.play_circle_outline),
            tooltip: '播放交织动画',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            '一页里练 5 种常见动画',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _controller,
            child: const FlutterLogo(size: 96),
            builder: (context, child) {
              return Transform.scale(
                scale: _scale.value,
                child: Center(
                  child: Hero(
                    tag: 'showcase-hero',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: _openDetailPage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            _highlight ? 40 : 24,
                          ),
                          gradient: LinearGradient(
                            colors: _highlight
                                ? const [Color(0xFF0F766E), Color(0xFF14B8A6)]
                                : const [Color(0xFF1D4ED8), Color(0xFF60A5FA)],
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
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _panelOpacity.value,
                child: SlideTransition(
                  position: _panelOffset,
                  child: Container(
                    height: _panelHeight.value,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '交织动画面板',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '前半段先淡入并增高，后半段再水平滑入。',
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            FilledButton.icon(
                              onPressed: _playOrReverse,
                              icon: const Icon(Icons.auto_awesome),
                              label: const Text('播放'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _openDetailPage,
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('打开详情'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AnimatedSwitcher 计数器',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text('每次点击都会做数字切换动画'),
                  ],
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    '$_count',
                    key: ValueKey(_count),
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _incrementCounter,
            icon: const Icon(Icons.add),
            label: const Text('增加计数并切换卡片样式'),
          ),
        ],
      ),
    );
  }
}

Route<void> _buildShowcaseRoute(bool highlight) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (context, animation, secondaryAnimation) {
      return DetailShowcasePage(highlight: highlight);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class DetailShowcasePage extends StatefulWidget {
  const DetailShowcasePage({
    super.key,
    required this.highlight,
  });

  final bool highlight;

  @override
  State<DetailShowcasePage> createState() => _DetailShowcasePageState();
}

class _DetailShowcasePageState extends State<DetailShowcasePage> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.highlight
        ? const [Color(0xFF0F766E), Color(0xFF14B8A6)]
        : const [Color(0xFF1D4ED8), Color(0xFF60A5FA)];

    return Scaffold(
      appBar: AppBar(title: const Text('动画详情页')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Hero(
              tag: 'showcase-hero',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeInOut,
                width: _expanded ? double.infinity : 260,
                height: _expanded ? 280 : 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_expanded ? 36 : 28),
                  gradient: LinearGradient(colors: colors),
                ),
                alignment: Alignment.center,
                child: const FlutterLogo(size: 120),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _expanded ? 1 : 0.65,
              child: const Text(
                '这里同时使用了 Hero、PageRouteBuilder 和 AnimatedContainer。',
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Text(_expanded ? '恢复卡片尺寸' : '展开卡片'),
            ),
          ],
        ),
      ),
    );
  }
}