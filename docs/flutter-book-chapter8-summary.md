# 第8章：事件处理与通知

## 📖 章节概述

第8章讲的是 Flutter 如何接收、识别、分发和上传事件。它把“用户手指或鼠标到底做了什么”拆成两层：底层是原始指针事件，上一层是语义化手势；除此之外，本章还介绍了由子组件向父组件传播消息的 `Notification` 机制，以及跨页面广播常见的事件总线思路。

### 学习目标

- 理解 `Listener`、`GestureDetector`、`NotificationListener` 的职责边界。
- 理解命中测试（Hit Test）、事件分发、事件冒泡和手势竞技场。
- 能处理常见的点击、双击、长按、拖拽、缩放和滚动监听场景。
- 能判断什么时候应该用事件总线，什么时候应该改用更明确的状态管理或控制器。

### 知识点清单

| 小节 | 核心内容 | 难度 | 重要性 |
|---|---|---:|---:|
| 8.1 | 原始指针事件、`Listener`、`AbsorbPointer`、`IgnorePointer` | 中 | 高 |
| 8.2 | `GestureDetector`、拖拽、缩放、`GestureRecognizer` | 中 | 高 |
| 8.3 | 命中测试、事件分发、`HitTestBehavior` | 高 | 高 |
| 8.4 | 手势识别原理、手势竞技场、冲突处理 | 高 | 高 |
| 8.5 | 全局事件总线、发布订阅模型 | 中 | 中 |
| 8.6 | `Notification`、通知冒泡、自定义通知 | 中 | 高 |

### 学习难度评估

本章的“API 用法”不难，真正的门槛在“为什么会这样”。如果你只记回调名，会写但很容易在嵌套滚动、父子点击冲突、拖拽缩放共存这类问题上卡住；如果把命中测试和手势竞技场想清楚，后面做复杂交互会顺很多。

## 💡 核心概念

### 1. 原始指针事件和手势不是一回事

- 原始指针事件是 `PointerDownEvent`、`PointerMoveEvent`、`PointerUpEvent` 这类底层事件。
- 手势是更高层的语义动作，比如点击、双击、长按、拖动、缩放。
- `Listener` 直接监听指针事件。
- `GestureDetector` 基于 `Listener` 和手势识别器，把一连串指针事件解释成“点击”或“拖拽”之类的手势。

一句话理解：`Listener` 关注“发生了什么接触”，`GestureDetector` 关注“用户想表达什么意图”。

### 2. 命中测试决定谁有资格收到事件

当手指按下时，Flutter 会从渲染树根节点开始做命中测试：

1. 先判断触点是否落在当前对象区域内。
2. 优先递归检查子节点是否命中。
3. 再决定当前节点自己是否命中。
4. 命中的节点会被加入 `HitTestResult`。

这意味着：

- 事件不是“谁离得近谁拿到”，而是“谁通过命中测试谁拿到”。
- 子节点通常比父节点更早进入命中结果。
- `HitTestBehavior` 会影响节点在命中链路中的参与方式，但不会改变手势竞技场的胜负规则。

### 3. 事件冒泡和通知冒泡相似，但不完全一样

- 指针事件会沿命中链分发，像冒泡，但 Flutter 没有浏览器那种通用的“停止触摸事件冒泡”的机制。
- `Notification` 是显式定义的上行消息，它可以通过 `onNotification` 的返回值中断继续向上冒泡。

因此：

- 子组件向父组件回传“发生了某件事”，适合 `Notification`。
- 需要父层观察滚动状态，也适合 `NotificationListener<ScrollNotification>`。

### 4. 手势冲突本质是“竞争处理权”

书里把这个过程讲成手势竞技场（Gesture Arena），这是第8章最重要的原理之一。

- 每个手势识别器都是竞争者。
- 同一根手指产生的事件流中，多个识别器可能同时报名。
- 识别器在足够证据出现后宣布胜出或失败。
- 一般只有一个识别器最终胜出。

常见表现：

- 父子两个 `GestureDetector` 都监听 `onTap` 时，点子组件通常只触发子组件。
- 横向拖拽和纵向拖拽同时监听时，谁先在自身方向上形成明显位移，谁更可能胜出。

### 5. 事件总线能用，但要克制

事件总线适合跨页面广播，比如登录态变化、主题切换、全局提醒等。但它也会带来三个明显问题：

- 依赖关系变隐式，排查来源更难。
- 生命周期管理容易遗漏，可能内存泄漏。
- 过度使用后，业务流向会变得不清晰。

现代 Flutter 项目里，更推荐：

- 页面内局部通信：回调、`ValueNotifier`、`Notification`
- 页面间显式共享状态：`Provider`、`Riverpod`、`Bloc`
- 全局广播：`StreamController.broadcast()` 或成熟状态容器，而不是到处塞单例 Map

### 6. 这几个组件如何选

| 场景 | 推荐方案 | 原因 |
|---|---|---|
| 想拿到底层触点坐标 | `Listener` | 能直接拿到 `PointerEvent` |
| 想处理点击、拖拽、缩放 | `GestureDetector` | 语义更高，代码更短 |
| 想在富文本局部点击 | `TapGestureRecognizer` + `TextSpan` | `TextSpan` 不是 Widget |
| 想监听滚动并让父节点感知 | `NotificationListener<ScrollNotification>` | 天然向上冒泡 |
| 想拦截子树的点击 | `AbsorbPointer` / `IgnorePointer` | 控制命中和响应行为 |

## 📝 代码示例

### 示例1：`Listener` 监听原始指针事件

这个例子演示三个核心点：

- 用 `Listener` 获取按下、移动、抬起位置。
- 对比 `AbsorbPointer` 和 `IgnorePointer`。
- 展示“原始事件”和“语义手势”不是同一层。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const PointerDemoApp());
}

/// 演示原始指针事件的示例应用。
class PointerDemoApp extends StatelessWidget {
  const PointerDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pointer Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const PointerDemoPage(),
    );
  }
}

class PointerDemoPage extends StatefulWidget {
  const PointerDemoPage({super.key});

  @override
  State<PointerDemoPage> createState() => _PointerDemoPageState();
}

class _PointerDemoPageState extends State<PointerDemoPage> {
  String _eventText = '请在蓝色区域按下并移动手指';
  bool _useAbsorbPointer = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('原始指针事件')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _eventText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Listener(
              onPointerDown: (event) {
                setState(() {
                  _eventText =
                      '按下: local=${event.localPosition}, global=${event.position}';
                });
              },
              onPointerMove: (event) {
                setState(() {
                  _eventText = '移动: local=${event.localPosition}';
                });
              },
              onPointerUp: (event) {
                setState(() {
                  _eventText = '抬起: local=${event.localPosition}';
                });
              },
              child: Container(
                height: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('监听区域'),
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              value: _useAbsorbPointer,
              title: const Text('使用 AbsorbPointer'),
              subtitle: Text(
                _useAbsorbPointer
                    ? '父层还能收到事件，子层收不到'
                    : '父层和子层都收不到',
              ),
              onChanged: (value) {
                setState(() {
                  _useAbsorbPointer = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Listener(
              onPointerDown: (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('父层 Listener 收到点击')),
                );
              },
              child: Center(
                child: _useAbsorbPointer
                    ? AbsorbPointer(
                        child: Listener(
                          onPointerDown: (_) {
                            debugPrint('子层收到点击');
                          },
                          child: _buildInnerBox(),
                        ),
                      )
                    : IgnorePointer(
                        child: Listener(
                          onPointerDown: (_) {
                            debugPrint('子层收到点击');
                          },
                          child: _buildInnerBox(),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerBox() {
    return Container(
      width: 220,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        '点击这里测试指针拦截',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
```

**运行效果**：

- 在蓝色区域按下、移动、抬起时，顶部文字会显示坐标变化。
- 开启 `AbsorbPointer` 时，父层提示会出现，但子层不会响应。
- 切换成 `IgnorePointer` 时，整棵子树都不再参与点击处理。

### 示例2：`GestureDetector` 处理点击、拖拽、缩放

这个例子把手势识别最常见的三类行为放在一起：点击、拖动和缩放。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const GestureDemoApp());
}

class GestureDemoApp extends StatelessWidget {
  const GestureDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gesture Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      home: const GestureDemoPage(),
    );
  }
}

class GestureDemoPage extends StatefulWidget {
  const GestureDemoPage({super.key});

  @override
  State<GestureDemoPage> createState() => _GestureDemoPageState();
}

class _GestureDemoPageState extends State<GestureDemoPage> {
  String _message = '尝试点击、双击、长按卡片';
  Offset _offset = const Offset(40, 40);
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('手势识别')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('当前事件'),
                subtitle: Text(_message),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _updateMessage('Tap'),
              onDoubleTap: () => _updateMessage('DoubleTap'),
              onLongPress: () => _updateMessage('LongPress'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '点击 / 双击 / 长按这里',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: _offset.dx,
                      top: _offset.dy,
                      child: GestureDetector(
                        onScaleStart: (details) {
                          _baseScale = _scale;
                        },
                        onScaleUpdate: (details) {
                          setState(() {
                            _offset += details.focalPointDelta;
                            _scale = (_baseScale * details.scale).clamp(0.8, 2.5);
                            _message = details.scale == 1.0
                                ? '拖拽中: $_offset'
                                : '缩放中: ${_scale.toStringAsFixed(2)}x';
                          });
                        },
                        child: Transform.scale(
                          scale: _scale,
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.deepOrange,
                            child: Text(
                              'A',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMessage(String value) {
    setState(() {
      _message = value;
    });
  }
}
```

**运行效果**：

- 顶部卡片会显示当前触发的手势类型。
- 圆形字母可以被拖拽。
- 双指操作时可以缩放圆形字母。

### 示例3：`NotificationListener` 监听滚动和自定义通知

这个例子覆盖两个知识点：

- 父组件监听 `ScrollNotification` 获取滚动进度。
- 子组件通过自定义 `Notification` 向父组件发送消息。

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const NotificationDemoApp());
}

class NotificationDemoApp extends StatelessWidget {
  const NotificationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notification Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const NotificationDemoPage(),
    );
  }
}

/// 自定义通知，向父级汇报消息。
class MessageNotification extends Notification {
  MessageNotification(this.message);

  final String message;
}

class NotificationDemoPage extends StatefulWidget {
  const NotificationDemoPage({super.key});

  @override
  State<NotificationDemoPage> createState() => _NotificationDemoPageState();
}

class _NotificationDemoPageState extends State<NotificationDemoPage> {
  String _message = '还没有收到子组件通知';
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Notification>(
      onNotification: (notification) {
        if (notification is ScrollNotification &&
            notification.metrics.maxScrollExtent > 0) {
          setState(() {
            _progress = (notification.metrics.pixels /
                    notification.metrics.maxScrollExtent)
                .clamp(0.0, 1.0);
          });
        }

        if (notification is MessageNotification) {
          setState(() {
            _message = notification.message;
          });
          return true; // 阻止继续向上冒泡
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('通知机制')),
        body: Column(
          children: [
            LinearProgressIndicator(value: _progress),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: ListTile(
                  title: const Text('父组件收到的消息'),
                  subtitle: Text(_message),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Builder(
                      builder: (innerContext) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: FilledButton(
                            onPressed: () {
                              MessageNotification('子组件点击了按钮').dispatch(
                                innerContext,
                              );
                            },
                            child: const Text('发送自定义通知'),
                          ),
                        );
                      },
                    );
                  }

                  return ListTile(
                    leading: const Icon(Icons.swipe_vertical),
                    title: Text('列表项 $index'),
                    subtitle: const Text('滚动列表以观察 ScrollNotification'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**运行效果**：

- 滚动列表时，顶部进度条会变化。
- 点击按钮后，父组件卡片会显示来自子组件的消息。

### 示例4：现代化事件总线写法

书中用单例 + 回调列表实现事件总线，思路没问题，但现代 Flutter 项目里更建议至少基于 `StreamController.broadcast()` 封装，生命周期更清楚。

```dart
import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const EventBusDemoApp());
}

class EventBusDemoApp extends StatelessWidget {
  const EventBusDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Bus Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const EventBusDemoPage(),
    );
  }
}

sealed class AppEvent {
  const AppEvent();
}

class LoginEvent extends AppEvent {
  const LoginEvent(this.userName);

  final String userName;
}

class LogoutEvent extends AppEvent {
  const LogoutEvent();
}

class AppEventBus {
  AppEventBus._();

  static final AppEventBus instance = AppEventBus._();

  final StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  void fire(AppEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}

class EventBusDemoPage extends StatefulWidget {
  const EventBusDemoPage({super.key});

  @override
  State<EventBusDemoPage> createState() => _EventBusDemoPageState();
}

class _EventBusDemoPageState extends State<EventBusDemoPage> {
  StreamSubscription<LoginEvent>? _loginSubscription;
  StreamSubscription<LogoutEvent>? _logoutSubscription;
  String _status = '未登录';

  @override
  void initState() {
    super.initState();
    _loginSubscription = AppEventBus.instance.on<LoginEvent>().listen((event) {
      setState(() {
        _status = '欢迎回来，${event.userName}';
      });
    });
    _logoutSubscription = AppEventBus.instance.on<LogoutEvent>().listen((event) {
      setState(() {
        _status = '已退出登录';
      });
    });
  }

  @override
  void dispose() {
    _loginSubscription?.cancel();
    _logoutSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('事件总线')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  AppEventBus.instance.fire(const LoginEvent('Rainy'));
                },
                child: const Text('发送登录事件'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  AppEventBus.instance.fire(const LogoutEvent());
                },
                child: const Text('发送退出事件'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**运行效果**：

- 点击不同按钮时，页面状态文字会随事件广播变化。
- 订阅关系集中在 `initState` / `dispose`，更符合 Flutter 生命周期。

## ⚠️ 版本变更

第8章的核心 API 在当前 Flutter 版本里仍然有效，但实践重点已经比书里更偏向多端输入和可访问性。

### 仍然可用的核心 API

- `Listener`
- `GestureDetector`
- `RawGestureDetector`
- `NotificationListener`
- `Notification`
- `TapGestureRecognizer`
- `AbsorbPointer`
- `IgnorePointer`

### 当前版本下需要额外注意的点

1. `Listener` 不处理悬停语义。
   现代桌面/Web 场景中，如果要处理鼠标悬停、移入、移出，应优先用 `MouseRegion`，而不是硬拿 `Listener` 顶。

2. `GestureDetector` 已经更偏多端。
   当前 API 提供了 `supportedDevices`、`trackpadScrollCausesScale`、`excludeFromSemantics` 等能力，移动端之外的输入设备支持比书里更重要。

3. Material 点击反馈通常优先 `InkWell`。
   如果你在 `Material` 表面做普通点按交互，`InkWell`/`InkResponse` 比纯 `GestureDetector` 更符合 Material 设计，也自带水波纹反馈。

4. 富文本点击要记得释放识别器。
   `TextSpan.recognizer` 常配合 `TapGestureRecognizer` 使用；识别器如果放在 `State` 中，需要在 `dispose()` 里释放。

5. 事件总线不再是默认首选。
   书里把它当成跨组件通信示例是合理的，但真实项目里，大量使用全局总线通常会让业务依赖失控。优先考虑显式状态管理或局部通知机制。

### 推荐写法对比

```dart
// ❌ 书中思路：全局单例 + 动态 Map + 未约束事件类型
typedef void EventCallback(arg);

// ✅ 当前更推荐：用强类型事件 + broadcast Stream
sealed class AppEvent {
  const AppEvent();
}

class LoginEvent extends AppEvent {
  const LoginEvent(this.userName);
  final String userName;
}
```

```dart
// ❌ 只考虑触摸屏
GestureDetector(
  onScaleUpdate: _handleScale,
  child: child,
)

// ✅ 当前可进一步考虑桌面触控板与语义
GestureDetector(
  onScaleUpdate: _handleScale,
  trackpadScrollCausesScale: true,
  child: child,
)
```

## 🎯 实践建议

### 学习重点

- 先把 `Listener` 和 `GestureDetector` 的边界讲清楚，再记回调。
- 把“命中测试”和“手势竞技场”分开理解。
- 看懂 `Notification` 为什么必须从后代节点的 `BuildContext` 发出。

### 常见错误

- 在父子 `GestureDetector` 都监听 `onTap` 时，以为两个都会触发。
  解决：这是典型手势竞争问题，不是 `setState` 失效。

- 用根 `context` 调用 `MyNotification().dispatch(context)`，结果监听不到。
  解决：必须从 `NotificationListener` 的后代节点发出，必要时用 `Builder` 拿内部 `context`。

- 把 `HitTestBehavior.opaque` 当成“强制父子都响应手势”开关。
  解决：它影响命中参与方式，不改变手势竞技场只能有一方胜出的默认规则。

- 在富文本中创建 `TapGestureRecognizer` 却不释放。
  解决：放进 `State` 中统一 `dispose()`。

### 性能优化建议

- 长列表滚动状态监听时，优先把变化范围控制小，不要每次滚动都重建整个页面。
- 需要拖拽或缩放的组件，尽量只更新位置、缩放值，不要在回调里做重逻辑。
- 大量手势交互的页面里，优先拆小组件，缩小重建范围。
- 如果只是观察列表滚动位置并驱动“返回顶部”按钮，`NotificationListener` 或 `ScrollController` 都可以；如果还要执行跳转、吸顶等命令式控制，`ScrollController` 通常更直接。

### 实战练习

#### 练习1：事件实验室（完整代码）

**目标**：在一个页面里同时练习原始指针、手势拖拽缩放、滚动通知、自定义通知和返回顶部按钮。

**完整代码**：

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const GestureLabApp());
}

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
    return SizedBox(
      height: 280,
      child: DecoratedBox(
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
                        _cardOffset += details.focalPointDelta;
                        _scale =
                            (_baseScale * details.scale).clamp(0.8, 2.4);
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
      ),
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
```

**运行效果**：

- 顶部区域会实时显示指针按下、移动、抬起坐标。
- 中间卡片支持点击、拖拽、双击重置和双指缩放。
- 向下滚动列表后会出现“回到顶部”按钮。
- 子组件通过自定义通知把交互结果回传到状态面板。

**学习要点**：

- 原始指针事件在 `_buildPointerSection()` 中通过 `Listener` 处理。
- 手势拖拽和缩放在 `_buildGestureSection()` 中通过 `GestureDetector` 处理。
- 滚动通知在页面根部的 `NotificationListener` 中监听。
- 自定义通知通过 `LabMessageNotification` 完成子到父通信。

#### 练习2：扩展挑战

- 给拖拽卡片增加边界限制，不允许拖出容器。
- 在拖拽结束时吸附到最近角落。
- 用 `TapGestureRecognizer` 给一段富文本中的“查看规则”做局部点击。
- 把状态面板拆成独立组件，验证通知链是否仍然正确。

## 📚 扩展学习

### 相关章节

- 第6章：可滚动组件
  这一章和 `ScrollNotification`、`ScrollController` 配合最紧密。

- 第7章：功能型组件
  如果你在想“事件上报和状态共享有什么区别”，第7章的 `InheritedWidget`、`Provider` 正好能补上。

- 第9章：动画
  拖拽回弹、缩放过渡、手势驱动动画，本质上是第8章和第9章一起用。

- 第14章：Flutter核心原理
  如果第8章的命中测试和事件分发还不够过瘾，第14章会把 `RenderObject`、布局和点击测试讲得更深。

### 进阶学习路径

1. 先熟练 `Listener` 与 `GestureDetector` 的常见回调。
2. 再理解 `HitTestBehavior`、命中测试和手势竞技场。
3. 然后做复杂交互：父子滚动、缩放拖拽共存、富文本局部点击。
4. 最后再进入源码层，读 `GestureDetector`、`RawGestureDetector`、`GestureBinding`。

### 参考资料

- 《Flutter实战·第二版》第8章总览：https://book.flutterchina.club/chapter8/
- 8.1 原始指针事件处理：https://book.flutterchina.club/chapter8/listener.html
- 8.2 手势识别：https://book.flutterchina.club/chapter8/gesture.html
- 8.3 Flutter事件机制：https://book.flutterchina.club/chapter8/hittest.html
- 8.4 手势原理与手势冲突：https://book.flutterchina.club/chapter8/gesture_conflict.html
- 8.5 事件总线：https://book.flutterchina.club/chapter8/eventbus.html
- 8.6 通知 Notification：https://book.flutterchina.club/chapter8/notification.html
- Flutter `GestureDetector` API：https://api.flutter.dev/flutter/widgets/GestureDetector-class.html
- Flutter `Listener` API：https://api.flutter.dev/flutter/widgets/Listener-class.html
- Flutter `NotificationListener` API：https://api.flutter.dev/flutter/widgets/NotificationListener-class.html
- Flutter gestures library：https://api.flutter.dev/flutter/gestures/

## 总结

第8章的真正价值不只是“会写 `onTap`”，而是建立一套交互理解模型：

- 事件先命中测试，再分发。
- 原始指针事件和语义手势是两层系统。
- 父子手势冲突本质是竞技场竞争。
- 通知是子到父的显式上行通信。
- 事件总线可以用，但应该是少数场景下的工具，不该成为默认架构。

如果你把这五句话吃透了，后面做复杂交互、可滚动页面、自定义组件和动画联动时，思路会稳定很多。
