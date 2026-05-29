
import 'package:flutter/material.dart';


/// 自定义通知：子组件把操作结果向父组件上报。
class LabMessageNotification extends Notification {
  LabMessageNotification(this.message);

  final String message;
}

class GestureLabApp extends StatelessWidget {
  const GestureLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gesture Lab',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.cyan,
      ),
      home: const GestureLabPage(),
    );
  }
}

class GestureLabPage extends StatefulWidget {
  const GestureLabPage({super.key});

  @override
  State<GestureLabPage> createState() => _GestureLabPageState();
}

class _GestureLabPageState extends State<GestureLabPage> {
  final ScrollController _scrollController = ScrollController();

  String _status = '等待用户操作';
  bool _showBackToTop = false;
  Offset _cardOffset = const Offset(24, 24);
  double _scale = 1.0;
  double _baseScale = 1.0;
  Color _panelColor = Colors.cyan.shade100;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Notification>(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          final shouldShow = notification.metrics.pixels > 240;
          if (shouldShow != _showBackToTop) {
            setState(() {
              _showBackToTop = shouldShow;
            });
          }
          return false;
        }

        if (notification is LabMessageNotification) {
          setState(() {
            _status = notification.message;
          });
          return true;
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('事件实验室'),
        ),
        floatingActionButton: _showBackToTop
            ? FloatingActionButton.extended(
          onPressed: _scrollToTop,
          label: const Text('回到顶部'),
          icon: const Icon(Icons.vertical_align_top),
        )
            : null,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('状态面板'),
                    subtitle: Text(_status),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildPointerSection(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildGestureSection(),
              ),
            ),
            SliverList.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('滚动测试项 ${index + 1}'),
                  subtitle: const Text('用于观察 ScrollNotification 与返回顶部按钮'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointerSection() {
    return Builder(
      builder: (context) {
        return Listener(
          onPointerDown: (event) {
            setState(() {
              _panelColor = Colors.orange.shade100;
              _status = 'PointerDown: ${event.localPosition}';
            });
            LabMessageNotification('原始按下坐标: ${event.localPosition}')
                .dispatch(context);
          },
          onPointerMove: (event) {
            setState(() {
              _status = 'PointerMove: ${event.localPosition}';
            });
          },
          onPointerUp: (event) {
            setState(() {
              _panelColor = Colors.cyan.shade100;
              _status = 'PointerUp: ${event.localPosition}';
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 140,

            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _panelColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '区域一：在这里按下、移动、抬起，观察原始指针事件',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGestureSection() {

    const double cardSize = 140;
    return SizedBox(
      height: 280,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        final containerWidth = constraints.maxWidth;
        final containerHeight = constraints.maxHeight;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              Positioned(
                left: _cardOffset.dx,
                top: _cardOffset.dy,
                child: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        LabMessageNotification('点击了卡片').dispatch(context);
                      },
                      onDoubleTap: () {
                        setState(() {
                          _scale = 1.0;
                          _cardOffset = const Offset(24, 24);
                        });
                        LabMessageNotification('双击重置了卡片位置和缩放').dispatch(
                          context,
                        );
                      },
                      onScaleStart: (details) {
                        _baseScale = _scale;
                      },
                      onScaleUpdate: (details) {
                        setState(() {
                          final newScale = (_baseScale * details.scale).clamp(0.8,2.4);
                          final newOffset = _cardOffset + details.focalPointDelta;

                          final scaledCardSize = cardSize * newScale;

                          final maxX = containerWidth - scaledCardSize;
                          final maxY = containerHeight - scaledCardSize;

                          _cardOffset  = Offset(
                            newOffset.dx.clamp(0.0,maxX< 0 ? 0.0 : maxX),
                            newOffset.dy.clamp(0.0,maxY < 0 ? 0.0 : maxY)
                          );
                          _scale = newScale;
                          _status = details.scale == 1.0
                              ? '拖拽位移: $_cardOffset'
                              : '当前缩放: ${_scale.toStringAsFixed(2)}x';
                        });
                      },
                      child: Transform.scale(
                        scale: _scale,
                        child: Container(
                          width: 140,
                          height: 140,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00ACC1), Color(0xFF007C91)],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Text(
                            '拖拽\n缩放\n双击重置',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      })
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }
}